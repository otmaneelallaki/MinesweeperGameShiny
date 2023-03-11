library(shiny)
library(shinyjs)
library(lubridate)

initialize_board <- function() {
  # Create a blank 8x8 game board
  board <- matrix(0, nrow = 10, ncol = 10)
  
  # Randomly place 10 mines on the game board
  mine_indices <- sample(1:100, 10, replace = FALSE)
  board[mine_indices] <- -1
  
  # Assign the appropriate number of mines to each button based on its adjacent buttons
  for (i in 1:10) {
    for (j in 1:10) {
      if (board[i, j] != -1) {
        num_adjacent_mines <- sum(board[max(i-1,1):min(i+1,10), max(j-1,1):min(j+1,10)] == -1)
        board[i, j] <- num_adjacent_mines
      }
    }
  }
  
  return(board)
}

ui <- fluidPage(
  useShinyjs(),
  headerPanel('Minesweeper Game'),
  #tags$style(HTML("body {background-color: green;}")),
  
  sidebarPanel(
    selectInput('xcol', 'difficulty', c("Easy", "Normal", "Hard"), selected = "Normal"),
    textOutput('timeleft')
  ),
  
  mainPanel(
    column(
      2,
      align = "center",
      actionButton("flag", "🚩"),
      actionButton("bomb", "💣")),
    
    fluidRow(
      align = "center",
      br(),
      
      column(width = 8, offset = 2,
             tags$style(type = "text/css", "#grid button { width: 50px; height: 50px; }"),
             
             div(id = "grid",
                 lapply(1:10, function(i) {
                   div(
                     lapply(1:10, function(j) {
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
  )
)

server <- function(input, output, session) {
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
  
  rv <- reactiveValues(board = initialize_board)
  rv$board <- initialize_board()
  
  global <- reactiveValues(clicked = "")
  
  
  observeEvent(input$flag, {
    active(TRUE)
    global$clicked = TRUE})
  observeEvent(input$bomb, {
    active(TRUE)
    global$clicked = FALSE})
  
  observe({
    lapply(1:10, function(i) {
      lapply(1:10, function(j) {
        id <- paste0("btn", i, j)
        observeEvent(input[[id]], {
          if (global$clicked == TRUE){
            
            updateActionButton(session, paste0("btn", i, j), label = "🚩")}
          
          if (global$clicked == FALSE){
            
            if (rv$board[i, j] == -1) {
              # If the button is a mine, reveal all mines and end the game
              for (x in 1:10) {
                for (y in 1:10) {
                  button_id <-paste0("btn",x, y)
                  updateActionButton(session, button_id, label = rv$board[x, y])
                }
              }
              active(FALSE)
              showModal(modalDialog("Game over! You hit a mine.", easyClose = TRUE))
            }else {shinyjs::disable(id)
              # If the button is not a mine, reveal the button and any adjacent buttons with 0 mines
              updateActionButton(session, id, label = rv$board[i, j])
              if (rv$board[i, j] == 0) {
                for (x in max(i-2,1):min(i+2,10)) {
                  for (y in max(j-2,1):min(j+2,10)) {
                    if (rv$board[x, y] != -1) {
                      adjacent_button_id <- paste0("btn",x, y)
                      if (!input[[adjacent_button_id]]) {
                        shinyjs::disable(adjacent_button_id) 
                        # Only reveal adjacent buttons if they have not been clicked yet
                        updateActionButton(session, adjacent_button_id, label = rv$board[x, y])
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