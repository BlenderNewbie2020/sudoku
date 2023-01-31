# sudoku
awk scripts for solving sudoku and samurai sudoku

# usage
awk -f BigDoku.awk Data.txt

where the data is five rows of 81 characters, with a period 
representing unknown values, in the order TL TR BL BR C

use less -r to pipe the output through less
