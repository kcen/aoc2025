import aoc_utils
import std/strutils, std/sequtils

proc day_05*(): Solution =
  let input = getInput().parseSections()
  let fresh_ranges = input[0].map(parseRange).mergeRanges()
  let ingredients = input[1].map(parseInt)
  var pt1 = 0
  var pt2 = 0

  for r in fresh_ranges:
    for i in ingredients:
      if r.contains(i):
        pt1.inc
    pt2 += r.ending - r.start + 1
  result = Solution(part_one: $pt1, part_two: $pt2)
