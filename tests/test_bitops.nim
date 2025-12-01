# Bit Operations Utility Tests
# Tests for bit manipulation, lookup tables, and performance bit functions

import unittest
import ../aoc/aoc_utils

suite "Lookup Tables":
  test "digitSumLUT: O(1) digit sum":
    check digitSumLUT(123) == 6
    check digitSumLUT(500) == 5
    check digitSumLUT(0) == 0
  
  test "popcountLUT: O(1) bit counting":
    check popcountLUT(0b1010) == 2
    check popcountLUT(0b1111) == 4
  
  test "isDigitLUT: fast digit check":
    check isDigitLUT('5') == true
    check isDigitLUT('A') == false
  
  test "isAlphaLUT: fast alpha check":
    check isAlphaLUT('A') == true
    check isAlphaLUT('5') == false

suite "Basic Bit Manipulation":
  test "popcount: count set bits":
    check popcount(0b1010) == 2
    check popcount(0b1111) == 4
    check popcount(0) == 0
  
  test "hasBit: check if bit is set":
    let x = 0b1010
    check hasBit(x, 1) == true
    check hasBit(x, 0) == false
    check hasBit(x, 3) == true
  
  test "setBit: set a bit":
    var x = 0b1010
    let result = setBit(x, 0)
    check result == 0b1011
  
  test "clearBit: clear a bit":
    let x = 0b1010
    let result = clearBit(x, 1)
    check result == 0b1000
  
  test "toggleBit: flip a bit":
    let x = 0b1010
    let result = toggleBit(x, 0)
    check result == 0b1011

suite "Bit Mathematics":
  test "isEven: check if even":
    check isEven(4) == true
    check isEven(7) == false
  
  test "isOdd: check if odd":
    check isOdd(7) == true
    check isOdd(4) == false
  
  test "isPowerOf2: check if power of 2":
    check isPowerOf2(1) == true
    check isPowerOf2(2) == true
    check isPowerOf2(4) == true
    check isPowerOf2(3) == false
    check isPowerOf2(5) == false
  
  test "roundUpToPowerOf2: round to power of 2":
    check roundUpToPowerOf2(5) == 8
    check roundUpToPowerOf2(8) == 8
    check roundUpToPowerOf2(9) == 16
  
  test "lowestBitSet: find lowest set bit":
    check lowestBitSet(0b1000) == 3
    check lowestBitSet(0b0100) == 2
  
  test "highestBitSet: find highest set bit":
    check highestBitSet(0b1000) == 3
    check highestBitSet(0b1010) == 3
  
  test "divideRoundUp: integer division rounding up":
    check divideRoundUp(5, 2) == 3  # (5 + 2 - 1) / 2 = 6 / 2 = 3
    check divideRoundUp(4, 2) == 2  # (4 + 2 - 1) / 2 = 5 / 2 = 2
  
  test "modAbsolute: positive modulo":
    check modAbsolute(-1, 5) == 4
    check modAbsolute(7, 5) == 2

suite "Bit Packing":
  test "BitPacked8: pack and unpack booleans":
    var packed = initBitPacked8()
    setBit8(packed, 0, true)
    setBit8(packed, 2, true)
    setBit8(packed, 4, true)
    
    check getBit8(packed, 0) == true
    check getBit8(packed, 1) == false
    check getBit8(packed, 2) == true
    check getBit8(packed, 3) == false
    check getBit8(packed, 4) == true
    check getBit8(packed, 5) == false

echo "Bit operations utility tests completed!"
