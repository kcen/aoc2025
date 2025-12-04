# Grid Operations and Coordinate Types for AOC
# 2D/3D coordinate handling, grid manipulation, and spatial algorithms

import std/[sequtils, algorithm, strutils, tables]

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
  for r in 0..<grid.height:
    for c in 0..<grid.width:
      if predicate(grid[r][c]):
        result.add(((r, c), grid[r][c]))

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
  var linear = newSeq[T](grid.height * grid.width)
  var idx = 0
  for row in grid:
    for cell in row:
      linear[idx] = cell
      idx.inc
  linear

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
# FLAT GRID OPERATIONS (MEMORY-EFFICIENT, SAME INTERFACE AS GRID)
# ============================================================================

proc newFlatGrid*[T](width, height: int, default: T): FlatGrid[T] =
  ## Create a flat grid with dimensions and default value
  FlatGrid[T](
    data: newSeq[T](width * height).mapIt(default),
    width: width,
    height: height
  )

proc width*[T](grid: FlatGrid[T]): int {.inline, noSideEffect.} =
  grid.width

proc height*[T](grid: FlatGrid[T]): int {.inline, noSideEffect.} =
  grid.height

proc inBounds*[T](grid: FlatGrid[T], pos: Coord): bool {.inline,
    noSideEffect.} =
  pos.r >= 0 and pos.r < grid.height and pos.c >= 0 and pos.c < grid.width

proc get*[T](grid: FlatGrid[T], pos: Coord, default: T): T =
  if grid.inBounds(pos): grid.data[pos.r * grid.width + pos.c] else: default

proc `[]`*[T](grid: FlatGrid[T], pos: Coord): T =
  grid.data[pos.r * grid.width + pos.c]

proc `[]=`*[T](grid: var FlatGrid[T], pos: Coord, val: T) =
  grid.data[pos.r * grid.width + pos.c] = val

proc neighbors*[T](grid: FlatGrid[T], pos: Coord, diagonals = false): seq[Coord] =
  ## Get valid neighbors of a position
  let dirs = if diagonals: DIRECTIONS_8.toSeq else: DIRECTIONS_4.toSeq
  for dir in dirs:
    let newPos = pos + dir
    if grid.inBounds(newPos):
      result.add(newPos)

proc neighborsWithValues*[T](grid: FlatGrid[T], pos: Coord,
    diagonals = false): seq[(Coord, T)] =
  ## Get valid neighbors with their values
  for neighbor in grid.neighbors(pos, diagonals):
    result.add((neighbor, grid[neighbor]))

proc flatToGrid*[T](flat: FlatGrid[T]): Grid[T] =
  ## Convert flat grid to nested grid
  var grid = newSeq[seq[T]](flat.height)
  for r in 0..<flat.height:
    grid[r] = newSeq[T](flat.width)
    for c in 0..<flat.width:
      grid[r][c] = flat[(r, c)]
  grid

proc gridToFlat*[T](grid: Grid[T]): FlatGrid[T] =
  ## Convert nested grid to flat grid
  let h = grid.height
  let w = grid.width
  var flat = newFlatGrid[T](w, h, grid[0][0])
  for r in 0..<h:
    for c in 0..<w:
      flat[(r, c)] = grid[(r, c)]
  flat

proc parseCharGridFlat*(input: string): FlatGrid[char] =
  ## Parse raw input string to flat character grid
  ## Width = chars until first newline, height = total chars / width
  if input.len == 0:
    return FlatGrid[char](data: @[], width: 0, height: 0)

  # Find width from first line
  var width = 0
  for c in input:
    if c == '\n': break
    inc width

  # Build data, skipping newlines
  var data: seq[char] = @[]
  for c in input:
    if c != '\n':
      data.add(c)

  let height = data.len div width
  FlatGrid[char](data: data, width: width, height: height)

proc parseIntGridFlat*(input: string): FlatGrid[int] =
  ## Parse raw input string to flat integer grid (each char is a digit)
  if input.len == 0:
    return FlatGrid[int](data: @[], width: 0, height: 0)

  # Find width from first line
  var width = 0
  for c in input:
    if c == '\n': break
    inc width

  # Build data, skipping newlines
  var data: seq[int] = @[]
  for c in input:
    if c != '\n':
      data.add(int(c) - int('0'))

  let height = data.len div width
  FlatGrid[int](data: data, width: width, height: height)

