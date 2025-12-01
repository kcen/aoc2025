import aoc/[aoc_utils, day_00, day_01]
when compileOption("profiler"):
  import nimprof

case getDay():
  of 0:
    printSolution day_00()
  of 1:
    printSolution day_01()
  else:
    notImplemented()
