library(shiny)
library(shinyjs)
library(lubridate)   # for time 
source("initialize_board.R")

ui <- fluidPage(
  # Add CSS to position the buttons
  tags$head(
    tags$style(HTML("
    body {
    background-color: #0066CC;
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
      #reset0{
      color: red;
      background-color: yellow;
      
      }
      
      #timeleft {
        position: absolute;
        width: 120px; 
        height: 35px;
        top: 10px;
        left: 90px;
        background-color: red;
        border-radius:8px;
        border: 0px solid black;
      }
    "))
  ),
  useShinyjs(),
  headerPanel('Minesweeper Game'),
  sidebarPanel(
    sliderInput("numberMine", "number of mines :", min = 5, max = 100, value = 5),
    sliderInput('numberRow', "number of row :", 6, min = 4, max = 30),
    sliderInput('numberCol', "number of row :", 8, min = 4, max = 30),
    actionButton("reset0" , "reset"), 
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
  
  # Create the grid 
  grid <- reactive({
    n = NR()
    p = NC()
    fluidRow(
      align = "center",
      br(),
      column(width = 8, offset = 2,
             div(id = "grid",
                 lapply(1:n, function(i) {
                   div(
                     lapply(1:p, function(j) {
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
  
  # Desplay the Grid
  output$buttonGroup <- renderUI({     
    grid()
  })
  
  # liste of descovered buttons
  discovered <- reactiveValues(disc=c()) 
  flaged <- reactiveValues(fla=c())
  
  
  # the matrix that contains the hiden values. (-1 = mine)
  board <- eventReactive (c(input$reset, input$reset0),{
      initialize_board(NR(),NC(), NM())
    }) 
  
  
  
  # Reset the game
    observeEvent(input$reset0,{
    timer(0)                # reset the time 
    active(FALSE)           # active the time
    discovered$disc = c()   # rest the discovered liste into empty
    flaged$fla      = c()
    updateActionButton(session,"StayFlag", paste0("Number of flags left 🚩 : ", flagleft() ))
    flagClicked$count = 0   #rest the counter of flags left
    updateSliderInput(session, "numberMine", value = 5)
    updateSliderInput(session, "numberRow", value = 6)
    updateSliderInput(session, "numberCol", value = 8)
    output$buttonGroup <- renderUI({    # recreate the Grid buttons 
      grid()
    })
  })
    
    
  
  # Restart the Programme
  observeEvent(input$reset,{
    
    global$clicked = ""
    updateActionButton(session, "reset", "Re-start")   # change the label of reset from start into restart
    discovered$disc = c()                             # rest the discovered liste into empty
    flaged$fla      = c()
    updateActionButton(session,"StayFlag", paste0("Number of flags left 🚩 : ", flagleft() )) 
    flagClicked$count = 0   #rest the counter of flags left
    timer(0)                # reset the time 
    active(TRUE)           # active the time
    output$buttonGroup <- renderUI({    # recreate the Grid buttons 
      grid()
  })
  })
  
  # Initialize the timer, not active.
  timer <- reactiveVal(0)
  active <- reactiveVal(FALSE)
  update_interval = 0.1 # How many seconds between timer updates?
 
  # Output the time left.
  output$timeleft <- renderText({
    paste("⏰",round(seconds_to_period(timer()),0))
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
  NC <- reactive({input$numberCol})
  
  # Conditions: the number of mines have to be < numberof row **2
  observe({
    if (NM() >= NR()*NC() -1  ){
      showModal(modalDialog(h4(paste0("Are you a terrorist ? Too many mines!! max "),NR()*NC() -1, "💣" ), easyClose = FALSE))
      updateSliderInput(session, "numberMine", value = 5)
    }
  })
  
  observeEvent(c(input$numberMine,input$numberRow),{
    timer(0)
    active(FALSE)
  })

  global <- reactiveValues(clicked = "")
  
  observeEvent(input$flag, {
    global$clicked = TRUE
    active(TRUE)})
  observeEvent(input$bomb, {
    global$clicked = FALSE
    active(TRUE)})
  
  flagClicked = reactiveValues(count = 0)   # use the counter to count the number of flags used
  flagleft     = reactive(NM()-flagClicked$count)   # the number of falgs dispo
  
  observe({
    lapply(1:NR(), function(i) {
      lapply(1:NC(), function(j) {
        id <- paste0("btn", i, j)
        observeEvent(input[[id]], {
          if (global$clicked == TRUE){
            if (flagleft()==0 ){
              showNotification("You reach the number of flag disponible", type = "message")
            }
            
            if ((flagleft()!=0) || (id %in% flaged$fla)){  # the secend condition  is for flagleft but i want to change cancel one flag  
            # add or cancel the flag on button
            if ((sum(flaged$fla ==id ) %% 2) == 0 ){    # verifie if the number of id button exist in the flaglist pair not 
            flaged$fla =  cbind(flaged$fla,id) # add the falgs or unflag button 
            flagClicked$count = flagClicked$count+1   # count
            updateActionButton(session, id, label = "🚩")  # add flag
            updateActionButton(session,"StayFlag", paste0("Number of flags left 🚩 : ", flagleft() ))
            }
            else {  
              flaged$fla =  cbind(flaged$fla,id)  
              flagClicked$count = flagClicked$count-1   # count
              updateActionButton(session, id, label = "")   # Cancel flag 
              updateActionButton(session,"StayFlag", paste0("Number of flags left 🚩 : ", flagleft() ))
              
            }
          }
          }
          if (global$clicked == FALSE ){
            
            if ((sum(flaged$fla ==id ) %% 2) == 0){
            if (board()[i, j] == -1) {
              # If the button is a mine, reveal all mines and end the game
              for (x in 1:NR()) {    # descover  the Grid
                for (y in 1:NC()) {
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
              active(FALSE)    # stop the stopwatch
              showModal(modalDialog(h4(paste0("Game over! You hit a mine 🙁 🙁 🙁.  time Passed : " ,
                                              round(seconds_to_period(timer())),0)), easyClose = TRUE))
            }else {shinyjs::disable(id)
              # If the button is not a mine, reveal the button and any adjacent buttons with 0 mines
              updateActionButton(session, id, label = board()[i, j])
              discovered$disc =  cbind(discovered$disc,id) #### augmente 
              if (board()[i, j] == 0) {
                for (x in max(i-1,1):min(i+1,NR())) {
                  for (y in max(j-1,1):min(j+1,NC())) {
                    if (board()[x, y] != -1 ) {
                      adjacent_button_id <- paste0("btn",x, y)
                      
                      if ((!adjacent_button_id %in% discovered$disc) &&
                          ((sum(flaged$fla ==adjacent_button_id ) %% 2) == 0) ){ # dont discover the flags button
                      discovered$disc =  cbind(discovered$disc,adjacent_button_id)
                      shinyjs::disable(adjacent_button_id) 
                        # Only reveal adjacent buttons if they have not been clicked yet
                        updateActionButton(session, adjacent_button_id, label = board()[x, y])
                    }
                    }
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
  
  observe({
    if ((length(discovered$disc) + flagClicked$count ) == (NR()*NC())){
      showModal(modalDialog(h4(paste0("congrat! You Win 😀😀😀. time Passed: " ,
                                      round(seconds_to_period(timer())),0)), easyClose = TRUE))
      active(FALSE) # stop the stopwatch
    }
  })
}

shinyApp(ui, server)