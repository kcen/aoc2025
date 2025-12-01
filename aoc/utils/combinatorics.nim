# Combinatorics Utilities for AOC
# Combinations, permutations, and mathematical combinatorics

# import std/sequtils  # Uncomment if needed

# ============================================================================
# BASIC COMBINATORICS
# ============================================================================

proc combinations*[T](items: seq[T], r: int): seq[seq[T]] =
  ## Generate all r-combinations of items
  if r == 0:
    result = @[newSeq[T]()]
  elif items.len == 0 or r > items.len:
    result = @[]
  else:
    let head = items[0]
    let tail = items[1..^1]
    result = @[]
    # Combinations including head
    for combo in combinations(tail, r - 1):
      result.add(@[head] & combo)
    # Combinations not including head
    result &= combinations(tail, r)

proc permutations*[T](items: seq[T]): seq[seq[T]] =
  ## Generate all permutations of items
  if items.len <= 1:
    result = @[items]
  else:
    result = @[]
    for i in 0..<items.len:
      let head = items[i]
      var remaining: seq[T] = @[]
      # Manually build remaining sequence to avoid slicing issues
      for j in 0..<items.len:
        if j != i:
          remaining.add(items[j])
      for perm in permutations(remaining):
        result.add(@[head] & perm)

proc product*[T](seqs: seq[seq[T]]): seq[seq[T]] =
  ## Cartesian product of sequences
  if seqs.len == 0:
    result = @[newSeq[T]()]
  elif seqs[0].len == 0:
    result = @[]
  else:
    let head = seqs[0]
    let tail = seqs[1..^1]
    result = @[]
    for item in head:
      for combo in product(tail):
        result.add(@[item] & combo)

# ============================================================================
# COMBINATORICS HELPERS
# ============================================================================

proc countCombinations*(n, r: int): int =
  ## Count of nCr (combinations)
  if r > n or r < 0:
    return 0
  if r == 0 or r == n:
    return 1

  var count = 1
  for i in 0..<min(r, n - r):
    count = count * (n - i) div (i + 1)
  result = count

proc countPermutations*(n, r: int): int =
  ## Count of nPr (permutations)
  if r > n or r < 0:
    return 0
  if r == 0:
    return 1

  var count = 1
  for i in 0..<r:
    count *= (n - i)
  result = count

# ============================================================================
# MEMOIZATION SUPPORT
# ============================================================================

import std/tables

proc combinationsMemoized*(items: seq[int], r: int, memo: var Table[(int, int), int]): int =
  ## Memoized combination count (for large inputs)
  let key = (items.len, r)
  if key in memo:
    return memo[key]

  if r == 0 or r == items.len:
    result = 1
  elif r > items.len:
    result = 0
  else:
    result = combinationsMemoized(items[0..<items.len-1], r - 1, memo) +
        combinationsMemoized(items[0..<items.len-1], r, memo)

  memo[key] = result
