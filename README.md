# sudoku
awk scripts for solving sudoku and samurai sudoku

originally created to solve sudoku on an old android 
tablet with awk, not gawk. Since awk and gawk mishandle 
arrays differently, coding the scripts efficiently is a
pita.

# usage
awk -f BigDoku.awk bigData.txt

awk -f AndDoku.awk andData.txt

where the data is five rows of 81 characters, with a period 
representing unknown values, in the order TL TR BL BR C

use less -r to pipe the output through less.

TODO: optimize the code and attempt to make the scripts [g]awk 
version indifferent.
