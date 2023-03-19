#'@title Minesweeper Game
#'
#'
#'@return : Application Minesweeper
#'@author EL ALLAKI Otmane
#'
#'@export
#'
#'


Application <- function() {

  appDir <- system.file('shiny', package = "minesweeper")
  shiny::runApp(appDir)

}
