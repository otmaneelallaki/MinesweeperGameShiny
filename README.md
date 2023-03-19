# Shiny App Mine Sweeper

## <ins>Description</ins>

The goal of the game is to clear a rectangular grid of cells without detonating any hidden mines. The grid is initially covered by a set of tiles that can be either blank, numbered, or contain a mine. The player must use logical deduction to determine which tiles contain mines and which do not.

At the start of the game, the player is presented with a grid of covered tiles. The size of the grid and the number of mines hidden within it can be customized by the player. The player can then click on any tile to uncover it. If the tile contains a mine, the game is over and the player loses. If the tile does not contain a mine, it will be replaced by a number that indicates how many mines are hidden in the adjacent tiles. The player can then use this information to deduce which tiles are safe to uncover and which are not.

The game is won when all the non-mine tiles have been uncovered. If the player is unsure whether a tile contains a mine or not, they can place a flag on the tile to indicate that it is suspected to contain a mine. The player can also remove a flag if they change their mind.

## <ins>Audience<ins>

Whoever interested in playing games is more than welcome to use this app. It is a challenging game that can be enjoyed by players of all ages.

## <ins>How To install the App:</ins>

The instructions to install the R package "minesweeper" are as follows:

  - download the "minesweeper_0.1.0.tar.gz" file above
  - Open R console or RStudio and run the following command :
      1. > install.packages("path/to/minesweeper_0.1.0.tar.gz", repos = NULL, type = "source")
      2. > library(minesweeper)

## <ins>How To Use This App:</ins>

### 1. Game difficulty

  - <ins>Number of mines</ins>: The more mines you add, the more difficult the game becomes.
  - <ins>Number of rows</ins>: This controls the number of buttons in each row of the grid.
  - <ins>Number of columns</ins>: This controls the number of buttons in each column of the grid.
  - <ins>Reset</ins>: This option ignores any changes made and resets the game to its default settings, which include 5 mines, 6 rows, and 8 columns.
<p >
  <img src="https://github.com/otmaneelallaki/MinesweeperGameShiny/blob/main/inst/shiny/www/Pic2.png" width="1000" title="Suduko">
</p>


>**Note**
>The number of mines is related to the number of rows and columns in the grid. If the number of mines exceeds the number of buttons minus one, a warning message will appear as shown in the picture below. You can easily dismiss the message by clicking on the "Dismiss" button.

<p align="center" >
  <img src="https://github.com/otmaneelallaki/MinesweeperGameShiny/blob/main/inst/shiny/www/Pic3.png" width="500" title="Suduko" >
</p>


### 2. Start the Game
  
  By clicking on the "Start" button, the game will begin and the timer will start counting. The player can then click on any tile to uncover it. If the player is unsure whether a tile (or more) contains a mine or not, they can click on the "Flag" button and then click on the tile(s) to indicate that it is suspected to contain a mine. The player can also remove a flag if they change their mind by re-clicking agine on it.
  
<p >
  <img src="https://github.com/otmaneelallaki/MinesweeperGameShiny/blob/main/inst/shiny/www/Pic1.png" width="1000" title="Suduko">
</p>

### 3. Flags remaining
  The number of flags is equal to the number of mines. For each time a player puts a flag on a tile, the number of remaining flags decreases by 1. If the player reaches 0 remaining flags, a notification will appear reminding them of this.
  <p >
  <img src="https://github.com/otmaneelallaki/MinesweeperGameShiny/blob/main/inst/shiny/www/Pic4.png" width="1000" title="Suduko">
</p>
  
 ### 4. Win and loss
 
  - The player wins Minesweeper when all non-mine tiles have been uncovered. Once the game is won, a new window will appear displaying the time taken to complete the game. To return to the game, click the 'dismiss' button.
  - The player loses Minesweeper when they click on a tile containing a mine.
  
  <p align="center" >
   <img src="https://github.com/otmaneelallaki/MinesweeperGameShiny/blob/main/inst/shiny/www/Pic5.png" width="450" title="Suduko">
&nbsp; &nbsp; &nbsp; &nbsp;
  <img src="https://github.com/otmaneelallaki/MinesweeperGameShiny/blob/main/inst/shiny/www/Pic6.png" width="450" title="Suduko">
</p>

## <ins>Members of the group<ins>

Otmane EL ALLAKI otmane.el-allaki@etu.umontpellier.fr

David david.dzarnecki@etu.umontpellier.fr

PROJET M1 SSD -- Programmation R
