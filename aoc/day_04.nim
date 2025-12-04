import std/tables
import aoc_utils

proc day_04*(): Solution =
  var grid = getInput().parseSparseGrid('.')
  var first_accessible = 0
  var total = 0
  var first_look = true

  while true:
    var accessible: seq[Coord] = @[]

    for pos, value in grid.data.pairs:
      if grid.neighbors(pos, diagonals = true).len < 4:
        accessible.add(pos)

    if accessible.len == 0: break # quittin' time

    if first_look:
      first_accessible = accessible.len
      first_look = false

    total += accessible.len

    for pos in accessible:
      grid.data.del(pos)

  Solution(part_one: $first_accessible, part_two: $total)
