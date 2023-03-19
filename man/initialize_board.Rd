\name{initialize_board}
\alias{Board}
\title{Make the hiden matrix}
\usage{
initialize_board((rowNumber, colNumber, MineNumber))
}
\description{
It's a function take the number of rows and columns, number of Mines (NM) as input and create a matrix of the specified size. We randomly select a NM of cells to contain mines, while the remaining cells are assigned values indicating how many neighboring cells contain mines. This results in a board with randomly placed mines and calculated values for each cell. The player can use these values to determine the location of hidden mines while uncovering cells one by one.
\examples{
initialize_board(5, 8, 6)
}
