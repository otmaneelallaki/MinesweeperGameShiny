GenerateMineSweeperMap <- function(n, k) {
  arr <- matrix(rep(0, n^2), ncol = n)
  for (i in 1:k) {
    x <- sample(1:n, 1) # pick a random column
    y <- sample(1:n, 1) # pick a random row
    arr[y, x] <- "X"
    if (x > 1) {
      if (arr[y, x-1] != "X") arr[y, x-1] <- as.character(as.numeric(arr[y, x-1]) + 1) # center left
      if (y > 1 && arr[y-1, x-1] != "X") arr[y-1, x-1] <- as.character(as.numeric(arr[y-1, x-1]) + 1) # top left
      if (y < n && arr[y+1, x-1] != "X") arr[y+1, x-1] <- as.character(as.numeric(arr[y+1, x-1]) + 1) # bottom left
    }
    if (x < n) {
      if (arr[y, x+1] != "X") arr[y, x+1] <- as.character(as.numeric(arr[y, x+1]) + 1) # center right
      if (y > 1 && arr[y-1, x+1] != "X") arr[y-1, x+1] <- as.character(as.numeric(arr[y-1, x+1]) + 1) # top right
      if (y < n && arr[y+1, x+1] != "X") arr[y+1, x+1] <- as.character(as.numeric(arr[y+1, x+1]) + 1) # bottom right
    }
    if (y > 1 && arr[y-1, x] != "X") arr[y-1, x] <- as.character(as.numeric(arr[y-1, x]) + 1) # top center
    if (y < n && arr[y+1, x] != "X") arr[y+1, x] <- as.character(as.numeric(arr[y+1, x]) + 1) # bottom center
  }
  return(arr)
}

GeneratePlayerMap <- function(n) {
  arr <- matrix('-', nrow=n, ncol=n, byrow=TRUE)
  return(arr)
  
DisplayMap <- function(map) {
    for (row in map) {
      cat(paste(paste(row, collapse = " "), "\n", sep = ""))
    }
    cat("\n")
  }
  
CheckWon <- function(map) {
    for (row in map) {
      for (cell in row) {
        if (cell == "-") {
          return(FALSE)
        }
      }
    }
    return(TRUE)
  }
  
CheckContinueGame <- function(score) {
    cat("Your score: ", score, "\n")
    isContinue <- readline(prompt = "Do you want to try again? (y/n) :")
    if (isContinue == "n") {
      return(FALSE)
    }
    return(TRUE)
  }
}

Game <- function() {
  GameStatus <- TRUE
  
  while (GameStatus) {
    difficulty <- readline(prompt = "Select your difficulty (b, i, h):")
    
    if (tolower(difficulty) == "b") {
      n <- 5
      k <- 3
    } else if (tolower(difficulty) == "i") {
      n <- 6
      k <- 8
    } else {
      n <- 8
      k <- 20
    }
    
    minesweeper_map <- GenerateMineSweeperMap(n, k)
    player_map <- GeneratePlayerMap(n)
    score <- 0
    
    while (TRUE) {
      if (CheckWon(player_map) == FALSE) {
        cat("Enter the cell you want to open: \n")
        x <- as.integer(readline(prompt = "X (1 to 5): "))
        y <- as.integer(readline(prompt = "Y (1 to 5): "))
        
        if (minesweeper_map[y,x] == "X") {
          cat("Game Over!\n")
          DisplayMap(minesweeper_map)
          GameStatus <- CheckContinueGame(score)
          break
        } else {
          player_map[y,x] <- minesweeper_map[y,x]
          DisplayMap(player_map)
          score <- score + 1
        }
      } else {
        DisplayMap(player_map)
        cat("You have Won!\n")
        GameStatus <- CheckContinueGame(score)
        break
      }
    }
  }
}
Game()
b
1
1
