import aoc_utils

proc day_04*(): Solution =
  var grid = getInput().parseCharGridFlat()
  var counts = newFlatGrid[int](grid.width, grid.height, 0)

  # keep track of how many neighbors
  for r in 0..<grid.height:
    for c in 0..<grid.width:
      let pos: Coord = (r, c)
      if grid[pos] != '.':
        for dir in DIRECTIONS_8:
          let neighbor = (pos.r + dir.r, pos.c + dir.c)
          if grid.inBounds(neighbor) and grid[neighbor] != '.':
            counts[pos] = counts[pos] + 1

  var first_accessible = 0
  var total = 0
  var first_look = true

  while true:
    var accessible: seq[Coord] = @[]

    for r in 0..<grid.height:
      for c in 0..<grid.width:
        let pos = (r, c)
        if grid[pos] != '.' and counts[pos] < 4:
          accessible.add(pos)

    if accessible.len == 0: break # quittin' time

    if first_look:
      first_accessible = accessible.len
      first_look = false

    total += accessible.len

    for pos in accessible:
      for dir in DIRECTIONS_8:
        let neighbor = (pos.r + dir.r, pos.c + dir.c)
        if grid.inBounds(neighbor) and grid[neighbor] != '.':
          counts[neighbor] = counts[neighbor] - 1
      grid[pos] = '.'

  Solution(part_one: $first_accessible, part_two: $total)
