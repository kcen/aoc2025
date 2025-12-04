# Grid Utility Tests
# Tests for grid operations and coordinate types

import unittest
import ../aoc/aoc_utils
import ../aoc/utils/grid

suite "Grid Tests":
  test "Coord type: basic creation":
    let pos: Coord = (5, 3)
    check pos.r == 5
    check pos.c == 3

  test "Coord addition":
    let p1: Coord = (5, 3)
    let p2: Coord = (2, 1)
    let value = p1 + p2
    check value == (7, 4)

  test "Coord subtraction":
    let p1: Coord = (10, 8)
    let p2: Coord = (3, 2)
    let value = p1 - p2
    check value == (7, 6)

  test "Coord scalar multiplication":
    let p: Coord = (2, 3)
    let value = p * 4
    check value == (8, 12)

  test "manhattanDistance: 2D":
    let p1: Coord = (0, 0)
    let p2: Coord = (3, 4)
    let value = manhattanDistance(p1, p2)
    check value == 7 # |3-0| + |4-0|

  test "manhattanDistance: 3D":
    let p1: Coord3 = (0, 0, 0)
    let p2: Coord3 = (1, 2, 3)
    let value = manhattanDistance(p1, p2)
    check value == 6 # |1| + |2| + |3|

  test "Grid creation and access":
    let grid = newGrid(3, 3, 0)
    check grid.height == 3
    check grid.width == 3
    check grid[0][0] == 0

  test "inBounds: valid positions":
    let grid = newGrid(5, 5, 0)
    check grid.inBounds((0, 0)) == true
    check grid.inBounds((4, 4)) == true
    check grid.inBounds((2, 2)) == true

  test "inBounds: invalid positions":
    let grid = newGrid(5, 5, 0)
    check grid.inBounds((-1, 0)) == false
    check grid.inBounds((5, 5)) == false
    check grid.inBounds((2, -1)) == false

  test "neighbors: 4-connectivity":
    let grid = newGrid(5, 5, 0)
    let neighbors = grid.neighbors((2, 2), diagonals = false)
    check neighbors.len == 4 # up, down, left, right
    check (1, 2) in neighbors
    check (3, 2) in neighbors
    check (2, 1) in neighbors
    check (2, 3) in neighbors

  test "neighbors: corner position":
    let grid = newGrid(5, 5, 0)
    let neighbors = grid.neighbors((0, 0), diagonals = false)
    check neighbors.len == 2 # only right and down

  test "neighbors: 8-connectivity":
    let grid = newGrid(5, 5, 0)
    let neighbors = grid.neighbors((2, 2), diagonals = true)
    check neighbors.len == 8
    check (1, 1) in neighbors
    check (1, 2) in neighbors
    check (1, 3) in neighbors

  test "findAll: locate all matching elements":
    let grid = parseCharGrid(@["AAB", "BAA", "ABB"])
    let positions = findAll(grid, proc(c: char): bool = c == 'A')
    check positions.len == 5

  test "findFirst: find first matching element":
    let grid = parseCharGrid(@["XYZ", "ABC", "DEF"])
    let pos = findFirst(grid, proc(c: char): bool = c == 'A')
    check pos == (1, 0)

  test "rotateClockwise: 90 degree rotation":
    let grid = parseCharGrid(@["AB", "CD"])
    let rotated = rotateClockwise(grid)
    check rotated[0][0] == 'C'
    check rotated[0][1] == 'A'
    check rotated[1][0] == 'D'
    check rotated[1][1] == 'B'

  test "flipHorizontal: mirror left-right":
    let grid = parseCharGrid(@["AB", "CD"])
    let flipped = flipHorizontal(grid)
    check flipped[0][0] == 'B'
    check flipped[0][1] == 'A'
    check flipped[1][0] == 'D'
    check flipped[1][1] == 'C'

  test "flipVertical: mirror up-down":
    let grid = parseCharGrid(@["AB", "CD"])
    let flipped = flipVertical(grid)
    check flipped[0][0] == 'C'
    check flipped[0][1] == 'D'
    check flipped[1][0] == 'A'
    check flipped[1][1] == 'B'

  test "transpose: swap rows and columns":
    let grid = parseCharGrid(@["AB", "CD", "EF"])
    let transposed = transpose(grid)
    check transposed.height == 2
    check transposed.width == 3
    check transposed[0][0] == 'A'
    check transposed[0][1] == 'C'
    check transposed[0][2] == 'E'

  test "parseCharGrid: creates 2D character array":
    let lines = @["ABC", "DEF", "GHI"]
    let grid = parseCharGrid(lines)
    check grid.height == 3
    check grid.width == 3
    check grid[0][0] == 'A'
    check grid[2][2] == 'I'

  test "parseIntGrid: creates 2D integer array":
    let lines = @["123", "456"]
    let grid = parseIntGrid(lines, "") # "" means each char is a digit
    check grid.height == 2
    check grid.width == 3
    check grid[0][0] == 1
    check grid[1][2] == 6

