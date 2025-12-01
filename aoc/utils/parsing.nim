# String Parsing Utilities for AOC
# Comprehensive string parsing functions for common AOC patterns

import std/strutils, std/sequtils

# ============================================================================
# BASIC PARSING FUNCTIONS
# ============================================================================

proc parseLines*(s: string): seq[string] =
  ## Parse string into lines, handling both \n and \r\n
  s.split('\n').filterIt(it.len > 0).mapIt(it.strip)

proc parseSections*(s: string, sep = ""): seq[seq[string]] =
  ## Parse string into sections (separated by blank lines or custom separator)
  let separator = if sep == "": "\n\n" else: sep
  s.strip.split(separator).mapIt(it.strip.parseLines)

proc parseTokens*(line: string, sep = ' '): seq[string] =
  ## Parse line into tokens, removing empty strings
  line.split(sep).filterIt(it.len > 0)

proc parseInts*(line: string, sep = ' '): seq[int] =
  ## Parse all integers from a line
  line.split(sep).filterIt(it.len > 0).mapIt(parseInt(it))

proc parseChars*(line: string): seq[char] =
  ## Convert line to char sequence
  line.toSeq

# ============================================================================
# EXTRACTION FUNCTIONS
# ============================================================================

proc extractInts*(s: string): seq[int] =
  ## Extract all integers from string (including negative)
  var extracted: seq[int] = @[]
  var i = 0
  while i < s.len:
    if s[i].isDigit or (s[i] == '-' and i + 1 < s.len and s[i+1].isDigit):
      var num = ""
      if s[i] == '-':
        num.add('-')
        i.inc
      while i < s.len and s[i].isDigit:
        num.add(s[i])
        i.inc
      extracted.add(parseInt(num))
    else:
      i.inc
  extracted

proc countOccurrences*(s: string, sub: string): int =
  ## Count non-overlapping occurrences of substring
  var count = 0
  var idx = 0
  while true:
    idx = s.find(sub, idx)
    if idx == -1: break
    count.inc
    idx += sub.len
  count

# ============================================================================
# STRING UTILITIES
# ============================================================================

proc isPalindrome*(s: string): bool =
  # Manual reversal for strings since .reversed() doesn't exist on strings
  for i in 0..<s.len div 2:
    if s[i] != s[s.len - 1 - i]:
      return false
  true

proc allPalindromes*(s: string): seq[string] =
  ## Find all palindromic substrings
  var found: seq[string] = @[]
  for i in 0..<s.len:
    for j in i..<s.len:
      let sub = s[i..j]
      if sub.isPalindrome:
        found.add(sub)
  found

proc matchPattern*[T](pattern: seq[T], text: seq[T]): seq[int] =
  ## Simple pattern matching (KMP would be better for large inputs)
  var matches: seq[int] = @[]
  if pattern.len == 0 or pattern.len > text.len:
    return matches

  for i in 0..text.len - pattern.len:
    var matched = true
    for j in 0..<pattern.len:
      if pattern[j] != text[i + j]:
        matched = false
        break
    if matched:
      matches.add(i)

  matches

# ============================================================================
# MEMOIZATION SUPPORT FOR RECURSIVE FUNCTIONS
# ============================================================================

import std/tables

# Template for creating memoized versions of functions
template memoize*(fnName: untyped, argType: typedesc,
    resultType: typedesc): untyped =
  var cache: Table[argType, resultType] = initTable[argType, resultType]()

  template fnName*(n: argType): resultType =
    if n in cache:
      cache[n]
    else:
      let result = fnName(n) # Note: This needs to be defined separately
      cache[n] = result
      result

# Specific memoization templates for common patterns
template memoizeRec*(fnName: untyped, `fn`: untyped): untyped =
  ## Memoize a recursive function with automatic caching
  var cache: Table[int, int] = initTable[int, int]()

  template `fnName`*(n: int): int =
    if n in cache:
      cache[n]
    else:
      let result = `fn`
      cache[n] = result
      result

# Example usage for fibonacci:
template memoizeFib*: untyped =
  var cache: Table[int, int] = initTable[int, int]()
  cache[0] = 0
  cache[1] = 1

  template fibonacciMemoized*(n: int): int =
    if n in cache:
      cache[n]
    else:
      let result = fibonacciMemoized(n-1) + fibonacciMemoized(n-2)
      cache[n] = result
      result

# More flexible memoization for multi-argument functions
template memoize2*(fnName: untyped, `fn`: untyped): untyped =
  var cache: Table[(int, int), int] = initTable[(int, int), int]()

  template fnName*(a, b: int): int =
    let key = (a, b)
    if key in cache:
      cache[key]
    else:
      let result = `fn`
      cache[key] = result
      result
