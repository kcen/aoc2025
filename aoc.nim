import aoc/[aoc_utils, day_00]
when compileOption("profiler"):
  import nimprof

case getDay():
  of 0:
    printSolution day_00()
  else:
    notImplemented()
