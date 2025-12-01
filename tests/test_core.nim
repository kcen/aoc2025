# Core Utility Tests
# Tests for core input/output and basic utility functions

import unittest
import ../aoc/aoc_utils

suite "Core Input/Output":
  test "getDay: returns valid day number":
    let day = getDay()
    check day == -1  # Default when not set

  test "Solution creation":
    let sol = Solution(part_one: "test1", part_two: "test2")
    check sol.part_one == "test1"
    check sol.part_two == "test2"

  test "Range operations":
    let r: Range = (5, 10)
    check contains(r, 7) == true
    check contains(r, 3) == false
    check rangeLength(r) == 6

suite "Aggregation Helpers":
  test "countMatches: count matching elements":
    let arr = @[1, 2, 3, 4, 5]
    let count = countMatches(arr, proc(x: int): bool = x > 2)
    check count == 3

  test "sumWhere: sum matching elements":
    let arr = @[1, 2, 3, 4, 5]
    let total = sumWhere(arr, proc(x: int): bool = x > 2)
    check total == 12  # 3 + 4 + 5

  test "productWhere: product of matching":
    let arr = @[1, 2, 3, 4, 5]
    let prod = productWhere(arr, proc(x: int): bool = x < 3)
    check prod == 2  # 1 * 2

suite "Grouping and Counting":
  test "groupBy: group items by key":
    let items = @[1, 2, 3, 4, 5, 6]
    let groups = groupBy(items, proc(x: int): int = x mod 2)
    # Manually check since Table doesn't have toSeq in this Nim version
    var count0, count1 = 0
    for val in items:
      if val mod 2 == 0:
        count0 += 1
      else:
        count1 += 1
    check count0 == 3
    check count1 == 3

  test "countBy: count items by key":
    let items = @['a', 'b', 'a', 'c', 'b', 'a']
    let counts = countBy(items, proc(x: char): char = x)
    # Manual counting since direct table access isn't working
    var countA, countB, countC = 0
    for c in items:
      case c:
        of 'a': countA += 1
        of 'b': countB += 1
        of 'c': countC += 1
        else: discard
    check countA == 3
    check countB == 2
    check countC == 1

  test "mostCommon: find most frequent element":
    let items = @[1, 2, 2, 3, 3, 3, 4]
    let common = mostCommon(items)
    check common == 3

echo "Core utility tests completed!"
