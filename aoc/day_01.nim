import aoc_utils

proc comboInputs*(s: string): seq[int] =
  var numbers: seq[int] = @[]
  var currentNum = 0
  var isNegative = false

  for c in s:
    case c:
      of 'L':
        isNegative = true
      of 'R':
        isNegative = false
      of {'0'..'9'}:
        currentNum = currentNum * 10 + (int(c) - int('0'))
      else:
        if currentNum != 0:
          numbers.add(if isNegative: -currentNum else: currentNum)
          currentNum = 0

  if currentNum != 0:
    numbers.add(if isNegative: -currentNum else: currentNum)

  result = numbers

proc wrapPosition*(pos: int): int =
  result = pos mod 100
  if result < 0:
    result += 100

proc countSweeps*(startPos: int, turn: int): int =
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

  for turn in getInput().comboInputs():
    sweeps += countSweeps(pos, turn)
    pos = wrapPosition(pos + turn)

    if pos == 0:
      at_zero += 1

  Solution(part_one: $at_zero, part_two: $sweeps)
