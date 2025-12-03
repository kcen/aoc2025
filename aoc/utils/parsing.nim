# String Parsing Utilities for AOC
# Comprehensive string parsing functions for common AOC patterns

import std/strutils, std/sequtils, std/strscans

# ============================================================================
# BASIC PARSING FUNCTIONS
# ============================================================================

proc parseLines*(s: string): seq[string] =
  ## Split string into non-empty lines
  result = @[]
  let lines = s.split('\n')
  for line in lines:
    if line.len > 0:
      result.add(line.strip())

proc parseSections*(s: string, sep = ""): seq[seq[string]] =
  ## Split string into sections separated by blank lines
  result = @[]
  let separator = if sep == "": "\n\n" else: sep
  let parts = s.strip.split(separator)
  for part in parts:
    if part.len > 0:
      result.add(parseLines(part))

proc parseTokens*(line: string, sep = ' '): seq[string] =
  ## Split line into non-empty tokens
  result = @[]
  let tokens = line.split(sep)
  for token in tokens:
    if token.len > 0:
      result.add(token)

proc parseInts*(line: string, sep = ' '): seq[int] =
  ## Parse line into sequence of integers
  result = @[]
  let tokens = line.split(sep)
  for token in tokens:
    if token.len > 0:
      result.add(parseInt(token))

proc lineChars*(s: string): seq[seq[char]] =
  ## Split string into lines of characters
  s.split('\n').mapIt(it.toSeq)

proc parseChars*(line: string): seq[char] =
  ## Convert string to sequence of characters
  line.toSeq

# ============================================================================
# EXTRACTION FUNCTIONS
# ============================================================================

proc extractInts*(s: string): seq[int] =
  ## Extract all integers from string
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

template memoize*(fnName: untyped, argType: typedesc, resultType: typedesc): untyped =
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
