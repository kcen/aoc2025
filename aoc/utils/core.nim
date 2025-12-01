# Core AOC Utilities - Basic Input/Output and Data Types
# Core functionality that most AOC solutions will need

import std/[strutils, os, algorithm]
# Import from private constants for Range functionality

# ============================================================================
# INPUT/OUTPUT SECTION
# ============================================================================

proc getInput*(): string =
  ## Get input for current day, with fallback to test file
  let filename = getEnv("AOC_INPUT", "inputs/hello_world")
  if fileExists(filename):
    return strip(readFile(filename))
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
# RANGE AND INTERVAL UTILITIES
# ============================================================================

type
  Range* = tuple[start, ending: int]

proc contains*(r: Range, x: int): bool =
  x >= r.start and x <= r.ending

proc overlap*(r1, r2: Range): bool =
  r1.start <= r2.ending and r2.start <= r1.ending

proc intersection*(r1, r2: Range): Range =
  (max(r1.start, r2.start), min(r1.ending, r2.ending))

proc union*(r1, r2: Range): seq[Range] =
  ## Union of two ranges (may be disjoint)
  if overlap(r1, r2):
    @[(min(r1.start, r2.start), max(r1.ending, r2.ending))]
  else:
    @[r1, r2]

proc mergeRanges*(ranges: seq[Range]): seq[Range] =
  ## Merge overlapping ranges
  if ranges.len == 0: return @[]

  var sorted = ranges
  sorted.sort(proc(a, b: Range): int = cmp(a.start, b.start))

  var merged = @[sorted[0]]
  for i in 1..<sorted.len:
    let last = merged[^1]
    let current = sorted[i]

    if overlap(last, current):
      merged[^1] = (last.start, max(last.ending, current.ending))
    else:
      merged.add(current)

  merged

proc rangeLength*(r: Range): int =
  r.ending - r.start + 1


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
  var result: Table[K, seq[T]]
  for item in items:
    let key = keyFn(item)
    if key notin result:
      result[key] = @[]
    result[key].add(item)
  result

proc countBy*[T, K](items: seq[T], keyFn: proc(x: T): K): Table[K, int] =
  ## Count items by key function
  var table: Table[K, int]
  for item in items:
    let key = keyFn(item)
    table[key] = table.getOrDefault(key, 0) + 1
  result = table

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
