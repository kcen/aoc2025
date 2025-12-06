import aoc_utils
import std/sequtils, std/strutils, std/math

proc day_06*(): Solution =
  var lines = getInput(false).split('\n').filterIt(not it.isEmptyOrWhitespace)
  let operators_line = lines.pop
  let numerators = lines.mapIt(it.parseInts)
  let rows = lines.mapIt(it.toSeq)
  let operators = operators_line.filterIt(not(it in Whitespace))

  var pt1 = 0
  for idx in 0..<operators.len:
    let nums = numerators.mapIt(it[idx])
    if operators[idx] == '+':
      pt1 += nums.sum
    else:
      pt1 += nums.prod

  var pt2 = 0
  var current_nums: seq[int] = @[]
  for idx in countdown(operators_line.high, 0):
    let col_str = rows.mapIt($it[idx]).join("").strip
    if col_str != "":
      current_nums.add(col_str.parseInt)
    case operators_line[idx]:
      of '+':
        pt2 += current_nums.sum
        current_nums.setLen(0)
      of '*':
        pt2 += current_nums.prod
        current_nums.setLen(0)
      else:
        continue

  result = Solution(part_one: $pt1, part_two: $pt2)
