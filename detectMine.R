#fonction qui donne le nombre de mines autours d'une case de coordonnées (i,j)
detectMine <- function(i,j) {
  if (i==1 && j==1){n <- sum(grille[1:2,1:2])}
  else if (i==1 && j==8){n <- sum(grille[1:2,7:8])}
  else if (i==8 && j==8){n <- sum(grille[7:8,7:8])}
  else if (i==8 && j==1){n <- sum(grille[7:8,1:2])}
  else (n <- sum(grille[(i-1):(i+1),(j-1):(j+1)]))
  n
}
