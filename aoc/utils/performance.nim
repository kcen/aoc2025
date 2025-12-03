# Performance Optimizations for AOC
# SIMD-friendly, branch-free, and cache-optimized operations

import std/[sequtils, deques, strutils]
import ./grid

# ============================================================================
# BRANCH-FREE COMPARISON OPERATIONS
# ============================================================================

proc sign*(x: int): int =
  ## Return -1, 0, or 1 (branch-free)
  (x > 0).int - (x < 0).int

proc sign*(x: float): int =
  ## Return -1, 0, or 1 for float
  ((x > 0.0).int - (x < 0.0).int)

proc absMin*(a, b: int): int =
  ## Return value with minimum absolute value
  if abs(a) < abs(b): a else: b

proc absMax*(a, b: int): int =
  ## Return value with maximum absolute value
  if abs(a) > abs(b): a else: b

proc clamp*(x, minVal, maxVal: int): int =
  max(minVal, min(x, maxVal))

proc clamp*(x, minVal, maxVal: float): float =
  max(minVal, min(x, maxVal))

proc lerp*(a, b: float, t: float): float =
  ## Linear interpolation: a + (b - a) * t
  a + (b - a) * t

proc lerpInt*(a, b, t, scale: int): int =
  ## Integer lerp: (a * (scale - t) + b * t) / scale
  (a * (scale - t) + b * t) div scale

# ============================================================================
# HORIZONTAL OPERATIONS (MIN/MAX/SUM ACROSS SEQUENCES)
# ============================================================================

proc minH*[T: int | float](items: seq[T]): T =
  ## Find minimum value (horizontal min)
  if items.len == 0: return 0
  result = items[0]
  for i in 1..<items.len:
    if items[i] < result:
      result = items[i]

proc maxH*[T: int | float](items: seq[T]): T =
  ## Find maximum value (horizontal max)
  if items.len == 0: return 0
  result = items[0]
  for i in 1..<items.len:
    if items[i] > result:
      result = items[i]

proc sumH*[T: int | float](items: seq[T]): T =
  ## Sum all elements (horizontal add)
  result = 0
  for item in items:
    result += item

proc prodH*[T: int | float](items: seq[T]): T =
  ## Product of all elements
  result = 1
  for item in items:
    result *= item

proc minmaxH*[T: int | float](items: seq[T]): (T, T) =
  ## Find both min and max in single pass (faster than calling both)
  if items.len == 0:
    return (0, 0)
  var minVal = items[0]
  var maxVal = items[0]
  for i in 1..<items.len:
    if items[i] < minVal:
      minVal = items[i]
    if items[i] > maxVal:
      maxVal = items[i]
  (minVal, maxVal)

# ============================================================================
# FAST VECTOR OPERATIONS (SIMD-FRIENDLY)
# ============================================================================

proc dotProduct*[T](a, b: seq[T]): T =
  ## Dot product: sum of element-wise products
  result = 0
  for i in 0..<a.len:
    result += a[i] * b[i]

proc dotProduct2*(a, b: seq[Coord]): int =
  ## 2D dot product (for coordinates)
  result = 0
  for i in 0..<a.len:
    result += a[i].r * b[i].r + a[i].c * b[i].c

proc manhattanDistanceFast*(positions: seq[Coord]): int =
  ## Sum of Manhattan distances from origin
  result = 0
  for pos in positions:
    result += abs(pos.r) + abs(pos.c)

proc prefixSum*[T](arr: seq[T]): seq[T] =
  ## Compute prefix sum array
  result = newSeq[T](arr.len)
  if arr.len == 0: return

  result[0] = arr[0]
  for i in 1..<arr.len:
    result[i] = result[i-1] + arr[i]

proc prefixProduct*[T](arr: seq[T]): seq[T] =
  ## Compute prefix product array
  result = newSeq[T](arr.len)
  if arr.len == 0: return

  result[0] = arr[0]
  for i in 1..<arr.len:
    result[i] = result[i-1] * arr[i]

proc suffixSum*[T](arr: seq[T]): seq[T] =
  ## Compute suffix sum array
  result = newSeq[T](arr.len)
  if arr.len == 0: return

  result[^1] = arr[^1]
  for i in countdown(arr.len - 2, 0):
    result[i] = result[i+1] + arr[i]

proc pairwiseDifferences*[T](arr: seq[T]): seq[T] =
  ## Compute consecutive differences: [arr[i+1] - arr[i]]
  result = newSeq[T](arr.len - 1)
  for i in 0..<arr.len - 1:
    result[i] = arr[i+1] - arr[i]

