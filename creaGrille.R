#fonction qui créer une grille 8x8 avec 10 mines
#elle crée une ligne avec 10 mines (codées par des 1) et 53 cases vides (codées
#par des 0) ensuite on ajoute un 0 à la position du premier clic du joueur

creaGrille <- function(x,y){
  ligne <- sample(c( rep(c(0,0,0,1,0,0), each = 10), rep(0,3) ))
  ligne <- c(ligne[1:(x*8+y)], 0, ligne[(x*8+y+1):63])
  grille <- matrix(data = ligne, nrow = 8, ncol = 8, byrow=TRUE)
}


#exemple de grille où le joueur clique sur la case (4,5)
a <- 4
b <- 5
grilleExemple <- creaGrille(a, b)


