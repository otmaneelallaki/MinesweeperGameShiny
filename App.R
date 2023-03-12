library(shiny)
library(shinyjs)
#library(lubridate)
source("initialize_board.R")



ui <- fluidPage(
  useShinyjs(),
  headerPanel('Minesweeper Game'),
  tags$style(HTML("body {background-color: green;}")),
  
  sidebarPanel(
    sliderInput("numberMine", "number of mines :", min = 10, max = 100, value = 10),
    
    sliderInput('numberRow', "number of row :", 10, min = 4, max = 30),
    
    actionButton("reset", "New partie"),
    
    textOutput('timeleft')
  ),
  
  mainPanel(
    column(
      2,
      align = "center",
      actionButton("flag", "🚩"),
      actionButton("bomb", "💣")),
      uiOutput("buttonGroup")
  )
)

server <- function(input, output, session) {
  
  output$buttonGroup <- renderUI({
    n = input$numberRow
    fluidRow(
      align = "center",
      br(),
      
      column(width = 8, offset = 2,
             tags$style(type = "text/css", "#grid button { width: 50px; height: 50px; }"),
             
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
  
  # Initialize the timer, not active.
  timer <- reactiveVal(0)
  active <- reactiveVal(FALSE)
  update_interval = 0.30 # How many seconds between timer updates?
  
  # Output the time left.
  output$timeleft <- renderText({
    paste("Time passed: ", seconds_to_period(timer()))
  })
  
  # observer that invalidates every second. If timer is active, decrease by one.
  observe({
    invalidateLater(100, session)
    isolate({
      if(active())
      {
        timer(round(timer()+update_interval,2))
      }
    })
  })
  
  NM <- reactive({input$numberMine})
  NR <- reactive({input$numberRow})
  
  board <- reactive({
    initialize_board(NR(), NM())
  })
  #rv <- reactiveValues(board = initialize_board)
  #board() <- initialize_board()
  
  global <- reactiveValues(clicked = "")
  
  
  observeEvent(input$flag, {
    active(TRUE)
    global$clicked = TRUE})
  observeEvent(input$bomb, {
    active(TRUE)
    global$clicked = FALSE})
  
  observe({
    lapply(1:NR(), function(i) {
      lapply(1:NR(), function(j) {
        id <- paste0("btn", i, j)
        observeEvent(input[[id]], {
          if (global$clicked == TRUE){
            
            updateActionButton(session, paste0("btn", i, j), label = "🚩")}
          
          if (global$clicked == FALSE){
            
            if (board()[i, j] == -1) {
              # If the button is a mine, reveal all mines and end the game
              for (x in 1:NR()) {
                for (y in 1:NR()) {
                  button_id <-paste0("btn",x, y)
                  updateActionButton(session, button_id, label = board()[x, y])
                }
              }
              active(FALSE)
              showModal(modalDialog("Game over! You hit a mine.", easyClose = TRUE))
            }else {shinyjs::disable(id)
              # If the button is not a mine, reveal the button and any adjacent buttons with 0 mines
              updateActionButton(session, id, label = board()[i, j])
              if (board()[i, j] == 0) {
                for (x in max(i-2,1):min(i+2,NR())) {
                  for (y in max(j-2,1):min(j+2,NR())) {
                    if (board[x, y] != -1) {
                      adjacent_button_id <- paste0("btn",x, y)
                      if (!input[[adjacent_button_id]]) {
                        shinyjs::disable(adjacent_button_id) 
                        # Only reveal adjacent buttons if they have not been clicked yet
                        updateActionButton(session, adjacent_button_id, label = board[x, y])
                      }
                    }
                  }
                }
              }
            }
            #updateActionButton(session, paste0("btn", i, j), label = "1")
          }
        })
      })
    })
  })
  
  
  
  
}

shinyApp(ui, server)