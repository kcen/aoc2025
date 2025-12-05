import aoc_utils
import std/deques

const EMPTY = '.'

proc neighbors_count(grid: FlatGrid[char], pos: Coord): int =
  for dir in DIRECTIONS_8:
    let neighbor = pos + dir
    if grid.inBounds(neighbor) and grid[neighbor] != EMPTY:
      inc result

proc enqueue_next(q: var Deque[Coord], grid: FlatGrid[char], pos: Coord) =
  for dir in DIRECTIONS_8:
    let neighbor = pos + dir
    if grid.inBounds(neighbor) and grid[neighbor] != EMPTY:
      q.addLast(neighbor)

proc day_04*(): Solution =
  var grid = getInput().parseCharGridFlat()
  var total = 0
  var q = initDeque[Coord]()

  var first_accessible = 0

  for idx, val in grid.data:
    let pos: Coord = idx.coordFromIndex(grid.width)
    if grid[pos] != EMPTY:
      q.addLast(pos)
      if grid.neighbors_count(pos) < 4:
        first_accessible += 1

  while q.len > 0:
    let coord = q.popFirst()
    if grid[coord] == EMPTY: continue

    let count = grid.neighbors_count(coord)

    if count < 4:
      q.enqueue_next(grid, coord)
      grid[coord] = EMPTY
      total += 1

  Solution(part_one: $first_accessible, part_two: $total)
