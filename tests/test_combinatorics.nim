# Combinatorics Utility Tests
# Tests for combinations, permutations, and mathematical combinatorics

import unittest
import ../aoc/aoc_utils

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
    check perms.len == 6  # 3!
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
    check countPermutations(5, 2) == 20  # 5 * 4
    check countPermutations(5, 3) == 60  # 5 * 4 * 3
    check countPermutations(5, 0) == 1
