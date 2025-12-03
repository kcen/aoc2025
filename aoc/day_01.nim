import aoc_utils

proc wrapPosition(pos: int): int {.inline, noSideEffect.} =
  let wrapped = pos mod 100
  if wrapped < 0: wrapped + 100 else: wrapped

proc countSweeps(start_pos: int, turn: int): int {.inline, noSideEffect.} =
  # Calculate how many times the dial wraps around (touches 0)
  if turn < 0:
    let wrap_distance = 100 - start_pos - turn
    result = wrap_distance div 100
    if start_pos == 0:
      dec result
  else:
    result = (start_pos + turn) div 100

proc day_01*(): Solution =
  var pos = 50
  var sweeps = 0
  var at_zero = 0

  var current_num = 0
  var is_negative = false

  template processTurn() =
    if current_num != 0:
      let turn = if is_negative: -current_num else: current_num
      sweeps += countSweeps(pos, turn)
      pos = wrapPosition(pos + turn)
      if pos == 0:
        inc at_zero

  for c in getInput():
    case c:
      of 'L':
        is_negative = true
      of 'R':
        is_negative = false
      of '0'..'9':
        current_num = current_num * 10 + (ord(c) - ord('0'))
      else:
        processTurn()
        current_num = 0

  # Handle final number if present
  processTurn()

  Solution(part_one: $at_zero, part_two: $sweeps)
