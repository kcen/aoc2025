# String Parsing Utilities for AOC
# Comprehensive string parsing functions for common AOC patterns

import std/strutils, std/sequtils, std/strscans

# ============================================================================
# BASIC PARSING FUNCTIONS
# ============================================================================

proc parseLines*(s: string): seq[string] =
  ## Split string into non-empty lines
  let lines = s.split('\n')
  result = newSeq[string](lines.len)
  for idx, line in lines:
    result[idx] = line.strip()

proc parseSections*(s: string, sep = ""): seq[seq[string]] =
  ## Split string into sections separated by blank lines
  result = @[]
  let separator = if sep == "": "\n\n" else: sep
  let parts = s.strip.split(separator)
  result = newSeq[seq[string]](parts.len)
  for idx, part in parts:
    result[idx] = parseLines(part)

proc parseTokens*(line: string, sep = ' '): seq[string] =
  ## Split a string by a separator
  line.split(sep)

proc parseInts*(line: string, sep = ' '): seq[int] =
  ## Parse string into sequence of integers split by separator
  let tokens = line.split(sep)
  result = newSeq[int](tokens.len)
  for idx, token in tokens:
    result[idx] = parseInt(token)

proc lineChars*(s: string): seq[seq[char]] =
  ## Split a string into lines of chars
  result = @[]
  let lines = s.split('\n')
  result = newSeq[seq[char]](lines.len)
  for idx, line in lines:
    result[idx] = line.toSeq

proc parseChars*(line: string): seq[char] =
  ## Convert string to sequence of characters
  line.toSeq

# ============================================================================
# SCANF-BASED PARSING UTILITIES
# ============================================================================

proc parseRange*(line: string): tuple[start, ending: int] =
  ## Parse range format "start-end" into tuple
  ## Uses scanf for optimal performance
  var start, ending: int
  if scanf(line, "$i-$i", start, ending):
    result = (start, ending)
  else:
    raise newException(ValueError, "Invalid range format: " & line)

proc parseIntLine*(line: string, expectedCount: int = -1): seq[int] =
  ## Parse integers from a line, optionally specifying expected count
  ## Optimized using scanf patterns
  if expectedCount == -1:
    # Parse all integers on the line using scanTuple for efficiency
    result = @[]
    var i = 0
    while i < line.len:
      var success = false
      var val: int
      let remaining = line[i .. ^1]
      if scanf(remaining, "$i", val):
        result.add(val)
        # Move past the parsed integer
        while i < line.len and (line[i].isDigit or line[i] == '-'):
          i.inc
        while i < line.len and not (line[i].isDigit or line[i] == '-'):
          i.inc
        continue
      i.inc
  elif expectedCount == 1:
    # Parse single integer
    var val: int
    if scanf(line, "$i", val):
      return @[val]
    else:
      raise newException(ValueError, "Expected single integer, got: " & line)
  elif expectedCount == 2:
    # Parse two integers
    var a, b: int
    if scanf(line, "$i $i", a, b):
      return @[a, b]
    else:
      raise newException(ValueError, "Expected two integers, got: " & line)
  elif expectedCount == 3:
    # Parse three integers
    var a, b, c: int
    if scanf(line, "$i $i $i", a, b, c):
      return @[a, b, c]
    else:
      raise newException(ValueError, "Expected three integers, got: " & line)
  else:
    # Fall back to manual extraction and validate count
    result = @[]
    var i = 0
    while i < line.len:
      var val: int
      let remaining = line[i .. ^1]
      if scanf(remaining, "$i", val):
        result.add(val)
        while i < line.len and (line[i].isDigit or line[i] == '-'):
          i.inc
        while i < line.len and not (line[i].isDigit or line[i] == '-'):
          i.inc
        continue
      i.inc

    if result.len != expectedCount:
      raise newException(ValueError, "Expected " & $expectedCount &
          " integers, got " & $result.len & ": " & line)

# ============================================================================
# EXTRACTION FUNCTIONS
# ============================================================================

proc extractInts*(s: string): seq[int] =
  ## Extract all integers from string
  ## Optimized using scanTuple for better performance
  result = @[]
  var i = 0

  while i < s.len:
    # Skip non-digit characters (but keep minus signs)
    while i < s.len and not (s[i].isDigit or s[i] == '-'):
      i.inc
    if i >= s.len:
      break

    # Use scanf to parse the integer starting at position i
    let remaining = s[i .. ^1]
    var parsed: int
    if scanf(remaining, "$i", parsed):
      result.add(parsed)
      # Move past the parsed integer
      while i < s.len and (s[i].isDigit or s[i] == '-'):
        i.inc
    else:
      i.inc # Fallback: advance by one if scanf fails

proc countOccurrences*(s: string, sub: string): int =
  ## Count occurrences of substring in string
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
  ## Check if string is a palindrome
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
  ## Find all indices where pattern matches in text
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

template memoize*(fnName: untyped, argType: typedesc,
    resultType: typedesc): untyped =
  ## Generic memoization template for single-argument functions
  var cache: Table[argType, resultType] = initTable[argType, resultType]()

  template fnName*(n: argType): resultType =
    if n in cache:
      cache[n]
    else:
      let result = fnName(n)
      cache[n] = result
      result

template memoizeRec*(fnName: untyped, `fn`: untyped): untyped =
  ## Memoize a recursive int->int function
  var cache: Table[int, int] = initTable[int, int]()

  template `fnName`*(n: int): int =
    if n in cache:
      cache[n]
    else:
      let result = `fn`
      cache[n] = result
      result

template memoizeFib*: untyped =
  ## Memoized Fibonacci sequence template
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

template memoize2*(fnName: untyped, `fn`: untyped): untyped =
  ## Memoize a two-argument int function
  var cache: Table[(int, int), int] = initTable[(int, int), int]()

  template fnName*(a, b: int): int =
    let key = (a, b)
    if key in cache:
      cache[key]
    else:
      let result = `fn`
      cache[key] = result
      result
