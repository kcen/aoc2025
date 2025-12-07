import aoc/[aoc_utils, day_00, day_01, day_02, day_03, day_04, day_05, day_06, day_07]
when compileOption("profiler"):
  import nimprof

case getDay():
  of 0:
    printSolution day_00()
  of 1:
    printSolution day_01()
  of 2:
    printSolution day_02()
  of 3:
    printSolution day_03()
  of 4:
    printSolution day_04()
  of 5:
    printSolution day_05()
  of 6:
    printSolution day_06()
  of 7:
    printSolution day_07()
  else:
    notImplemented()
