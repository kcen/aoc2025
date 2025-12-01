import aoc_utils

proc wrapPosition(pos: int): int {.inline, noSideEffect.} =
  let wrapped = pos mod 100
  if wrapped < 0: wrapped + 100 else: wrapped

proc countSweeps(startPos: int, turn: int): int {.inline, noSideEffect.} =
  # Calculate how many times the dial wraps around (touches 0)
  if turn < 0:
    let wrapDistance = 100 - startPos - turn
    result = wrapDistance div 100
    if startPos == 0:
      result -= 1
  else:
    result = (startPos + turn) div 100

proc day_01*(): Solution =
  var pos = 50
  var sweeps = 0
  var at_zero = 0

  var currentNum = 0
  var isNegative = false

  for c in getInput():
    case c:
      of 'L':
        isNegative = true
      of 'R':
        isNegative = false
      of '0'..'9':
        currentNum = currentNum * 10 + (int(c) - int('0'))
      else:
        if currentNum != 0:
          let turn = if isNegative: -currentNum else: currentNum
          sweeps += countSweeps(pos, turn)
          pos = wrapPosition(pos + turn)
          if pos == 0:
            at_zero += 1
          currentNum = 0

  # Handle final number if present
  if currentNum != 0:
    let turn = if isNegative: -currentNum else: currentNum
    sweeps += countSweeps(pos, turn)
    pos = wrapPosition(pos + turn)
    if pos == 0:
      at_zero += 1

  Solution(part_one: $at_zero, part_two: $sweeps)
