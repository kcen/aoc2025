# Grid Operations and Coordinate Types for AOC
# 2D/3D coordinate handling, grid manipulation, and spatial algorithms

import std/[sequtils, algorithm, strutils]
# from std/strscans import scanTuple  # Uncomment if scanTuple is needed

# ============================================================================
# COORDINATE TYPES
# ============================================================================

type
  Coord* = tuple[r, c: int]
  Coord3* = tuple[x, y, z: int]
  Direction* = enum dUp, dDown, dLeft, dRight, dUpLeft, dUpRight, dDownLeft, dDownRight
  Direction3* = enum d3Up, d3Down, d3Left, d3Right, d3Forward, d3Backward

# ============================================================================
# DIRECTION CONSTANTS
# ============================================================================

const
  DIRECTIONS_4*: array[4, Coord] = [(-1, 0), (1, 0), (0, -1), (0, 1)] # U, D, L, R
  DIRECTIONS_8*: array[8, Coord] = [(-1, 0), (1, 0), (0, -1), (0, 1), # U, D, L, R
    (-1, -1), (-1, 1), (1, -1), (1, 1)] # UL, UR, DL, DR
  DIRECTIONS_6_3D*: array[6, Coord3] = [(1, 0, 0), (-1, 0, 0), (0, 1, 0), # X+, X-, Y+
    (0, -1, 0), (0, 0, 1), (0, 0, -1)]  # Y-, Z+, Z-

# ============================================================================
# COORDINATE OPERATIONS (OPTIMIZED WITH INLINE)
# ============================================================================

proc `+`*(a: Coord, b: Coord): Coord {.inline, noSideEffect.} = (a.r + b.r, a.c + b.c)
proc `-`*(a: Coord, b: Coord): Coord {.inline, noSideEffect.} = (a.r - b.r, a.c - b.c)
proc `*`*(a: Coord, s: int): Coord {.inline, noSideEffect.} = (a.r * s, a.c * s)

proc `+`*(a: Coord3, b: Coord3): Coord3 {.inline, noSideEffect.} = (a.x + b.x,
    a.y + b.y, a.z + b.z)
proc `-`*(a: Coord3, b: Coord3): Coord3 {.inline, noSideEffect.} = (a.x - b.x,
    a.y - b.y, a.z - b.z)
proc `*`*(a: Coord3, s: int): Coord3 {.inline, noSideEffect.} = (a.x * s, a.y *
    s, a.z * s)

proc manhattanDistance*(a, b: Coord): int {.inline, noSideEffect.} =
  ## Manhattan distance between two 2D coordinates
  abs(a.r - b.r) + abs(a.c - b.c)

proc manhattanDistance*(a, b: Coord3): int {.inline, noSideEffect.} =
  ## Manhattan distance between two 3D coordinates
  abs(a.x - b.x) + abs(a.y - b.y) + abs(a.z - b.z)

# ============================================================================
# GRID TYPE AND BASIC OPERATIONS
# ============================================================================

type
  Grid*[T] = seq[seq[T]]

  # Memory-efficient flat grid storage for better cache locality
  FlatGrid*[T] = object
    data*: seq[T] # Linear storage (largest field first for better alignment)
    width*: int   # Dimensions
    height*: int  # Dimensions

proc newGrid*[T](rows, cols: int, default: T): Grid[T] =
  ## Create a grid with dimensions and default value
  newSeqWith(rows, newSeq[T](cols).mapIt(default))

proc width*[T](grid: Grid[T]): int {.inline, noSideEffect.} =
  if grid.len == 0: 0 else: grid[0].len

proc height*[T](grid: Grid[T]): int {.inline, noSideEffect.} =
  grid.len

proc inBounds*[T](grid: Grid[T], pos: Coord): bool {.inline, noSideEffect.} =
  pos.r >= 0 and pos.r < grid.height and pos.c >= 0 and pos.c < grid.width

proc get*[T](grid: Grid[T], pos: Coord, default: T): T =
  if grid.inBounds(pos): grid[pos.r][pos.c] else: default

proc `[]`*[T](grid: Grid[T], pos: Coord): T =
  grid[pos.r][pos.c]

proc `[]=`*[T](grid: var Grid[T], pos: Coord, val: T) =
  grid[pos.r][pos.c] = val

# ============================================================================
# NEIGHBORHOOD OPERATIONS
# ============================================================================

proc neighbors*[T](grid: Grid[T], pos: Coord, diagonals = false): seq[Coord] =
  ## Get valid neighbors of a position
  let dirs = if diagonals: DIRECTIONS_8.toSeq else: DIRECTIONS_4.toSeq
  for dir in dirs:
    let newPos = pos + dir
    if grid.inBounds(newPos):
      result.add(newPos)

