# sudoku
gawk scripts for solving sudoku and samurai sudoku

originally created to solve sudoku on an old android 
tablet with awk, not gawk. Since awk and gawk mishandle 
arrays differently, coding the scripts efficiently is a
pita.

Updated to work with gawk.

# usage

gawk -f AndDoku.awk <input.txt>

where <input.txt> is a row of 81 characters, with a period 
representing unknown values.

gawk -f BigDoku.awk <input.txt>

where <input.txt> is five rows of 81 characters, with a period 
representing unknown values, in the order TL TR BL BR C

use less -r to pipe the output through less.

TODO: optimize the code.
