import aoc_utils

proc max_joltage(battery_ints: seq[int]): (int, int) =
  const on_size = 12
  const small_on_size = 2

  var removals = battery_ints.len - on_size
  var stack: array[100, int] #preallocate 100 slots
  var stack_ptr = 0

  for d in battery_ints:
    while removals > 0 and stack_ptr > 0 and stack[stack_ptr-1] < d:
      dec stack_ptr
      dec removals
    stack[stack_ptr] = d
    inc stack_ptr

  # use 1 stack for both
  var part1 = 0
  var part2 = 0
  for i in 0 ..< on_size:
    if i < small_on_size:
      part1 = part1 * 10 + stack[i]
    part2 = part2 * 10 + stack[i]

  result = (part1, part2)

proc day_03*(): Solution =
  var part1 = 0
  var part2 = 0

  for bank in getInput().lineInts():
    let (p1, p2) = max_joltage(bank)
    part1 += p1
    part2 += p2

  result = Solution(part_one: $part1, part_two: $part2)