proc neighborsWithValues*[T](grid: Grid[T], pos: Coord, diagonals = false): seq[
    (Coord, T)] =
  ## Get valid neighbors with their values
  for neighbor in grid.neighbors(pos, diagonals):
    result.add((neighbor, grid[neighbor]))

# ============================================================================
# GRID TRANSFORMATIONS
# ============================================================================

proc mapGrid*[T, U](grid: Grid[T], fn: proc(x: T): U): Grid[U] =
  ## Apply function to all grid elements
  grid.mapIt(it.mapIt(fn(it)))

proc filterGrid*[T](grid: Grid[T], predicate: proc(x: T): bool): seq[(Coord, T)] =
  ## Find all positions matching predicate
  var result: seq[(Coord, T)] = @[]
  for r in 0..<grid.height:
    for c in 0..<grid.width:
      if predicate(grid[r][c]):
        result.add(((r, c), grid[r][c]))
  result

proc findFirst*[T](grid: Grid[T], predicate: proc(x: T): bool): Coord =
  ## Find first position matching predicate
  for r in 0..<grid.height:
    for c in 0..<grid.width:
      if predicate(grid[r][c]):
        return (r, c)
  (-1, -1)

proc findAll*[T](grid: Grid[T], predicate: proc(x: T): bool): seq[Coord] =
  ## Find all positions matching predicate
  grid.filterGrid(predicate).mapIt(it[0])

proc rotateClockwise*[T](grid: Grid[T]): Grid[T] =
  ## Rotate grid 90 degrees clockwise
  let h = grid.height
  let w = grid.width
  result = newSeqWith(w, newSeq[T](h))
  for r in 0..<h:
    for c in 0..<w:
      result[c][h - 1 - r] = grid[r][c]

proc rotateCounterClockwise*[T](grid: Grid[T]): Grid[T] =
  ## Rotate grid 90 degrees counter-clockwise
  let h = grid.height
  let w = grid.width
  result = newSeqWith(w, newSeq[T](h))
  for r in 0..<h:
    for c in 0..<w:
      result[w - 1 - c][r] = grid[r][c]

proc flipHorizontal*[T](grid: Grid[T]): Grid[T] =
  ## Flip grid horizontally (mirror left-right)
  grid.mapIt(it.reversed)

proc flipVertical*[T](grid: Grid[T]): Grid[T] =
  ## Flip grid vertically (mirror up-down)
  grid.reversed

proc transpose*[T](grid: Grid[T]): Grid[T] =
  ## Transpose grid (swap rows and columns)
  let h = grid.height
  let w = grid.width
  result = newSeqWith(w, newSeq[T](h))
  for r in 0..<h:
    for c in 0..<w:
      result[c][r] = grid[r][c]

# ============================================================================
# GRID PARSING HELPERS
# ============================================================================

proc parseCharGrid*(lines: seq[string]): Grid[char] =
  ## Convert lines to 2D character grid
  lines.mapIt(it.toSeq)

proc parseIntGrid*(lines: seq[string], sep = ""): Grid[int] =
  ## Parse lines into 2D integer grid (each char is a digit if sep="")
  if sep == "":
    result = @[]
    for line in lines:
      var row: seq[int] = @[]
      for ch in line:
        row.add(int(ch) - int('0'))
      result.add(row)
  else:
    result = @[]
    for line in lines:
      var row: seq[int] = @[]
      let tokens = line.split(sep[0])
      for token in tokens:
        if token.len > 0:
          row.add(parseInt(token))
      result.add(row)

# ============================================================================
# CACHE-FRIENDLY GRID OPERATIONS
# ============================================================================

proc linearIndex*(pos: Coord, width: int): int {.inline, noSideEffect.} =
  ## Convert 2D coordinate to linear index (cache-friendly)
  pos.r * width + pos.c

proc coordFromIndex*(idx: int, width: int): Coord {.inline, noSideEffect.} =
  ## Convert linear index back to 2D coordinate
  (idx div width, idx mod width)

proc gridToLinear*[T](grid: Grid[T]): seq[T] =
  ## Flatten grid for better cache locality in sequential access
  var result = newSeq[T](grid.height * grid.width)
  var idx = 0
  for row in grid:
    for cell in row:
      result[idx] = cell
      idx.inc
  result

proc linearToGrid*[T](arr: seq[T], width: int): Grid[T] =
  ## Reshape linear array back to 2D grid
  let height = arr.len div width
  result = newSeq[seq[T]](height)
  var idx = 0
  for r in 0..<height:
    result[r] = newSeq[T](width)
    for c in 0..<width:
      result[r][c] = arr[idx]
      idx.inc

# ============================================================================
# FLAT GRID OPERATIONS (MEMORY-EFFICIENT)
# ============================================================================

