import aoc_utils
import std/[sets]

#maximum number of digits a range value can have (base 10)
const MaxDigits = 16
#maximum pattern length we can make under ^
const MaxK = 8

# multiplies a k-digit pattern to create a d-digit repeating number (e.g., 12 * 101 = 1212)
proc multiplierLookupTable(): array[MaxDigits, array[MaxK, int]] {.compileTime.} =
  var res: array[MaxDigits, array[MaxK, int]]
  for d in 0 ..< MaxDigits:
    for k in 0 ..< MaxK:
      var v = 0 #0 for no pattern
      if k != 0 and d mod k == 0:
        for j in 0 ..< (d div k):
          v += (j * k).pow10
      res[d][k] = v
  res
const MULTIPLIER_LUT: array[MaxDigits, array[MaxK, int]] = multiplierLookupTable()

proc day_02*(): Solution =
  var part_one = 0
  var part_two = 0
  var seen: HashSet[int]

  for r_str in getInput().parseTokens(','):
    let parts = r_str.parseInts('-')
    let r: Range = (parts[0], parts[1])
    let minDigits = digitCount(r.start)
    let maxDigits = digitCount(r.ending)

    # Generate repeats
    for numDigits in minDigits..maxDigits:
      # pattern_len = k
      for k in 1..(numDigits div 2):
        # multiplier for repeating pattern
        var multiplier = MULTIPLIER_LUT[numDigits][k]
        if multiplier == 0: continue

        let minPattern = max((k - 1).pow10, (r.start + multiplier -
            1) div multiplier)
        let maxPattern = min(k.pow10 - 1, r.ending div multiplier)

        if minPattern <= maxPattern:
          for pattern in minPattern..maxPattern:
            let num = pattern * multiplier
            if r.contains(num):
              # ABAB patterns (k = half of digits) also go to part_one
              if k * 2 == numDigits:
                part_one += num
              if not seen.containsOrIncl(num):
                part_two += num

  Solution(part_one: $part_one, part_two: $part_two)
