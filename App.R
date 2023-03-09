library(shiny)

ui <- fluidPage(
  headerPanel('Minesweeper Game'),
  #tags$style(HTML("body {background-color: green;}")),
  
  sidebarPanel(
    selectInput('xcol', 'difficulty', c("Easy", "Normal", "Hard"), selected = "Normal")
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
  global <- reactiveValues(clicked = "")
  
  
  observeEvent(input$flag, {global$clicked = TRUE})
  observeEvent(input$bomb, {global$clicked = FALSE})
  
  observe({
    lapply(1:10, function(i) {
      lapply(1:10, function(j) {
        id <- paste0("btn", i, j)
        observeEvent(input[[id]], {
          if (global$clicked == TRUE){
            updateActionButton(session, paste0("btn", i, j), label = "🚩")}
          
          if (global$clicked == FALSE){
            updateActionButton(session, paste0("btn", i, j), label = "1")}
        })
      })
    })
  })
  
  
  observeEvent(input$btn2, {
    if (global$clicked == TRUE){
      updateActionButton(session, "btn2", label = "🚩")}
    if (global$clicked == FALSE){
      updateActionButton(session, "btn2", label = "1")}
  })
  
}

shinyApp(ui, server)