import aoc_utils
import std/[math, sets]

proc day_02*(): Solution =
  var part_one = 0
  var part_two = 0
  var part_one_set: HashSet[int]
  var part_two_set: HashSet[int]

  for r_str in getInput().parseTokens(','):
    let parts = r_str.parseInts('-')
    let r: Range = (parts[0], parts[1])
    let minDigits = digitCount(r.start)
    let maxDigits = digitCount(r.ending)

    # Generate repeats
    for numDigits in minDigits..maxDigits:
      # pattern_len = k
      for k in 1..(numDigits div 2):
        if numDigits mod k != 0: continue

        # multiplier for repeating pattern
        var multiplier = 0
        let reps = numDigits div k
        for j in 0..<reps:
          multiplier += 10 ^ (j * k)

        # let minPattern = ceil(r.start / multiplier)
        # let maxPattern = floor(r.ending / multiplier)
        let minPattern = max(10 ^ (k - 1),
          (r.start + multiplier - 1) div multiplier)
        let maxPattern = min((10 ^ k) - 1, r.ending div multiplier)

        if minPattern <= maxPattern:
          for pattern in minPattern..maxPattern:
            let num = pattern * multiplier
            if r.contains(num):
              # All repeating patterns go to part_two_set
              if not part_two_set.containsOrIncl(num):
                part_two += num
              # ABAB patterns (k = half of digits) also go to part_one
              if (k == numDigits div 2) and (numDigits mod 2 == 0):
                if not part_one_set.containsOrIncl(num):
                  part_one += num

  Solution(part_one: $part_one, part_two: $part_two)
