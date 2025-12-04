# Math Utility Tests
# Tests for mathematical utilities and number theory functions

import unittest
import ../aoc/aoc_utils

suite "Basic Number Theory":
  test "gcd: greatest common divisor":
    check gcd(48, 18) == 6
    check gcd(17, 19) == 1
    check gcd(100, 50) == 50

  test "lcm: least common multiple":
    check lcm(12, 18) == 36
    check lcm(7, 5) == 35

  test "gcdSeq: gcd of sequence":
    check gcdSeq(@[12, 18, 24]) == 6

  test "lcmSeq: lcm of sequence":
    check lcmSeq(@[4, 6, 8]) == 24

suite "Modular Arithmetic":
  test "powMod: modular exponentiation":
    check powMod(2, 10, 1000) == 24 # 2^10 mod 1000
    check powMod(3, 4, 5) == 1 # 3^4 mod 5 = 81 mod 5 = 1

  test "modAdd: modular addition":
    check modAdd(5, 8, 7) == 6 # (5 + 8) mod 7 = 13 mod 7 = 6

  test "modSub: modular subtraction":
    check modSub(5, 8, 7) == 4 # (5 - 8) mod 7 = -3 mod 7 = 4

  test "modMul: modular multiplication":
    check modMul(5, 8, 7) == 5 # (5 * 8) mod 7 = 40 mod 7 = 5

suite "Prime Numbers":
  test "isPrimeFast: primality test":
    check isPrimeFast(2) == true
    check isPrimeFast(3) == true
    check isPrimeFast(4) == false
    check isPrimeFast(17) == true
    check isPrimeFast(20) == false

  test "smallestPrimeFactor: find smallest factor":
    check smallestPrimeFactor(12) == 2
    check smallestPrimeFactor(17) == 17
    check smallestPrimeFactor(25) == 5

  test "primeFactorization: factorize number":
    let factors = primeFactorization(12)
    check factors.contains(2)
    check factors.contains(3)

suite "Digit Operations":
  test "digitSum: sum of digits":
    check digitSum(123) == 6
    check digitSum(999) == 27

  test "digitCount: count digits":
    check digitCount(123) == 3
    check digitCount(1) == 1

  test "reverseNumber: reverse digits":
    check reverseNumber(123) == 321
    check reverseNumber(100) == 1

  test "isPalindromeNumber: check palindrome":
    check isPalindromeNumber(121) == true
    check isPalindromeNumber(123) == false

# Note: Factorial tests are now in test_combinatorics.nim
# since factorial functions were moved to combinatorics module for better organization
