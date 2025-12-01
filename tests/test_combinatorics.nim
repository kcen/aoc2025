# Combinatorics Utility Tests
# Tests for combinations, permutations, and mathematical combinatorics

import unittest
import ../aoc/aoc_utils
import std/tables

suite "Basic Combinatorics":
  test "combinations: 3 choose 2":
    let combos = combinations(@[1, 2, 3], 2)
    check combos.len == 3
    check @[1, 2] in combos
    check @[1, 3] in combos
    check @[2, 3] in combos

  test "combinations: edge case r=0":
    let combos = combinations(@[1, 2, 3], 0)
    check combos.len == 1
    check combos[0].len == 0

  test "permutations: all arrangements":
    let perms = permutations(@[1, 2, 3])
    check perms.len == 6 # 3!
    check @[1, 2, 3] in perms
    check @[3, 2, 1] in perms

  test "product: cartesian product":
    let prod = product(@[@[1, 2], @[3, 4]])
    check prod.len == 4
    check @[1, 3] in prod
    check @[2, 4] in prod

suite "Combinatorics Helpers":
  test "countCombinations: nCr counts":
    check countCombinations(5, 2) == 10
    check countCombinations(5, 3) == 10
    check countCombinations(5, 0) == 1

  test "countPermutations: nPr counts":
    check countPermutations(5, 2) == 20 # 5 * 4
    check countPermutations(5, 3) == 60 # 5 * 4 * 3
    check countPermutations(5, 0) == 1

suite "Precomputed Factorials (High-Performance)":
  test "initFastFactorials and nCrFast":
    initFastFactorials(10)
    check nCrFast(5, 2) == 10
    check nCrFast(6, 3) == 20
    check nCrFast(10, 5) == 252

  test "nCrFast: fast combination":
    initFastFactorials(20)
    check nCrFast(0, 0) == 1
    check nCrFast(1, 0) == 1
    check nCrFast(1, 1) == 1
    check nCrFast(10, 5) == 252

  test "nPrFast: fast permutation":
    initFastFactorials(10)
    check nPrFast(5, 2) == 20 # 5 * 4
    check nPrFast(5, 5) == 120 # 5!
    check nPrFast(10, 3) == 720 # 10 * 9 * 8

  test "ensureFactorials: progressive computation":
    ensureFactorials(15)
    ensureInvFactorials(15)
    check nCrFast(15, 7) == 6435
    check nPrFast(8, 4) == 1680

suite "Memoization Support":
  test "combinationsMemoized: memoized combination count":
    var memo = initTable[(int, int), int]()
    let result = combinationsMemoized(@[1, 2, 3, 4, 5], 3, memo)
    check result == 10 # C(5,3) = 10
    check memo.len > 0 # Cache should be populated

echo "Combinatorics utility tests completed!"
