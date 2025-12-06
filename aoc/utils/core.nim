# Core AOC Utilities - Basic Input/Output and Data Types
# Core functionality that most AOC solutions will need

import std/[strutils, os, algorithm]
import ./grid # Import Coord3 type for 3D range operations

# ============================================================================
# INPUT/OUTPUT SECTION
# ============================================================================

proc getInput*(strip = true): string =
  ## Get input for current day, with fallback to test file
  let filename = getEnv("AOC_INPUT", "inputs/hello_world")
  if fileExists(filename):
    if strip:
      return strip(readFile(filename))
    else:
      return readFile(filename)
  echo "Input file not found"
  quit(QuitFailure)

proc getDay*(): int =
  ## Get current AOC day from environment, or return -1 if not set
  return (try: parseInt(getEnv("AOC_DAY")) except ValueError: -1)

# ============================================================================
# SOLUTION RESULT TYPE
# ============================================================================

type Solution* = object
  part_one*, part_two*: string

proc printSolution*(soln: Solution) =
  ## Print solution in JSON format for easy parsing
  let prefix = "{\"part_one\":\""
  let infix = "\",\"part_two\":\""
  let suffix = "\"}"
  echo prefix, soln.part_one, infix, soln.part_two, suffix

proc notImplemented*() =
  ## Print not implemented message
  echo "\"not implemented\""

# ============================================================================
# RANGE AND INTERVAL UTILITIES (OPTIMIZED)
# ============================================================================

type
  Range* = tuple[start, ending: int]
  Range3D* = tuple[x: tuple[min, max: int], y: tuple[min, max: int], z: tuple[
      min, max: int]]

proc contains*(r: Range, x: int): bool {.inline, noSideEffect.} =
  x >= r.start and x <= r.ending

proc contains*(r: Range3D, x, y, z: int): bool {.inline, noSideEffect.} =
  x >= r.x.min and x <= r.x.max and
  y >= r.y.min and y <= r.y.max and
  z >= r.z.min and z <= r.z.max

proc overlap*(r1, r2: Range): bool {.inline, noSideEffect.} =
  r1.start <= r2.ending and r2.start <= r1.ending

proc intersection*(r1, r2: Range): Range {.inline, noSideEffect.} =
  (max(r1.start, r2.start), min(r1.ending, r2.ending))

proc intersectionEmpty*(r1, r2: Range): bool {.inline, noSideEffect.} =
  r1.start > r2.ending or r2.start > r1.ending

proc union*(r1, r2: Range): seq[Range] =
  ## Union of two ranges (may be disjoint)
  if overlap(r1, r2):
    @[(min(r1.start, r2.start), max(r1.ending, r2.ending))]
  else:
    @[r1, r2]

proc mergeRanges*(ranges: seq[Range]): seq[Range] =
  ## Merge overlapping ranges efficiently
  if ranges.len == 0: return @[]

  var sorted = ranges
  sorted.sort(proc(a, b: Range): int = cmp(a.start, b.start))

  var merged = @[sorted[0]]
  for i in 1..<sorted.len:
    let last = merged[^1]
    let current = sorted[i]

    if last.ending + 1 >= current.start: # Overlapping or adjacent
      merged[^1] = (last.start, max(last.ending, current.ending))
    else:
      merged.add(current)

  merged

proc mergeRangesFast*(ranges: var seq[Range]) =
  ## In-place merge of overlapping ranges
  if ranges.len == 0: return

  ranges.sort(proc(a, b: Range): int = cmp(a.start, b.start))

  var writeIdx = 0
  for readIdx in 1..<ranges.len:
    if ranges[writeIdx].ending + 1 >= ranges[readIdx].start:
      ranges[writeIdx].ending = max(ranges[writeIdx].ending, ranges[
          readIdx].ending)
    else:
      writeIdx.inc
      ranges[writeIdx] = ranges[readIdx]

  ranges.setLen(writeIdx + 1)

proc totalRangeLength*(ranges: seq[Range]): int =
  ## Get total covered length (sum of merged ranges)
  let merged = mergeRanges(ranges)
  var total = 0
  for r in merged:
    total += r.ending - r.start + 1
  total

proc rangeLength*(r: Range): int {.inline, noSideEffect.} =
  r.ending - r.start + 1

proc isEmpty*(r: Range): bool {.inline, noSideEffect.} =
  r.start > r.ending

proc expand*(r: var Range, amount: int) =
  r.start -= amount
  r.ending += amount

proc expandBy*(r: Range, amount: int): Range {.inline, noSideEffect.} =
  (r.start - amount, r.ending + amount)

proc subrange*(r: Range, start, finish: int): Range =
  let s = max(r.start, start)
  let e = min(r.ending, finish)
  if s <= e: (s, e) else: (1, 0) # Empty range

# 3D Range operations
proc volume*(r: Range3D): int {.inline, noSideEffect.} =
  (r.x.max - r.x.min + 1) *
  (r.y.max - r.y.min + 1) *
  (r.z.max - r.z.min + 1)

proc containsPoint3D*(r: Range3D, p: Coord3): bool {.inline, noSideEffect.} =
  p.x >= r.x.min and p.x <= r.x.max and
  p.y >= r.y.min and p.y <= r.y.max and
  p.z >= r.z.min and p.z <= r.z.max

# Helper to create ranges from coordinates
proc rangeFromPoints*(a, b: Coord): Range {.inline, noSideEffect.} =
  (min(a.r, b.r), max(a.r, b.r))

# Batch range operations for performance
proc batchContains*(ranges: seq[Range], x: int): int =
  ## Find index of range containing x, or -1 if none
  for i, r in ranges:
    if r.contains(x):
      return i
  -1

proc findOverlappingRanges*(ranges: seq[Range], query: Range): seq[int] =
  ## Find all ranges that overlap with query
  for i, r in ranges:
    if r.overlap(query):
      result.add(i)


# ============================================================================
# AGGREGATION HELPERS
# ============================================================================

proc countMatches*[T](arr: seq[T], predicate: proc(x: T): bool): int =
  ## Count number of elements matching predicate
  var count = 0
  for item in arr:
    if predicate(item):
      count.inc
  count

proc sumWhere*[T](arr: seq[T], predicate: proc(x: T): bool): int =
  ## Sum elements that match predicate
  var total = 0
  for item in arr:
    if predicate(item):
      total += int(item)
  total

proc productWhere*[T](arr: seq[T], predicate: proc(x: T): bool): int =
  ## Product of elements that match predicate
  var prod = 1
  for item in arr:
    if predicate(item):
      prod *= int(item)
  prod

# ============================================================================
# GROUPING AND COUNTING
# ============================================================================

import std/tables

proc groupBy*[T, K](items: seq[T], keyFn: proc(x: T): K): Table[K, seq[T]] =
  ## Group items by key function
  for item in items:
    let key = keyFn(item)
    if key notin result:
      result[key] = @[]
    result[key].add(item)

proc countBy*[T, K](items: seq[T], keyFn: proc(x: T): K): Table[K, int] =
  ## Count items by key function
  for item in items:
    let key = keyFn(item)
    result[key] = result.getOrDefault(key, 0) + 1

proc mostCommon*[T](items: seq[T]): T =
  ## Find most common element
  var counts: Table[T, int]
  var maxCount = 0
  var common: T

  for item in items:
    counts[item] = counts.getOrDefault(item, 0) + 1
    if counts[item] > maxCount:
      maxCount = counts[item]
      common = item

  result = common
