BEGIN {
# sample sudoku puzzle
# .5...79.47.9..4....4.2.97.3..1.7.482...9.1...567.4.1..9.57.3.4....4..2.72.45...9.


# init arrays
  s2 = "12"
  s3 = "123"
  s8 = "12345678"
  s9 = "123456789"
  split(s2, a2, "")
  split(s3, a3, "")
  split(s8, a8, "")
  split(s9, a9, "")
  a2[0] = 0
  a8[0] = 0
}

# read data into global variables
length($0) == 81 {
  puzzle_str = $0
  split(puzzle_str, puzzle_arr, "")

  # grid[1..81] = "123456789" or value
  for (g=1;g<82;g++) {
    grid[g] = (puzzle_arr[g] == ".") ? s9 : puzzle_arr[g]
  }

  for (i in a8) {
    for (j in a9) {
      g = (i * 9) + j
      strs_row[i+1] = strs_row[i+1] g ","
    }
    strs_row[i+1] = strs_row[i+1] ","
    sub(",,", "", strs_row[i+1])
  }

  for (i in a9) {
    for (j in a8) {
      g = (j * 9) + i
      strs_col[i] = strs_col[i] g ","
    }
    strs_col[i] = strs_col[i] ","
    sub(",,", "", strs_col[i])
  }

  for (h in a2) {
    for (i in a2) {
      count += 1
      for (j in a2) {
        g = (h * 27) + (i * 3) + (j * 9) + 1
        for (k in a2) {
          strs_sqr[count] = strs_sqr[count] g+k ","
        }
      }
      strs_sqr[count] = strs_sqr[count] ","
      sub(",,", "", strs_sqr[count])
    }
  }
}

function scan(rcs,      t, i, g, h) {
  # loop over the nine rows, cols, and sqrs
  for (i in a9) {
    split(rcs[i], arr, ",")
    # loop over the grid squares
    for (g in arr) {
      # if position has one number
      if (length(grid[arr[g]]) == 1) {
        # loop over the grid squares
        for (h in arr) {
          # remove that number from other squares
          if ((match(grid[arr[h]], grid[arr[g]]) > 0) && (length(grid[arr[h]]) > 1)) {
            # print t, "remove", arr[g], grid[arr[g]], "from", arr[h], grid[arr[h]]
            sub(grid[arr[g]], "", grid[arr[h]])
          }
        }
      }
    }

    # check for singletons
    v = ""
    for (g in arr) {
      v = v grid[arr[g]]
    }

    # singletons appear once and will split array into 2
    for (k in a9) {
      if (split(v, a, k) == 2) {
        for (g in arr) {
          if (match(grid[arr[g]], k)) {
            grid[arr[g]] = k
          }
        }
      }
    }
  }
}

function showdata(sofar,      i) {
  print ""
  for (i in a8) {
    print substr(sofar, (i*9)+1, 9)
  }
  print ""
}

function grid_to_string(grid,       g, str) {
  for (g=1;g<82;g++) {
    n = (length(grid[g]) == 1) ? grid[g] : "."
    str = str n
  }
  return str
}

function display(sofar, i, j, g) {
  for (i in a8) {
    str = ""
    for (j in a9) {
      g = (i * 9) + j
      l = (length(grid[g]) == 1) ? grid[g] : "."
      esc = (sofar[g] == grid[g]) ? "\e[30m" : "\e[31m"
      str = str "  " esc l "\e[30m  "
    }
    print str
  }
  sofar = grid
  print ""
}

END {
  showdata(puzzle_str)
  while (curr != puzzle_str) {
    curr = puzzle_str
    scan(strs_row, "R")
    scan(strs_col, "C")
    scan(strs_sqr, "S")
    puzzle_str = grid_to_string(grid)
    display(puzzle_arr)
  }
}
