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
length($0) == 81 {
  split($0, puzzle_arr, "")

  # frame[1..81] = "123456789" or value
  for (g=1;g<82;g++) {
    frame[g] = (puzzle_arr[g] == ".") ? s9 : puzzle_arr[g]
  }

  for (i in a8) {
    for (j in a9) {
      g = (i * 9) + j
      frame_rows[i+1] = frame_rows[i+1] g ","
    }
    frame_rows[i+1] = frame_rows[i+1] ","
    sub(",,", "", frame_rows[i+1])
  }

  for (i in a9) {
    for (j in a8) {
      g = (j * 9) + i
      frame_cols[i] = frame_cols[i] g ","
    }
    frame_cols[i] = frame_cols[i] ","
    sub(",,", "", frame_cols[i])
  }

  for (h in a2) {
    for (i in a2) {
      count += 1
      for (j in a2) {
        g = (h * 27) + (i * 3) + (j * 9) + 1
        for (k in a2) {
          frame_sqrs[count] = frame_sqrs[count] g+k ","
        }
      }
      frame_sqrs[count] = frame_sqrs[count] ","
      sub(",,", "", frame_sqrs[count])
    }
  }
}

function scan(rcs,     t, u, i, g, h) {
  # loop over the nine rows, cols, and sqrs
    for (i in a9) {
      split(rcs[i], arr, ",")
      # loop over the frame square positions
      for (g in arr) {
        # if position has one number
        t = frame[arr[g]]
        if (length(t) == 1) {
          # loop over the frame squares
          for (h in arr) {
            # potentially remove that number from other squares
            if (length(frame[arr[h]]) > 1) {
              sub(frame[arr[g]], "", frame[arr[h]])
            }
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

function frame_to_string(frame,     str) {
  for (y=1; y<82; y++) {
    this = frame[y]
    this = (length(this) == 1) ? this : "."
    str = str this
  }
  return str
}

function frame_print(curr, prev,      c, p) {
  split(curr, c, "")
  split(prev, p, "")
  for (i=1; i<=81; i++) {
    printf("%s", (( c[i] == p[i] ) ? " " c[i] " " :
           "\033[31;1m " c[i] " \033[0m" ) (( i % 9 == 0 ) ? "\n" : ""))
  }
}

END {
  # process frame
  curr = frame_to_string(frame)

  while (curr != prev) {
    prev = curr
    scan(frame_rows)
    scan(frame_cols)
    scan(frame_sqrs)
    curr = frame_to_string(frame)
    print "\nPass = " ++number "\n"
    frame_print(curr, prev)
  }
}
