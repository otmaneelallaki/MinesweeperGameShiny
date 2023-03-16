decouvre <- function(grille1, grille2, grille3, i, j){
  grilleInter <- grille3
  if (grille2[i,j]==0){
    jj <- j
    ii <- i
    while (grille2[ii,jj]==0 && grille1[ii,jj]!=1){
      while (grille2[ii,jj]==0 && grille1[ii,jj]!=1){
        grilleInter[ii,jj] <- 0
        jj <- jj+1
      }
      jj <- j
      ii <- i+1
    }
  }
  grilleInter
}
