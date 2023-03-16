#fonction qui créer une grille 8x8 avec 10 mines
#elle crée une ligne avec 10 mines (codées par des 1) et 53 cases vides (codées
#par des 0) ensuite on ajoute un 0 à la position du premier clic du joueur


creaGrille <- function(x,y){
  ligne <- sample(c( rep(0,53) , rep(1,10) ))
  ligne <- c(ligne[1:(x*8+y)], 0, ligne[(x*8+y+1):63])
  grille <- matrix(data = ligne, nrow = 8, ncol = 8, byrow=TRUE)
}


#exemple de grille où le joueur clique sur la case (4,5)
a <- 4
b <- 5
grilleExemple <- creaGrille(a, b)