# ============================================================================
# FAST PARSING WITH BATCH CHARACTER PROCESSING
# ============================================================================

proc parseIntsFast*(s: string, sep = ' '): seq[int] =
  ## Fast integer parsing with minimal allocations
  var numbers: seq[int] = @[]
  var currentNum = 0
  var isNegative = false

  for c in s:
    if c == '-':
      isNegative = true
    elif c.isDigit():
      currentNum = currentNum * 10 + (ord(c) - ord('0'))
    elif c == sep or c == '\n':
      if currentNum != 0 or isNegative:
        numbers.add(if isNegative: -currentNum else: currentNum)
        currentNum = 0
        isNegative = false

  if currentNum != 0 or isNegative:
    numbers.add(if isNegative: -currentNum else: currentNum)

  result = numbers

# ============================================================================
# SENTINEL-BASED SEARCH (Branch-free)
# ============================================================================

proc linearSearchWithSentinel*[T](arr: seq[T], target: T): int =
  ## Find target with sentinel (no bounds check in loop)
  if arr.len == 0: return -1

  let last = arr[^1]
  var temp = arr[^1]
  arr[^1] = target # Sentinel

  var i = 0
  while arr[i] != target:
    i.inc

  arr[^1] = temp # Restore

  if i < arr.len - 1 or last == target:
    i
  else:
    -1

# ============================================================================
# BATCH PROCESSING OPERATIONS
# ============================================================================

proc sumBatch*[T: int | float](arr: seq[T], batchSize = 4): T =
  ## Sum with manual loop unrolling for better SIMD
  var acc0, acc1, acc2, acc3: T
  let len = arr.len
  var i = 0

  while i <= len - batchSize:
    acc0 += arr[i]
    if i + 1 < len: acc1 += arr[i + 1]
    if i + 2 < len: acc2 += arr[i + 2]
    if i + 3 < len: acc3 += arr[i + 3]
    i += batchSize

  while i < len:
    acc0 += arr[i]
    i.inc

  acc0 + acc1 + acc2 + acc3

proc minBatch*[T](arr: seq[T], batchSize = 4): T =
  ## Find min with batch processing
  if arr.len == 0:
    return 0.T

  var result = arr[0]
  for i in 1..<arr.len:
    if arr[i] < result:
      result = arr[i]
  result

# ============================================================================
# FAST SORTING UTILITIES
# ============================================================================

proc indexSort*[T](arr: seq[T]): seq[int] =
  ## Return indices that would sort the array (stable)
  result = toSeq(0..<arr.len)
  result.sort(proc(a, b: int): int = cmp(arr[a], arr[b]))

proc argsort*[T](arr: seq[T], reverse = false): seq[int] =
  ## NumPy-style argsort
  result = toSeq(0..<arr.len)
  if reverse:
    result.sort(proc(a, b: int): int = cmp(arr[b], arr[a]))
  else:
    result.sort(proc(a, b: int): int = cmp(arr[a], arr[b]))

# ============================================================================
# FAST SEARCH UTILITIES (BINARY SEARCH VARIANTS)
# ============================================================================

proc binarySearchFirst*[T](arr: seq[T], target: T): int =
  ## Find first index of target (or -1 if not found)
  var left = 0
  var right = arr.len - 1
  result = -1

  while left <= right:
    let mid = (left + right) shr 1
    if arr[mid] == target:
      result = mid
      right = mid - 1 # Continue searching left
    elif arr[mid] < target:
      left = mid + 1
    else:
      right = mid - 1

proc binarySearchLast*[T](arr: seq[T], target: T): int =
  ## Find last index of target (or -1 if not found)
  var left = 0
  var right = arr.len - 1
  result = -1

  while left <= right:
    let mid = (left + right) shr 1
    if arr[mid] == target:
      result = mid
      left = mid + 1 # Continue searching right
    elif arr[mid] < target:
      left = mid + 1
    else:
      right = mid - 1

proc binarySearchLE*[T](arr: seq[T], target: T): int =
  ## Find largest element <= target (or -1 if none)
  var left = 0
  var right = arr.len - 1
  result = -1

  while left <= right:
    let mid = (left + right) shr 1
    if arr[mid] <= target:
      result = mid
      left = mid + 1
    else:
      right = mid - 1

proc binarySearchGE*[T](arr: seq[T], target: T): int =
  ## Find smallest element >= target (or -1 if none)
  var left = 0
  var right = arr.len - 1
  result = -1

  while left <= right:
    let mid = (left + right) shr 1
    if arr[mid] >= target:
      result = mid
      right = mid - 1
    else:
      left = mid + 1
