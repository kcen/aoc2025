# Combinatorics Utilities for AOC
# Combinations, permutations, and mathematical combinatorics

import std/sequtils
import ./math # Import powMod function

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
# PRECOMPUTED FACTORIALS (High-Performance)
# ============================================================================

var factorialCache*: seq[int] = @[1] # Start with 0! = 1
var invFactorialCache*: seq[int] = @[1] # Start with 0!^-1 = 1

const DEFAULT_FACTORIAL_MOD* = 1_000_000_007

proc ensureFactorials*(n: int, modulus: int = DEFAULT_FACTORIAL_MOD) =
  ## Ensure factorials up to n are computed
  if n < factorialCache.len - 1:
    return

  let oldLen = factorialCache.len
  factorialCache.setLen(n + 1)
  for i in oldLen..n:
    factorialCache[i] = factorialCache[i-1] * i mod modulus

proc ensureInvFactorials*(n: int, modulus: int = DEFAULT_FACTORIAL_MOD) =
  ## Ensure inverse factorials up to n are computed
  ensureFactorials(n, modulus)

  if invFactorialCache.len == factorialCache.len:
    return

  let oldLen = invFactorialCache.len
  invFactorialCache.setLen(factorialCache.len)

  # Compute inverse factorials using Fermat's little theorem
  if oldLen == 1:
    invFactorialCache[n] = powMod(factorialCache[n], modulus - 2, modulus)
    for i in countdown(n - 1, 1):
      invFactorialCache[i] = invFactorialCache[i + 1] * (i + 1) mod modulus
  else:
    for i in oldLen..n:
      invFactorialCache[i] = invFactorialCache[i - 1] * invFactorialCache[i] mod modulus

proc initFastFactorials*(maxN: int, modulus: int = DEFAULT_FACTORIAL_MOD) =
  ## Initialize factorial caches up to maxN for O(1) lookups
  factorialCache = newSeq[int](maxN + 1)
  invFactorialCache = newSeq[int](maxN + 1)

  factorialCache[0] = 1
  for i in 1..maxN:
    factorialCache[i] = factorialCache[i-1] * i mod modulus

  invFactorialCache[maxN] = powMod(factorialCache[maxN], modulus - 2, modulus)
  for i in countdown(maxN - 1, 0):
    invFactorialCache[i] = invFactorialCache[i + 1] * (i + 1) mod modulus

proc nCrFast*(n, r: int, modulus: int = DEFAULT_FACTORIAL_MOD): int {.inline.} =
  ## Fast combination using precomputed factorials
  ensureFactorials(n, modulus)
  ensureInvFactorials(n, modulus)

  if r < 0 or r > n:
    return 0
  if r == 0 or r == n:
    return 1

  (factorialCache[n] * invFactorialCache[r] mod modulus * invFactorialCache[n -
      r]) mod modulus

proc nPrFast*(n, r: int, modulus: int = DEFAULT_FACTORIAL_MOD): int {.inline.} =
  ## Fast permutation using precomputed factorials
  ensureFactorials(n, modulus)
  ensureInvFactorials(n, modulus)

  if r < 0 or r > n:
    return 0
  (factorialCache[n] * invFactorialCache[n - r]) mod modulus

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
