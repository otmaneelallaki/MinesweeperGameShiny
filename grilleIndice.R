grilleIndice <- function(grille){
  n <- length(grille)
  l <- sqrt(n)
  matrice <- matrix(rep(0, n), nrow = 8)
  for (k in 1:l){
    for (s in 1:l){
      matrice[k,s] <- detectMine(grille, k, s)
    }
  }
  matrice
}
