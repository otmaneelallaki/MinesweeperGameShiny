#fonction qui donne le nombre de mines autours d'une case de coordonnées (i,j)
detectMine <- function(grille, i, j) {
  l <- sqrt(length(grille))
  if (i==1 && j==1){n <- sum(grille[1:2,1:2])}
  else if (i==1 && j==l){n <- sum(grille[1:2,(l-1):l])}
  else if (i==l && j==l){n <- sum(grille[(l-1):l,(l-1):l])}
  else if (i==l && j==1){n <- sum(grille[(l-1):l,1:2])}
  else if (i==1){n <- sum(grille[1:2,(j-1):(j+1)])}
  else if (i==l){n <- sum(grille[(l-1):l,(j-1):(j+1)])}
  else if (j==1){n <- sum(grille[(i-1):(i+1),1:2])}
  else if (j==l){n <- sum(grille[(i-1):(i+1),(l-1):l])}
  else (n <- sum(grille[(i-1):(i+1),(j-1):(j+1)]))
  n
}
