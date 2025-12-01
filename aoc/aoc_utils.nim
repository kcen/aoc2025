# AOC Utilities Library - Main Interface
# Comprehensive utilities for Advent of Code solutions
#
# Usage: import aoc/aoc_utils
# This provides access to all utility modules through a single import

# Core utilities (always needed)
from utils/core import
  getInput, getDay, Solution, printSolution, notImplemented,
  Range, contains, overlap, intersection, union, mergeRanges, rangeLength,
  countMatches, sumWhere, productWhere,
  groupBy, countBy, mostCommon

# Parsing utilities
from utils/parsing import
  parseLines, parseSections, parseTokens, parseInts, parseChars,
  extractInts, countOccurrences,
  isPalindrome, allPalindromes, matchPattern

# Grid and coordinate utilities
from utils/grid import
  Coord, Coord3, Direction, Direction3,
  DIRECTIONS_4, DIRECTIONS_8, DIRECTIONS_6_3D,
  `+`, `-`, `*`, manhattanDistance,
  Grid, newGrid, width, height, inBounds, get, `[]`, `[]=`,
  neighbors, neighborsWithValues,
  mapGrid, filterGrid, findFirst, findAll,
  rotateClockwise, rotateCounterClockwise, flipHorizontal, flipVertical,
      transpose,
  parseCharGrid, parseIntGrid,
  linearIndex, coordFromIndex, gridToLinear, linearToGrid,
  gridPositions, gridItems, mutableGridItems

# Mathematical utilities
from utils/math import
  gcd, lcm, gcdSeq, lcmSeq, gcdBinary,
  powMod, modInverse, modAdd, modSub, modMul, modPowFast, chineseRemainder,
  MOD,
  isPrimeFast, smallestPrimeFactor, primeFactorization,
  fibonacciFast, tribonacciFast,
  digitSum, digitProduct, digitCount, reverseNumber, isPalindromeNumber,
  initFactorials, nCrFast, nPrFast

# Combinatorics utilities
from utils/combinatorics import
  combinations, permutations, product,
  countCombinations, countPermutations, combinationsMemoized

# Bit manipulation utilities
from utils/bitops import
  DIGIT_SUM_LUT, POPCOUNT_LUT, CHAR_CLASS_LUT,
  CHAR_IS_DIGIT, CHAR_IS_ALPHA, CHAR_IS_ALPHANUMERIC, CHAR_IS_SPACE,
      CHAR_IS_UPPER, CHAR_IS_LOWER,
  digitSumLUT, popcountLUT, isDigitLUT, isAlphaLUT,
  popcount, hasBit, setBit, clearBit, toggleBit, setBits,
  isEven, isOdd, isPowerOf2, roundUpToPowerOf2, lowestBitSet, highestBitSet,
  divideRoundUp, modAbsolute,
  BitPacked8, BitPacked4, initBitPacked8, initBitPacked4, setBit8, getBit8, countSetBits8

# Performance optimization utilities
from utils/performance import
  sign, absMin, absMax, clamp, lerp, lerpInt,
  minH, maxH, sumH, prodH, minmaxH,
  dotProduct, dotProduct2, manhattanDistanceFast,
  prefixSum, prefixProduct, suffixSum, pairwiseDifferences,
  parseIntsFast,
  linearSearchWithSentinel,
  sumBatch, minBatch,
  indexSort, argsort,
  binarySearchFirst, binarySearchLast, binarySearchLE, binarySearchGE

# ============================================================================
# EXPORT ALL PUBLIC SYMBOLS
# ============================================================================

export
  # Core
  getInput, getDay, Solution, printSolution, notImplemented,
  Range, contains, overlap, intersection, union, mergeRanges, rangeLength,
  countMatches, sumWhere, productWhere,
  groupBy, countBy, mostCommon,

  # Parsing
  parseLines, parseSections, parseTokens, parseInts, parseChars,
  extractInts, countOccurrences,
  isPalindrome, allPalindromes, matchPattern,

  # Grid
  Coord, Coord3, Direction, Direction3,
  DIRECTIONS_4, DIRECTIONS_8, DIRECTIONS_6_3D,
  manhattanDistance,
  Grid, newGrid, width, height, inBounds, get, `[]`, `[]=`,
  neighbors, neighborsWithValues,
  mapGrid, filterGrid, findFirst, findAll,
  rotateClockwise, rotateCounterClockwise, flipHorizontal, flipVertical,
      transpose,
  parseCharGrid, parseIntGrid,
  linearIndex, coordFromIndex, gridToLinear, linearToGrid,
  gridPositions, gridItems, mutableGridItems,

  # Math
  gcd, lcm, gcdSeq, lcmSeq, gcdBinary,
  powMod, modInverse, modAdd, modSub, modMul, modPowFast, chineseRemainder,
  MOD,
  isPrimeFast, smallestPrimeFactor, primeFactorization,
  fibonacciFast, tribonacciFast,
  digitSum, digitProduct, digitCount, reverseNumber, isPalindromeNumber,
  initFactorials, nCrFast, nPrFast,

  # Combinatorics
  combinations, permutations, product,
  countCombinations, countPermutations, combinationsMemoized,

  # Bit operations
  DIGIT_SUM_LUT, POPCOUNT_LUT, CHAR_CLASS_LUT,
  CHAR_IS_DIGIT, CHAR_IS_ALPHA, CHAR_IS_ALPHANUMERIC, CHAR_IS_SPACE,
      CHAR_IS_UPPER, CHAR_IS_LOWER,
  digitSumLUT, popcountLUT, isDigitLUT, isAlphaLUT,
  popcount, hasBit, setBit, clearBit, toggleBit, setBits,
  isEven, isOdd, isPowerOf2, roundUpToPowerOf2, lowestBitSet, highestBitSet,
  divideRoundUp, modAbsolute,
  BitPacked8, BitPacked4, initBitPacked8, initBitPacked4, setBit8, getBit8,
      countSetBits8,

  # Performance
  sign, absMin, absMax, clamp, lerp, lerpInt,
  minH, maxH, sumH, prodH, minmaxH,
  dotProduct, dotProduct2, manhattanDistanceFast,
  prefixSum, prefixProduct, suffixSum, pairwiseDifferences,
  parseIntsFast,
  linearSearchWithSentinel,
  sumBatch, minBatch,
  indexSort, argsort,
  binarySearchFirst, binarySearchLast, binarySearchLE, binarySearchGE

# ============================================================================
# DOCUMENTATION
# ============================================================================

# This module provides a comprehensive set of utilities for solving Advent of Code problems.
#
# Key features:
# - Input/output utilities for AOC data
# - String parsing and extraction functions
# - 2D/3D coordinate and grid operations
# - Mathematical utilities (GCD, LCM, modular arithmetic, etc.)
# - Combinatorics (combinations, permutations)
# - Bit manipulation and performance optimizations
# - SIMD-friendly and branch-free operations
#
# Example usage:
# ```
# import aoc/aoc_utils
#
# let input = getInput()
# let lines = input.parseLines()
# let numbers = lines[0].parseInts()
#
# let grid = parseCharGrid(lines)
# let positions = findAll(grid, proc(c: char): bool = c == 'X')
#
# let result = sumH(numbers)
# echo printSolution(Solution(part_one: $result, part_two: "42"))
# ```
#
# For best performance, compile with:
# nim c -d:release --opt:speed --gc:arc solution.nim
