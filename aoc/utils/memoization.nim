# Memoization Utilities for AOC
# High-performance caching for recursive functions

import std/tables

# ============================================================================
# BASIC MEMOIZATION TEMPLATES
# ============================================================================

template memoizeRec*(fnName: untyped, `fn`: untyped): untyped =
  ## Memoize a recursive function with automatic caching
  ## TRANSFORMS: O(2^n) → O(n) for exponential algorithms
  var cache: Table[int, int] = initTable[int, int]()

  template fnName(n: int): int =
    if cache.hasKey(n):
      cache[n]
    else:
      let result = `fn`
      cache[n] = result
      result

# More flexible memoization for multi-argument functions
template memoize2Args*(fnName: untyped, `fn`: untyped): untyped =
  var cache: Table[(int, int), int] = initTable[(int, int), int]()

  template fnName(a, b: int): int =
    let key = (a, b)
    if cache.hasKey(key):
      cache[key]
    else:
      let result = `fn`
      cache[key] = result
      result

template memoize3Args*(fnName: untyped, `fn`: untyped): untyped =
  var cache: Table[(int, int, int), int] = initTable[(int, int, int), int]()

  template fnName(a, b, c: int): int =
    let key = (a, b, c)
    if cache.hasKey(key):
      cache[key]
    else:
      let result = `fn`
      cache[key] = result
      result

# ============================================================================
# SPECIALIZED MEMOIZATION PATTERNS
# ============================================================================

template memoizeCombinatorics*(fnName: untyped, `fn`: untyped): untyped =
  ## Optimized for combinatorics problems (nCr, nPr, etc.)
  var cache: Table[(int, int), int] = initTable[(int, int), int]()

  template fnName(n, r: int): int =
    let key = (n, r)
    if cache.hasKey(key):
      cache[key]
    else:
      let result = `fn`
      cache[key] = result
      result

template memoizeFibonacci*: untyped =
  ## Example: Fibonacci with memoization
  var cache: Table[int, int] = initTable[int, int]()
  cache[0] = 0
  cache[1] = 1

  template fibonacciMemoized(n: int): int =
    if cache.hasKey(n):
      cache[n]
    else:
      let result = fibonacciMemoized(n-1) + fibonacciMemoized(n-2)
      cache[n] = result
      result

template memoizeFactorial*: untyped =
  ## Example: Factorial with memoization
  var cache: Table[int, int] = initTable[int, int]()
  cache[0] = 1

  template factorialMemoized(n: int): int =
    if cache.hasKey(n):
      cache[n]
    else:
      let result = n * factorialMemoized(n-1)
      cache[n] = result
      result

# ============================================================================
# STRING-BASED MEMOIZATION
# ============================================================================

template memoizeString*(fnName: untyped, `fn`: untyped): untyped =
  var cache: Table[string, int] = initTable[string, int]()

  template fnName(s: string): int =
    if cache.hasKey(s):
      cache[s]
    else:
      let result = `fn`
      cache[s] = result
      result

# Example: Count palindromic substrings with memoization
template memoizePalindromic*: untyped =
  var cache: Table[string, int] = initTable[string, int]()

  template countPalindromicSubstrings(s: string): int =
    if cache.hasKey(s):
      cache[s]
    else:
      var count = 0
      # Expand around center algorithm
      for center in 0..<s.len:
        # Odd length
        var left = center
        var right = center
        while left >= 0 and right < s.len and s[left] == s[right]:
          count.inc
          left.dec
          right.inc

        # Even length
        left = center
        right = center + 1
        while left >= 0 and right < s.len and s[left] == s[right]:
          count.inc
          left.dec
          right.inc

      cache[s] = count
      count

# ============================================================================
# PERFORMANCE HELPERS
# ============================================================================

proc clearCache*[T, U](cache: var Table[T, U]) =
  ## Clear all cached values for a fresh computation
  cache.clear()

proc cacheSize*[T, U](cache: Table[T, U]): int =
  ## Get current cache size (for debugging/optimization)
  cache.len

proc hasCachedValue*[T, U](cache: Table[T, U], key: T): bool =
  ## Check if value is cached (useful for debugging)
  cache.hasKey(key)

# ============================================================================
# USAGE EXAMPLES
# ============================================================================

# Example 1: Fibonacci sequence
# template memoizeFibonacci* must be defined first
# Then: let fib40 = fibonacciMemoized(40)  # Instant vs exponential

# Example 2: Custom recursive function
# memoizeRec(countWays):
#   if n == 0: 1
#   elif n < 0: 0
#   else: countWays(n-1) + countWays(n-2)

# Example 3: Two-argument function (like nCr)
# memoize2Args(nCr):
#   if r == 0 or r == n: 1
#   else: nCr(n-1, r-1) + nCr(n-1, r)
