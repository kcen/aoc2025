import aoc_utils
import std/parseutils

proc max_joltage(battery_chars: seq[char], on_size: int): int =
  var joltage: seq[char] = @[]
  var min_index = 0

  let size_max = battery_chars.len - 1
  let size_index = on_size - 1
  let start_index = size_max - size_index

  for digit_pos in 0..size_index:
    var largest = '0'
    var index_pos = 0
    let max_index = (start_index + digit_pos)
    for i in min_index..max_index:
      if battery_chars[i].ord > largest.ord:
        largest = battery_chars[i]
        index_pos = i
    min_index = index_pos + 1
    joltage.add(largest)
  discard joltage.parseInt(result)

proc day_03*(): Solution =
  var part1 = 0
  var part2 = 0

  for bank in getInput().lineChars():
    part1 += max_joltage(bank, 2)
    part2 += max_joltage(bank, 12)

  result = Solution(part_one: $part1, part_two: $part2)
