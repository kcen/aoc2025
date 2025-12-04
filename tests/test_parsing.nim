# Parsing Utility Tests
# Tests for string parsing and extraction functions

import unittest
import ../aoc/aoc_utils
import ../aoc/utils/parsing

suite "Basic Parsing Functions":
  test "parseLines: splits by newline and strips whitespace":
    let input = "  hello\n  world  \n  test  "
    let value = parseLines(input)
    check value == @["hello", "world", "test"]

  test "parseTokens: splits tokens with custom separator":
    let value = parseTokens("hello,world,test", ',')
    check value == @["hello", "world", "test"]

  test "parseInts: extracts all integers from string":
    let value = parseInts("10 20 30 40")
    check value == @[10, 20, 30, 40]

  test "parseInts: handles negative numbers":
    let value = parseInts("1 -5 3 -10")
    check value == @[1, -5, 3, -10]

  test "parseInts: works with different separators":
    let value = parseInts("10,20,30", ',')
    check value == @[10, 20, 30]

  test "parseSections: handles blank line separation":
    let input = "line1\nline2\n\nsection2\nline3"
    let value = parseSections(input)
    check value.len == 2
    check value[0] == @["line1", "line2"]
    check value[1] == @["section2", "line3"]

  test "parseChars: converts string to char sequence":
    let value = parseChars("ABC")
    check value == @['A', 'B', 'C']

  test "lineChars: converts multiline to char grid":
    let value = lineChars("AB\nCD")
    check value.len == 2
    check value[0] == @['A', 'B']
    check value[1] == @['C', 'D']

  test "extractInts: extracts integers from complex string":
    let value = extractInts("x=10, y=-20, z=30")
    check value == @[10, -20, 30]

  test "extractInts: handles negative numbers in context":
    let value = extractInts("temp=-5, count=10, delta=-3")
    check value == @[-5, 10, -3]

  test "countOccurrences: count substring occurrences":
    let value = countOccurrences("ababab", "ab")
    check value == 3

  test "isPalindrome: check palindrome":
    check isPalindrome("racecar") == true
    check isPalindrome("hello") == false

  test "isPalindrome: single char":
    check isPalindrome("a") == true

  test "allPalindromes: find all palindromic substrings":
    let value = allPalindromes("aba")
    check value.contains("a")
    check value.contains("b")
    check value.contains("aba")

  test "matchPattern: find pattern in sequence":
    let text = @[1, 2, 3, 2, 3, 2, 3]
    let pattern = @[2, 3]
    let matches = matchPattern(pattern, text)
    check matches.len == 3
    check 1 in matches
    check 3 in matches
    check 5 in matches

  test "parseRange: parses range format correctly":
    var value = parseRange("123-456")
    check value.start == 123
    check value.ending == 456

    value = parseRange("-10--5")
    check value.start == -10
    check value.ending == -5

  test "parseIntLine: parses all integers by default":
    let value = parseIntLine("10 20 30")
    check value == @[10, 20, 30]

  test "parseIntLine: validates single integer":
    let value = parseIntLine("42", 1)
    check value == @[42]

  test "parseIntLine: validates two integers":
    let value = parseIntLine("10 20", 2)
    check value == @[10, 20]

  test "parseIntLine: validates three integers":
    let value = parseIntLine("1 2 3", 3)
    check value == @[1, 2, 3]
