import std/tables
import aoc_utils

proc day_04*(): Solution =
  var grid = getInput().parseSparseGrid('.')
  var counts = initTable[Coord, int]()

  # keep track of how many neighbors
  for pos, _ in grid.data.pairs:
    counts[pos] = grid.neighbors(pos, diagonals = true).len

  var first_accessible = 0
  var total = 0
  var first_look = true

  while true:
    var accessible: seq[Coord] = @[]

    for pos, _ in grid.data.pairs:
      if counts[pos] < 4:
        accessible.add(pos)

    if accessible.len == 0: break # quittin' time

    if first_look:
      first_accessible = accessible.len
      first_look = false

    total += accessible.len

    for pos in accessible:
      for neighbor in grid.neighbors(pos, diagonals = true):
        if counts.hasKey(neighbor):
          counts[neighbor] -= 1
      grid.data.del(pos)
      counts.del(pos)

  Solution(part_one: $first_accessible, part_two: $total)
