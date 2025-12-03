# AOC Utilities Library - Main Interface
# Comprehensive utilities for Advent of Code solutions

# Core utilities (always needed)
from utils/core import
  getInput, getDay, Solution, printSolution, notImplemented,
  Range, contains, overlap, intersection, union, mergeRanges, rangeLength,
  countMatches, sumWhere, productWhere,
  groupBy, countBy, mostCommon

# Parsing utilities
from utils/parsing import
  parseLines, parseSections, parseTokens, parseInts, parseChars,
  lineChars, extractInts, countOccurrences,
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

# Mathematical utilities (no factorial functions - they are in combinatorics)
from utils/math import
  gcd, lcm, gcdSeq, lcmSeq, gcdBinary,
  POW10_LUT, pow10,
  powMod, modInverse, modAdd, modSub, modMul, modPowFast, chineseRemainder,
  MOD,
  isPrimeFast, smallestPrimeFactor, primeFactorization,
  fibonacciFast, tribonacciFast,
  digitSum, digitProduct, digitCount, reverseNumber, isPalindromeNumber

# Combinatorics utilities (includes all factorial and combination functions)
from utils/combinatorics import
  combinations, permutations, product,
  countCombinations, countPermutations, combinationsMemoized,
  initFastFactorials, ensureFactorials, ensureInvFactorials, nCrFast, nPrFast

# Memoization utilities (template-based caching for recursive functions)
from utils/memoization import
  memoizeRec, memoize2Args, memoize3Args, memoizeCombinatorics,
  memoizeString, memoizeFibonacci, memoizeFactorial

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
  lineChars, extractInts, countOccurrences,
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

  # Math (factorial functions are in combinatorics)
  gcd, lcm, gcdSeq, lcmSeq, gcdBinary,
  POW10_LUT, pow10,
  powMod, modInverse, modAdd, modSub, modMul, modPowFast, chineseRemainder,
  MOD,
  isPrimeFast, smallestPrimeFactor, primeFactorization,
  fibonacciFast, tribonacciFast,
  digitSum, digitProduct, digitCount, reverseNumber, isPalindromeNumber,

  # Combinatorics (includes all factorial and combination functions)
  combinations, permutations, product,
  countCombinations, countPermutations, combinationsMemoized,
  initFastFactorials, ensureFactorials, ensureInvFactorials, nCrFast, nPrFast,

  # Memoization (template-based caching)
  memoizeRec, memoize2Args, memoize3Args, memoizeCombinatorics,
  memoizeString, memoizeFibonacci, memoizeFactorial,

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
