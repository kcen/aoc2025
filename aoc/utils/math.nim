# Mathematical Utilities for AOC
# Number theory, modular arithmetic, and mathematical operations

import std/[sequtils]

# ============================================================================
# BASIC NUMBER THEORY
# ============================================================================

proc gcd*(a, b: int): int =
  ## Greatest common divisor using Euclidean algorithm
  if b == 0: abs(a) else: gcd(b, a mod b)

proc lcm*(a, b: int): int =
  ## Least common multiple
  abs(a * b) div gcd(a, b)

proc gcdSeq*(nums: seq[int]): int =
  ## GCD of sequence
  if nums.len == 0: 0
  else: nums.foldl(gcd(a, b))

proc lcmSeq*(nums: seq[int]): int =
  ## LCM of sequence
  if nums.len == 0: 1
  else: nums.foldl(lcm(a, b))

proc gcdBinary*(a, b: int): int =
  ## Binary GCD (Stein's algorithm) - faster than Euclidean on some CPUs
  var u = abs(a)
  var v = abs(b)

  if u == 0: return v
  if v == 0: return u

  var shift = 0
  while ((u or v) and 1) == 0:
    u = u shr 1
    v = v shr 1
    shift.inc

  while (u and 1) == 0:
    u = u shr 1

  while v > 0:
    while (v and 1) == 0:
      v = v shr 1

    if u > v:
      swap(u, v)

    v = v - u

  u shl shift

# ============================================================================
# POWER OF 10 LOOKUP TABLE
# ============================================================================

const POW10_LUT*: array[19, int] = [
  1,                         # 10^0
  10,                        # 10^1
  100,                       # 10^2
  1_000,                     # 10^3
  10_000,                    # 10^4
  100_000,                   # 10^5
  1_000_000,                 # 10^6
  10_000_000,                # 10^7
  100_000_000,               # 10^8
  1_000_000_000,             # 10^9
  10_000_000_000,            # 10^10
  100_000_000_000,           # 10^11
  1_000_000_000_000,         # 10^12
  10_000_000_000_000,        # 10^13
  100_000_000_000_000,       # 10^14
  1_000_000_000_000_000,     # 10^15
  10_000_000_000_000_000,    # 10^16
  100_000_000_000_000_000,   # 10^17
  1_000_000_000_000_000_000, # 10^18
]

proc pow10*(n: int): int {.inline, noSideEffect.} =
  ## Fast power of 10 using lookup table (n must be 0..18)
  POW10_LUT[n]

# ============================================================================
# MODULAR ARITHMETIC
# ============================================================================

const MOD* = 1_000_000_007

proc powMod*(base, exp, modulus: int): int =
  ## Modular exponentiation
  var total = 1
  var b = base mod modulus
  var e = exp
  while e > 0:
    if e mod 2 == 1:
      total = (total * b) mod modulus
    e = e shr 1
    b = (b * b) mod modulus
  return total

proc modInverse*(a, m: int): int =
  ## Modular inverse using extended Euclidean algorithm
  var m0 = m
  var x0 = 0
  var x1 = 1
  var a = a
  var m = m # Make m mutable

  if m == 1: return 0

  while a > 1:
    let q = a div m
    let t = m

    m = a mod m
    a = t
    let t0 = x0

    x0 = x1 - q * x0
    x1 = t0

  if x1 < 0:
    x1 + m0
  else:
    x1

proc modAdd*(a, b, m: int): int =
  ((a mod m) + (b mod m)) mod m

proc modSub*(a, b, m: int): int =
  ((a mod m) - (b mod m) + m) mod m

proc modMul*(a, b, m: int): int =
  ((a mod m) * (b mod m)) mod m

proc modPowFast*(base, exp, modulus: int): int =
  ## Fast modular exponentiation (bit-by-bit)
  var total = 1
  var b = base mod modulus
  var e = exp
  while e > 0:
    if (e and 1) != 0:
      total = (total * b) mod modulus
    b = (b * b) mod modulus
    e = e shr 1
  total

proc chineseRemainder*(remainders, moduli: seq[int]): int =
  ## Chinese Remainder Theorem solver
  var total = 0
  let M = moduli.foldl(a * b, 1)

  for i in 0..<remainders.len:
    let Mi = M div moduli[i]
    total += remainders[i] * Mi * modInverse(Mi, moduli[i])

  total mod M

# ============================================================================
# PRIME NUMBERS
# ============================================================================

proc isPrimeFast*(n: int): bool =
  ## Fast primality test (wheel factorization)
  if n < 2: return false
  if n == 2: return true
  if (n and 1) == 0: return false
  if n == 3: return true
  if n mod 3 == 0: return false

  var i = 5
  while i * i <= n:
    if n mod i == 0 or n mod (i + 2) == 0:
      return false
    i += 6
  true

proc smallestPrimeFactor*(n: int): int =
  ## Find smallest prime factor (for factorization)
  if n mod 2 == 0: return 2
  var i = 3
  while i * i <= n:
    if n mod i == 0:
      return i
    i += 2
  n

proc primeFactorization*(n: int): seq[int] =
  ## Get prime factorization as sequence of prime factors
  var num = n
  var factors: seq[int] = @[]
  var i = 2
  while i * i <= num:
    while num mod i == 0:
      factors.add(i)
      num = num div i
    i.inc
  if num > 1:
    factors.add(num)
  factors

# ============================================================================
# SEQUENCES AND SERIES
# ============================================================================

proc fibonacciFast*(n: int): int =
  ## Fast Fibonacci using matrix exponentiation
  if n <= 1: return n

  var a = 1
  var b = 0
  var exp = n
  var x = 0
  var y = 1

  while exp > 0:
    if (exp and 1) != 0:
      x = a * x + b * y
      y = b * x + (a - b) * y

    let tmp_a = a
    a = a * a + b * b
    b = 2 * tmp_a * b + b * b

    exp = exp shr 1

  x

proc tribonacciFast*(n: int): int =
  ## Fast Tribonacci (T(n) = T(n-1) + T(n-2) + T(n-3))
  if n == 0: return 0
  if n == 1 or n == 2: return 1

  var a, b, c = 1
  for i in 3..n:
    let next = a + b + c
    a = b
    b = c
    c = next

  c

# ============================================================================
# DIGIT OPERATIONS
# ============================================================================

proc digitSum*(n: int): int =
  ## Sum of digits
  var sum = 0
  var num = abs(n)
  while num > 0:
    sum += num mod 10
    num = num div 10
  result = sum

proc digitProduct*(n: int): int =
  ## Product of digits
  var prod = 1
  var num = abs(n)
  while num > 0:
    prod *= num mod 10
    num = num div 10
  result = prod

proc digitCount*(n: int): int =
  ## Count number of digits
  if n == 0: return 1
  var count = 0
  var num = abs(n)
  while num > 0:
    count.inc
    num = num div 10
  result = count

proc reverseNumber*(n: int): int =
  ## Reverse digits of number
  var rev = 0
  var num = abs(n)
  while num > 0:
    rev = rev * 10 + (num mod 10)
    num = num div 10
  result = if n < 0: -rev else: rev

proc isPalindromeNumber*(n: int): bool =
  n == reverseNumber(n)