# ============================================================================
# SPARSE GRID OPERATIONS (MEMORY-EFFICIENT FOR SPARSE DATA)
# ============================================================================

type
  SparseGrid*[T] = object
    data*: Table[Coord, T] # Only stores non-empty cells
    width*: int
    height*: int
    empty*: T              # The value considered "empty" (not stored)

proc newSparseGrid*[T](width, height: int, empty: T): SparseGrid[T] =
  ## Create a sparse grid with dimensions and empty value
  SparseGrid[T](
    data: initTable[Coord, T](),
    width: width,
    height: height,
    empty: empty
  )

proc width*[T](grid: SparseGrid[T]): int {.inline, noSideEffect.} =
  grid.width

proc height*[T](grid: SparseGrid[T]): int {.inline, noSideEffect.} =
  grid.height

proc inBounds*[T](grid: SparseGrid[T], pos: Coord): bool {.inline,
    noSideEffect.} =
  pos.r >= 0 and pos.r < grid.height and pos.c >= 0 and pos.c < grid.width

proc get*[T](grid: SparseGrid[T], pos: Coord, default: T): T =
  if not grid.inBounds(pos): return default
  grid.data.getOrDefault(pos, grid.empty)

proc `[]`*[T](grid: SparseGrid[T], pos: Coord): T =
  grid.data.getOrDefault(pos, grid.empty)

proc `[]=`*[T](grid: var SparseGrid[T], pos: Coord, val: T) =
  if val == grid.empty:
    grid.data.del(pos) # Remove if setting to empty
  else:
    grid.data[pos] = val

proc neighbors*[T](grid: SparseGrid[T], pos: Coord, diagonals = false): seq[Coord] =
  ## Get valid neighbors of a position
  let dirs = if diagonals: DIRECTIONS_8.toSeq else: DIRECTIONS_4.toSeq
  for dir in dirs:
    let newPos = pos + dir
    if grid.inBounds(newPos):
      result.add(newPos)

proc neighborsWithValues*[T](grid: SparseGrid[T], pos: Coord,
    diagonals = false): seq[(Coord, T)] =
  ## Get valid neighbors with their values
  for neighbor in grid.neighbors(pos, diagonals):
    result.add((neighbor, grid[neighbor]))

proc parseSparseGrid*(input: string, empty: char = ' '): SparseGrid[char] =
  ## Parse raw input string to sparse character grid
  ## Only stores non-empty cells for memory efficiency
  if input.len == 0:
    return SparseGrid[char](data: initTable[Coord, char](), width: 0, height: 0, empty: empty)

  # Find width from first line
  var width = 0
  for c in input:
    if c == '\n': break
    inc width

  # Build sparse data, only storing non-empty cells
  var data = initTable[Coord, char]()
  var r = 0
  var c = 0
  for ch in input:
    if ch == '\n':
      inc r
      c = 0
    else:
      if ch != empty:
        data[(r, c)] = ch
      inc c

  let height = r + (if c > 0: 1 else: 0)
  SparseGrid[char](data: data, width: width, height: height, empty: empty)

proc sparseToGrid*[T](sparse: SparseGrid[T]): Grid[T] =
  ## Convert sparse grid to nested grid
  result = newSeqWith(sparse.height, newSeq[T](sparse.width).mapIt(sparse.empty))
  for pos, val in sparse.data.pairs:
    result[pos.r][pos.c] = val

proc gridToSparse*[T](grid: Grid[T], empty: T): SparseGrid[T] =
  ## Convert nested grid to sparse grid
  result = newSparseGrid[T](grid.width, grid.height, empty)
  for r in 0..<grid.height:
    for c in 0..<grid.width:
      if grid[r][c] != empty:
        result.data[(r, c)] = grid[r][c]

proc count*[T](grid: SparseGrid[T]): int {.inline.} =
  ## Count of non-empty cells
  grid.data.len

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
