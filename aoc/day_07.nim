import aoc_utils
import std/math

proc day_07*(): Solution =
  let input = getInput().lineChars()
  let width = input[0].len
  var splits = newSeq[int](width)
  splits[input[0].find('S')] = 1

  var count = 0
  for line in input[1..input.high]:
    for col, c in line:
      if c == '^' and splits[col] != 0:
        let beams = splits[col]
        splits[col + 1].inc(beams)
        splits[col - 1].inc(beams)
        splits[col] = 0
        count += 1

  result = Solution(part_one: $count, part_two: $splits.sum)
