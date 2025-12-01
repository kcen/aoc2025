# Bit Manipulation Utilities for AOC
# High-performance bit operations, look-up tables, and SIMD-friendly functions

import std/strutils

# ============================================================================
# LOOKUP TABLES FOR PERFORMANCE
# ============================================================================

# Pre-computed digit sum table for fast digit operations
const DIGIT_SUM_LUT*: array[1000, uint8] = block:
  var lut: array[1000, uint8]
  for i in 0..<1000:
    var s = 0u8
    var n = i
    while n > 0:
      s += uint8(n mod 10)
      n = n div 10
    lut[i] = s
  lut

# Hamming weight (popcount) LUT
const POPCOUNT_LUT*: array[256, uint8] = block:
  var lut: array[256, uint8]
  for i in 0..<256:
    var count = 0u8
    var n = i
    while n > 0:
      count += uint8(n and 1)
      n = n shr 1
    lut[i] = count
  lut

# ASCII character classification LUT
const CHAR_CLASS_LUT*: array[256, uint8] = block:
  var lut: array[256, uint8]
  for i in 0..<256:
    let c = chr(i)
    var flags = 0u8
    if c.isDigit(): flags = flags or 0x01
    if c.isAlphaAscii(): flags = flags or 0x02
    if c.isAlphaNumeric(): flags = flags or 0x04
    if c.isSpaceAscii(): flags = flags or 0x08
    if c.isUpperAscii(): flags = flags or 0x10
    if c.isLowerAscii(): flags = flags or 0x20
    lut[i] = flags
  lut

# ============================================================================
# BIT OPERATION CONSTANTS
# ============================================================================

const
  CHAR_IS_DIGIT* = 0x01u8
  CHAR_IS_ALPHA* = 0x02u8
  CHAR_IS_ALPHANUMERIC* = 0x04u8
  CHAR_IS_SPACE* = 0x08u8
  CHAR_IS_UPPER* = 0x10u8
  CHAR_IS_LOWER* = 0x20u8

# ============================================================================
# LOOKUP TABLE BASED OPERATIONS
# ============================================================================

proc digitSumLUT*(n: int): int =
  ## O(1) digit sum using LUT (for n in [0, 999])
  if n < 0:
    digitSumLUT(-n)
  elif n < 1000:
    int(DIGIT_SUM_LUT[n])
  else:
    # Fallback: sum digit ranges
    let a = n div 1000
    let b = n mod 1000
    digitSumLUT(a) + int(DIGIT_SUM_LUT[b])

proc popcountLUT*(x: int): int =
  ## O(1) popcount using LUT (for byte-at-a-time)
  if x == 0: return 0
  var count = 0
  var n = x
  while n > 0:
    count += int(POPCOUNT_LUT[n and 0xFF])
    n = n shr 8
  result = count

proc isDigitLUT*(c: char): bool =
  (CHAR_CLASS_LUT[ord(c)] and CHAR_IS_DIGIT) != 0

proc isAlphaLUT*(c: char): bool =
  (CHAR_CLASS_LUT[ord(c)] and CHAR_IS_ALPHA) != 0

# ============================================================================
# BASIC BIT MANIPULATION
# ============================================================================

proc popcount*(x: int): int =
  ## Count set bits (use builtin if available: countSetBits(x))
  var n = x
  var count = 0
  while n > 0:
    count += n and 1
    n = n shr 1
  count

proc hasBit*(x: int, bit: int): bool =
  (x and (1 shl bit)) != 0

proc setBit*(x: int, bit: int): int =
  x or (1 shl bit)

proc clearBit*(x: int, bit: int): int =
  x and (not (1 shl bit))

proc toggleBit*(x: int, bit: int): int =
  x xor (1 shl bit)

proc setBits*(x: int, start, count: int): int =
  ## Set count bits starting at position start
  var mask = 0
  for i in 0..<count:
    mask = setBit(mask, start + i)
  x or mask

# ============================================================================
# BIT MATHEMATICS
# ============================================================================

proc isEven*(x: int): bool =
  (x and 1) == 0

proc isOdd*(x: int): bool =
  (x and 1) != 0

proc isPowerOf2*(x: int): bool =
  x > 0 and (x and (x - 1)) == 0

proc roundUpToPowerOf2*(x: int): int =
  ## Round up to next power of 2
  var n = x - 1
  n = n or (n shr 1)
  n = n or (n shr 2)
  n = n or (n shr 4)
  n = n or (n shr 8)
  n = n or (n shr 16)
  n + 1

proc lowestBitSet*(x: int): int =
  ## Get position of lowest set bit
  if x == 0: return -1
  var pos = 0
  var n = x
  while (n and 1) == 0:
    pos.inc
    n = n shr 1
  pos

proc highestBitSet*(x: int): int =
  ## Get position of highest set bit
  if x == 0: return -1
  var pos = 0
  var n = x
  while n > 0:
    pos.inc
    n = n shr 1
  pos - 1

proc divideRoundUp*(a, b: int): int =
  ## Integer division rounding up: (a + b - 1) / b
  (a + b - 1) div b

proc modAbsolute*(x, m: int): int =
  ## Modulo that always returns positive (0 to m-1)
  ((x mod m) + m) mod m

# ============================================================================
# BIT PACKING UTILITIES
# ============================================================================

type
  BitPacked8*[T] = distinct uint64 ## 8 packed boolean/T values in one u64
  BitPacked4*[T] = distinct uint32 ## 4 packed values in one u32

proc initBitPacked8*(): BitPacked8[bool] =
  result = BitPacked8[bool](0u64)

proc initBitPacked4*(): BitPacked4[bool] =
  result = BitPacked4[bool](0u32)

proc setBit8*[T](packed: var BitPacked8[T], idx: int, val: bool) =
  ## Set boolean at index (0-7)
  if val:
    packed = BitPacked8[T](uint64(packed) or (1u64 shl idx))
  else:
    packed = BitPacked8[T](uint64(packed) and (not (1u64 shl idx)))

proc getBit8*[T](packed: BitPacked8[T], idx: int): bool =
  (uint64(packed) and (1u64 shl idx)) != 0

proc countSetBits8*[T](packed: BitPacked8[T]): int =
  popcountLUT(int(uint64(packed)))
