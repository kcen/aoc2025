# Performance Utility Tests
# Tests for performance optimization and SIMD-friendly operations

import unittest
import ../aoc/aoc_utils

suite "Branch-Free Operations":
  test "sign: get sign without branches":
    check sign(-5) == -1
    check sign(0) == 0
    check sign(5) == 1

  test "clamp: limit to range":
    check clamp(5, 0, 10) == 5
    check clamp(-1, 0, 10) == 0
    check clamp(15, 0, 10) == 10

  test "absMin: minimum absolute value":
    check absMin(3, -5) == 3
    check absMin(-3, -5) == -3

suite "Horizontal Operations":
  test "sumH: sum all elements":
    let arr = @[1, 2, 3, 4, 5]
    check sumH(arr) == 15

  test "minH: find minimum":
    let arr = @[5, 2, 8, 1, 9]
    check minH(arr) == 1

  test "maxH: find maximum":
    let arr = @[5, 2, 8, 1, 9]
    check maxH(arr) == 9

  test "minmaxH: find both min and max":
    let arr = @[5, 2, 8, 1, 9]
    let (minVal, maxVal) = minmaxH(arr)
    check minVal == 1
    check maxVal == 9

  test "prodH: product of all elements":
    let arr = @[2, 3, 4]
    check prodH(arr) == 24

suite "Vector Operations":
  test "dotProduct: element-wise products":
    let a = @[1, 2, 3]
    let b = @[4, 5, 6]
    check dotProduct(a, b) == 32 # 1*4 + 2*5 + 3*6 = 4 + 10 + 18 = 32

suite "Array Operations":
  test "prefixSum: compute prefix sums":
    let arr = @[1, 2, 3, 4, 5]
    let value = prefixSum(arr)
    check value == @[1, 3, 6, 10, 15]

  test "suffixSum: compute suffix sums":
    let arr = @[1, 2, 3, 4, 5]
    let value = suffixSum(arr)
    check value == @[15, 14, 12, 9, 5]

  test "pairwiseDifferences: consecutive differences":
    let arr = @[1, 4, 2, 7, 5]
    let value = pairwiseDifferences(arr)
    check value == @[3, -2, 5, -2]

suite "Fast Search":
  test "binarySearchFirst: find first occurrence":
    let arr = @[1, 2, 2, 2, 3, 4, 5]
    check binarySearchFirst(arr, 2) == 1
    check binarySearchFirst(arr, 3) == 4
    check binarySearchFirst(arr, 6) == -1

  test "binarySearchLE: largest <= target":
    let arr = @[1, 3, 5, 7, 9]
    check binarySearchLE(arr, 6) == 2 # 5 is at index 2
    check binarySearchLE(arr, 10) == 4 # 9 is at index 4

  test "binarySearchGE: smallest >= target":
    let arr = @[1, 3, 5, 7, 9]
    check binarySearchGE(arr, 6) == 3 # 7 is at index 3
    check binarySearchGE(arr, 0) == 0 # 1 is at index 0

suite "Range Operations":
  test "Range: create and use":
    let r: Range = (5, 10)
    check contains(r, 7) == true
    check contains(r, 3) == false

  test "overlap: check range overlap":
    let r1: Range = (1, 5)
    let r2: Range = (3, 8)
    check overlap(r1, r2) == true

  test "intersection: find common range":
    let r1: Range = (1, 5)
    let r2: Range = (3, 8)
    let value = intersection(r1, r2)
    check value == (3, 5)

  test "mergeRanges: coalesce overlapping":
    let ranges = @[(1, 3), (2, 5), (7, 9)]
    let value = mergeRanges(ranges)
    check value.len == 2
    check value[0] == (1, 5)
    check value[1] == (7, 9)
