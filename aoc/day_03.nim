import aoc_utils
import std/strutils

proc max_joltage(battery_chars: seq[char], on_size: int): int =
  var removals = battery_chars.len - on_size
  var stack: seq[char] = @[]

  for digit in battery_chars:
    while removals > 0 and stack.len > 0 and stack[^1].ord < digit.ord:
      discard stack.pop()
      removals -= 1
    stack.add digit
  result = stack[0..(on_size-1)].join().parseInt()

proc day_03*(): Solution =
  var part1 = 0
  var part2 = 0

  for bank in getInput().lineChars():
    part1 += max_joltage(bank, 2)
    part2 += max_joltage(bank, 12)

  result = Solution(part_one: $part1, part_two: $part2)
