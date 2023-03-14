library(shiny)
library(shinyjs)
library(lubridate)   # for time 
source("initialize_board.R")



ui <- fluidPage(
  # Add CSS to position the buttons
  tags$head(
    tags$style(HTML("
    body {
    background-color: green;
    }
    
    #grid button { 
    width: 50px; height: 50px; 
    }
    
    #reset {
        position: absolute;
        top: 50px;
        left: 10px;
    
      }
      #flag {
        position: absolute;
        top: 150px;
        left: 10px;
      }
      
      #bomb {
        position: absolute;
        top: 100px;
        left: 10px;
      }
      
      #timeleft {
        position: absolute;
        width: 120px; 
        height: 35px;
        top: 10px;
        left: 110px;
        background-color: red;
        border-radius:4px;
        border: 1px solid black;

        
      }
    "))
  ),
  useShinyjs(),
  headerPanel('Minesweeper Game'),
  #tags$style(HTML("body {background-color: green;}")),
  
  sidebarPanel(
    sliderInput("numberMine", "number of mines :", min = 5, max = 100, value = 5),
    
    sliderInput('numberRow', "number of row :", 6, min = 4, max = 30),
    
    textOutput("clickedNum")
  ),
  
  mainPanel(
    h4(textOutput('timeleft')),
    actionButton("reset", "Start"),
    actionButton("StayFlag", "Number of flags left 🚩: 5"),
    uiOutput("buttonGroup"),
      align = "center",
      actionButton("flag", "🚩"),
      actionButton("bomb", "💣")
  )
)

server <- function(input, output, session) {
  
  observeEvent(input$reset,{
    updateActionButton(session, "reset", "Restart")
  })
  
  board <- eventReactive (input$reset,{
      initialize_board(NR(), NM())
    }) 
  
  observeEvent(input$reset,{
  updateActionButton(session,"StayFlag", paste0("Number of flags left 🚩 : ", flagleft() ))
  flagClicked$count = 0   #rest the counter if flags left
  timer(0)   # reset the time 
  active(FALSE)
  
  output$buttonGroup <- renderUI({
    n = input$numberRow
    fluidRow(
      align = "center",
      br(),
      
      column(width = 8, offset = 2,
             #tags$style(type = "text/css", "#grid button { width: 50px; height: 50px; }"),
             
             div(id = "grid",
                 lapply(1:n, function(i) {
                   div(
                     lapply(1:n, function(j) {
                       actionButton(paste0("btn", i, j), "", #example, when i = 3 and j = 5, the expression paste0("btn", i, j) evaluates to the string "btn35"
                                    style = "color: white; background-color: grey;")
                     }),
                     style = "display: flex;"
                   )
                 }),
                 style = "display: flex; flex-direction: column;"
             )
      )
    )
  })
  })
  
  # Initialize the timer, not active.
  timer <- reactiveVal(0)
  active <- reactiveVal(FALSE)
  update_interval = 0.30 # How many seconds between timer updates?
  
 
  # Output the time left.
  output$timeleft <- renderText({
    paste("⏰",seconds_to_period(timer()))
  })
  
  # observer that invalidates every second. If timer is active, decrease by one.
  observe({
    invalidateLater(100, session)
    isolate({
      if(active())
      {
        timer(round(timer()+update_interval,1))
      }
    })
  })
  
  NM <- reactive({input$numberMine})
  NR <- reactive({input$numberRow})

  
  
  global <- reactiveValues(clicked = "")
  
  
  observeEvent(input$flag, {
    active(TRUE)
    global$clicked = TRUE})
  observeEvent(input$bomb, {
    active(TRUE)
    global$clicked = FALSE})
  
  clickedNum = reactiveVal(0)   # use the counter to count the number saved clicked
  flagClicked = reactiveValues(count = 0)   # use the counter to count the number of flags used
  flagleft     = reactive(NM()-flagClicked$count)   # the number of falgs dispo
  
  observe({
    
    lapply(1:NR(), function(i) {
      lapply(1:NR(), function(j) {
        id <- paste0("btn", i, j)
        observeEvent(input[[id]], {
          if (global$clicked == TRUE){
            flagClicked$count = flagClicked$count+1   # count
            updateActionButton(session, paste0("btn", i, j), label = "🚩") 
            updateActionButton(session,"StayFlag", paste0("Number of flags left 🚩 : ", flagleft() ))}
        
          if (global$clicked == FALSE ){
            
            if (board()[i, j] == -1) {
              # If the button is a mine, reveal all mines and end the game
              for (x in 1:NR()) {    # unhide the game
                for (y in 1:NR()) {
                  button_id <-paste0("btn",x, y)
                  shinyjs::disable(button_id)
                  
                  if (board()[x, y] == -1) {
                    updateActionButton(session, button_id, label = "💣") 
                  }
                  else{
                  updateActionButton(session, button_id, label = board()[x, y])
                  }
                }
              }
              active(FALSE)
              showModal(modalDialog(h4(paste0("Game over! You hit a mine 🙁 🙁 🙁. \n Your time : " ,seconds_to_period(timer()))), easyClose = TRUE))
              
            }else {shinyjs::disable(id)
              # If the button is not a mine, reveal the button and any adjacent buttons with 0 mines
              updateActionButton(session, id, label = board()[i, j])
              clickedNum(1+clickedNum())  # count save clicked
              if (board()[i, j] == 0) {
                for (x in max(i-2,1):min(i+2,NR())) {
                  for (y in max(j-2,1):min(j+2,NR())) {
                    if (board()[x, y] != -1) {
                      adjacent_button_id <- paste0("btn",x, y)
                     # if (!input[[adjacent_button_id]]) {
                        shinyjs::disable(adjacent_button_id) 
                        
                        if (isTruthy(!input[[adjacent_button_id]])){ #check if the button is off 
                        clickedNum(1+clickedNum()) # count save clicked
                        # Only reveal adjacent buttons if they have not been clicked yet
                        updateActionButton(session, adjacent_button_id, label = board()[x, y])
                      }
                    #}
                    }
                  }
                }
              }
            }
          }
        })
      })
    })
  })
  
  output$clickedNum <- renderText({
    paste("clickedNum: ",clickedNum() )
  })
  
  observe({
    if ((clickedNum() + flagClicked$count ) == (NR()*NR())){
      showModal(modalDialog(h4(paste0("congrat! You Win 😀😀😀. Your time : " ,seconds_to_period(timer()))), easyClose = TRUE))
      active(FALSE)
    }
  })
  
  
  
}
### showNotification("Button clicked!", type = "message")
shinyApp(ui, server)