proc newFlatGrid*[T](width, height: int, default: T): FlatGrid[T] =
  ## Create a flat grid with dimensions and default value
  FlatGrid[T](
    data: newSeq[T](width * height).mapIt(default),
    width: width,
    height: height
  )

proc flatWidth*[T](grid: FlatGrid[T]): int {.inline, noSideEffect.} =
  grid.width

proc flatHeight*[T](grid: FlatGrid[T]): int {.inline, noSideEffect.} =
  grid.height

proc flatInBounds*[T](grid: FlatGrid[T], pos: Coord): bool {.inline,
    noSideEffect.} =
  pos.r >= 0 and pos.r < grid.height and pos.c >= 0 and pos.c < grid.width

proc flatGet*[T](grid: FlatGrid[T], pos: Coord, default: T): T =
  if grid.flatInBounds(pos): grid.data[pos.r * grid.width + pos.c] else: default

proc `[]`*[T](grid: FlatGrid[T], pos: Coord): T =
  grid.data[pos.r * grid.width + pos.c]

proc `[]=`*[T](grid: var FlatGrid[T], pos: Coord, val: T) =
  grid.data[pos.r * grid.width + pos.c] = val

proc flatNeighbors*[T](grid: FlatGrid[T], pos: Coord, diagonals = false): seq[Coord] =
  ## Get valid neighbors of a position (flat grid version)
  let dirs = if diagonals: DIRECTIONS_8.toSeq else: DIRECTIONS_4.toSeq
  for dir in dirs:
    let newPos = pos + dir
    if grid.flatInBounds(newPos):
      result.add(newPos)

proc flatNeighborsWithValues*[T](grid: FlatGrid[T], pos: Coord,
    diagonals = false): seq[(Coord, T)] =
  ## Get valid neighbors with their values (flat grid version)
  for neighbor in grid.flatNeighbors(pos, diagonals):
    result.add((neighbor, grid[neighbor]))

proc flatToGrid*[T](flat: FlatGrid[T]): Grid[T] =
  ## Convert flat grid to nested grid
  var result = newSeq[seq[T]](flat.height)
  for r in 0..<flat.height:
    result[r] = newSeq[T](flat.width)
    for c in 0..<flat.width:
      result[r][c] = flat[(r, c)]
  result

proc gridToFlat*[T](grid: Grid[T]): FlatGrid[T] =
  ## Convert nested grid to flat grid
  let height = grid.height
  let width = grid.width
  var flat = newFlatGrid[T](width, height, grid[0][0]) # Use first element as default
  for r in 0..<height:
    for c in 0..<width:
      flat[(r, c)] = grid[(r, c)]
  flat

proc parseCharGridFlat*(lines: seq[string]): FlatGrid[char] =
  ## Parse lines to flat character grid
  if lines.len == 0:
    return FlatGrid[char](data: @[], width: 0, height: 0)

  let width = lines[0].len
  let height = lines.len
  var grid = newFlatGrid[char](width, height, ' ')
  for r, line in lines:
    for c, ch in line:
      grid[(r, c)] = ch
  grid

proc parseIntGridFlat*(lines: seq[string], sep = ""): FlatGrid[int] =
  ## Parse lines to flat integer grid
  if lines.len == 0:
    return FlatGrid[int](data: @[], width: 0, height: 0)

  if sep == "":
    let width = lines[0].len
    let height = lines.len
    var grid = newFlatGrid[int](width, height, 0)
    for r, line in lines:
      for c, ch in line:
        grid[(r, c)] = int(ch) - int('0')
    grid
  else:
    # For separated values, we need to determine width from first line
    let tokens = lines[0].split(sep[0])
    var width = 0
    for token in tokens:
      if token.len > 0:
        width += 1

    let height = lines.len
    var grid = newFlatGrid[int](width, height, 0)
    for r, line in lines:
      let rowTokens = line.split(sep[0])
      var c = 0
      for token in rowTokens:
        if token.len > 0:
          grid[(r, c)] = parseInt(token)
          c += 1
    grid

# ============================================================================
# ITERATORS
# ============================================================================

iterator gridPositions*[T](grid: Grid[T]): Coord =
  ## Iterate over all grid positions
  for r in 0..<grid.height:
    for c in 0..<grid.width:
      yield (r, c)

iterator gridItems*[T](grid: Grid[T]): (Coord, T) =
  ## Iterate over all grid items with positions
  for r in 0..<grid.height:
    for c in 0..<grid.width:
      yield ((r, c), grid[r][c])

iterator mutableGridItems*[T](grid: var Grid[T]): (Coord, var T) =
  ## Mutable iteration for in-place modifications
  for r in 0..<grid.height:
    for c in 0..<grid.width:
      yield ((r, c), grid[r][c])
