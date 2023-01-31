BEGIN {
  # init arrays for looping
  split("12", a2, "")
  split("123", a3, "")
  split("12345678", a8, "")
  split("123456789", a9, "")
  a2[0] = a8[0] = 0
  s9 = "123456789"
}

# read data into global variables
# TODO: Error checking
length($0) == 81 {
  puzzle[++count] = $0
}

function merge_frames(frame) {
  for (y=1; y<442; y++) {
    frame[y] = " "
  }

  # init offsets
  for (count = 1; count <= 5; count++) {
    offsx = ((count == 1) || (count == 3)) ? 0 :
            ((count == 2) || (count == 4)) ? 12 : 6

    offsy = ((count == 1) || (count == 2)) ? 0 :
            ((count == 3) || (count == 4)) ? 12*21 : 6*21

    split(puzzle[count], puzzle_arr[count], "")

    # grid[count, 1..81] := "123456789" or value
    # g is a grid position; f is a frame position
    # oh, how I hate gawk and --posix and --trad errors
    for (g=1; g<82; g++) {
      this = puzzle_arr[count][g]
      grid[count][g] = ( this == "." ) ? s9 : this
    }

    # grid and frame positions for rows
    for (yi in a8) {
      for (xj in a9) {
        g = (yi * 9) + xj
        f = (yi * 21) + xj + offsx + offsy
        frame[f] = grid[count][g]
        frame_rows[count][yi+1] = frame_rows[count][yi+1] f ","
      }
      frame_rows[count][yi+1] = frame_rows[count][yi+1] ","
      sub(",,", "", frame_rows[count][yi+1])
    }
 
    # grid and frame positions for cols
    for (yi in a9) {
      for (xj in a8) {
        g = (xj * 9) + yi
        f = (xj * 21) + yi + offsx + offsy
        frame[f] = grid[count][g]       # not necessary; use for error checking 
        frame_cols[count][yi] = frame_cols[count][yi] f ","
      }
      frame_cols[count][yi] = frame_cols[count][yi] ","
      sub(",,", "", frame_cols[count][yi])
    }
 
    # sqrs
    idx = 0
    for (bi in a2) {
      for (xj in a2) {
        idx += 1
        for (yk in a2) {
          for (el in a2) {
            g = (bi * 27) + (xj * 3) + (yk * 9) + el + 1
            f = (bi * 63) + (xj * 3) + (yk * 21) + el + 1 + offsx + offsy
            frame[f] = grid[count][g]  # not necessary; use for error checking 
            frame_sqrs[count][idx] = frame_sqrs[count][idx] f ","
          }
        }
        frame_sqrs[count][idx] = frame_sqrs[count][idx] ","
        sub(",,", "", frame_sqrs[count][idx])
      }
    }
  }
}

function scan(rcs, w,     t, i, g, h) {
  # loop over each frame
  for (count = 1; count < 6; count++) {
    # loop over the nine rows, cols, and sqrs
    for (i in a9) {
      split(rcs[count][i], arr, ",")
      # loop over the frame square positions
      for (g in arr) {
        t = frame[arr[g]]
        # if position has one number
        if (length(t) == 1) {
          # loop over the frame squares
          for (h in arr) {
            u = frame[arr[h]]
            # remove that number from other squares
            if ((match(u, t) > 0) && (length(u) > 1)) {
              sub(t, "", u)
            }
            frame[arr[h]] = u
          }
        }
      }
      # check for singletons
      v = ""
      for (g in arr) {
        v = v frame[arr[g]]
      }
      # singletons appear once and will array split into 2
      for (k in a9) {
        if (split(v, a, k) == 2) {
          for (g in arr) {
            if (match(frame[arr[g]], k)) {
              frame[arr[g]] = k
            }
          }
        }
      } 
    }
  }
}

function frame_to_string(frame,     str) {
  for (y=1; y<442; y++) {
    this = frame[y]
    this = (length(this) == 1) ? this : "."
    str = str this
  }
  return str
}

function frame_print(curr, prev,      str) {
  split(curr, c, "")
  split(prev, p, "")
  for (i=1; i<=441; i++) {
    printf("%s", (( c[i] == p[i] ) ? " " c[i] " " : "\033[31;1m " c[i] " \033[0m" ) (( i % 21 == 0 ) ? "\n" : ""))
  }
}

END {
  merge_frames(frame)
  curr = frame_to_string(frame)
 
  while (curr != prev) {
    prev = curr
    scan(frame_rows, "R")
    scan(frame_cols, "C")
    scan(frame_sqrs, "S")
    curr = frame_to_string(frame)
    print "\nPass = " ++number "\n"
    frame_print(curr, prev)
  }
}