# ============================================================================
# FLAT GRID TESTS
# ============================================================================
  test "newFlatGrid: create flat grid":
    let grid = newFlatGrid[int](3, 2, 0)
    check grid.width == 3
    check grid.height == 2
    check grid.data.len == 6

  test "flatGrid access: get and set values":
    var grid = newFlatGrid[int](2, 2, 0)
    grid[(0, 0)] = 5
    grid[(1, 1)] = 10
    check grid[(0, 0)] == 5
    check grid[(1, 1)] == 10

  test "FlatGrid inBounds: check boundaries":
    let grid = newFlatGrid[int](3, 3, 0)
    check grid.inBounds((0, 0)) == true
    check grid.inBounds((2, 2)) == true
    check grid.inBounds((3, 3)) == false
    check grid.inBounds((-1, 0)) == false

  test "FlatGrid neighbors: 4-connectivity":
    let grid = newFlatGrid[int](5, 5, 0)
    let neighbors = grid.neighbors((2, 2), diagonals = false)
    check neighbors.len == 4
    check (1, 2) in neighbors
    check (3, 2) in neighbors
    check (2, 1) in neighbors
    check (2, 3) in neighbors

  test "FlatGrid neighbors: 8-connectivity":
    let grid = newFlatGrid[int](5, 5, 0)
    let neighbors = grid.neighbors((2, 2), diagonals = true)
    check neighbors.len == 8
    check (1, 1) in neighbors
    check (1, 2) in neighbors
    check (1, 3) in neighbors

  test "parseCharGridFlat: create flat character grid":
    let input = "ABC\nDEF\nGHI"
    let grid = parseCharGridFlat(input)
    check grid.height == 3
    check grid.width == 3
    check grid[(0, 0)] == 'A'
    check grid[(2, 2)] == 'I'

  test "parseIntGridFlat: create flat integer grid":
    let input = "123\n456"
    let grid = parseIntGridFlat(input)
    check grid.height == 2
    check grid.width == 3
    check grid[(0, 0)] == 1
    check grid[(1, 2)] == 6

  test "gridToFlat and flatToGrid: conversion round-trip":
    let original = parseCharGrid(@["AB", "CD"])
    let flat = gridToFlat(original)
    let converted = flatToGrid(flat)
    check converted.height == original.height
    check converted.width == original.width
    check converted[0][0] == original[0][0]
    check converted[1][1] == original[1][1]

# ============================================================================
# SPARSE GRID TESTS
# ============================================================================
  test "newSparseGrid: create sparse grid":
    let grid = newSparseGrid[char](3, 3, '.')
    check grid.width == 3
    check grid.height == 3
    check grid.count == 0

  test "SparseGrid access: get and set values":
    var grid = newSparseGrid[char](3, 3, '.')
    grid[(0, 0)] = '@'
    grid[(1, 1)] = '#'
    check grid[(0, 0)] == '@'
    check grid[(1, 1)] == '#'
    check grid[(2, 2)] == '.' # empty
    check grid.count == 2

  test "SparseGrid: setting to empty removes":
    var grid = newSparseGrid[char](3, 3, '.')
    grid[(0, 0)] = '@'
    check grid.count == 1
    grid[(0, 0)] = '.' # Set to empty
    check grid.count == 0
    check grid[(0, 0)] == '.'

  test "SparseGrid inBounds: check boundaries":
    let grid = newSparseGrid[char](3, 3, '.')
    check grid.inBounds((0, 0)) == true
    check grid.inBounds((2, 2)) == true
    check grid.inBounds((3, 3)) == false
    check grid.inBounds((-1, 0)) == false

  test "SparseGrid neighbors: 8-connectivity":
    var grid = newSparseGrid[char](5, 5, '.')
    grid[(2, 3)] = 'X'
    grid[(1, 3)] = 'B'
    let neighbors = grid.neighbors((2, 2), diagonals = true)
    check neighbors.len == 2

  test "parseSparseGrid: create sparse character grid":
    let input = "..X\n.y.\nZ.."
    let grid = parseSparseGrid(input, '.')
    check grid.height == 3
    check grid.width == 3
    check grid.count == 3
    check grid[(0, 2)] == 'X'
    check grid[(1, 1)] == 'y'
    check grid[(2, 0)] == 'Z'
    check grid[(0, 0)] == '.'

  test "sparseToGrid and gridToSparse: conversion round-trip":
    let original = parseCharGrid(@["@..", ".@.", "..@"])
    let sparse = gridToSparse(original, '.')
    check sparse.count == 3
    let converted = sparseToGrid(sparse)
    check converted[0][0] == original[0][0]
    check converted[1][1] == original[1][1]

  test "linearIndex: convert 2D to 1D":
    let pos: Coord = (2, 3)
    let idx = linearIndex(pos, 4) # width = 4
    check idx == 11 # 2*4 + 3

  test "coordFromIndex: convert 1D to 2D":
    let idx = 11
    let pos = coordFromIndex(idx, 4)
    check pos == (2, 3)

  test "gridToLinear: flatten grid":
    let grid = parseCharGrid(@["AB", "CD", "EF"])
    let flat = gridToLinear(grid)
    check flat.len == 6
    check flat[0] == 'A'
    check flat[5] == 'F'
