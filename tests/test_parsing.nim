# Parsing Utility Tests
# Tests for string parsing and extraction functions

import unittest
import ../aoc/aoc_utils
import ../aoc/utils/parsing

suite "Basic Parsing Functions":
  test "parseLines: splits by newline and strips whitespace":
    let input = "  hello\n  world  \n  test  "
    let result = parseLines(input)
    check result == @["hello", "world", "test"]

  test "parseLines: handles empty lines":
    let input = "line1\n\nline2\n"
    let result = parseLines(input)
    check result.len == 2
    check result[0] == "line1"
    check result[1] == "line2"

  test "parseTokens: splits tokens with custom separator":
    let result = parseTokens("hello,world,test", ',')
    check result == @["hello", "world", "test"]

  test "parseInts: extracts all integers from string":
    let result = parseInts("10 20 30 40")
    check result == @[10, 20, 30, 40]

  test "parseInts: handles negative numbers":
    let result = parseInts("1 -5 3 -10")
    check result == @[1, -5, 3, -10]

  test "parseInts: works with different separators":
    let result = parseInts("10,20,30", ',')
    check result == @[10, 20, 30]

  test "parseSections: handles blank line separation":
    let input = "line1\nline2\n\nsection2\nline3"
    let result = parseSections(input)
    check result.len == 2
    check result[0] == @["line1", "line2"]
    check result[1] == @["section2", "line3"]

  test "parseChars: converts string to char sequence":
    let result = parseChars("ABC")
    check result == @['A', 'B', 'C']

  test "lineChars: converts multiline to char grid":
    let result = lineChars("AB\nCD")
    check result.len == 2
    check result[0] == @['A', 'B']
    check result[1] == @['C', 'D']

suite "Extraction Functions":
  test "extractInts: extracts integers from complex string":
    let result = extractInts("x=10, y=-20, z=30")
    check result == @[10, -20, 30]

  test "extractInts: handles negative numbers in context":
    let result = extractInts("temp=-5, count=10, delta=-3")
    check result == @[-5, 10, -3]

  test "countOccurrences: count substring occurrences":
    let result = countOccurrences("ababab", "ab")
    check result == 3

suite "String Utilities":
  test "isPalindrome: check palindrome":
    check isPalindrome("racecar") == true
    check isPalindrome("hello") == false

  test "isPalindrome: single char":
    check isPalindrome("a") == true

  test "allPalindromes: find all palindromic substrings":
    let result = allPalindromes("aba")
    check result.contains("a")
    check result.contains("b")
    check result.contains("aba")

  test "matchPattern: find pattern in sequence":
    let text = @[1, 2, 3, 2, 3, 2, 3]
    let pattern = @[2, 3]
    let matches = matchPattern(pattern, text)
    check matches.len == 3
    check 1 in matches
    check 3 in matches
    check 5 in matches

echo "Parsing utility tests completed!"
