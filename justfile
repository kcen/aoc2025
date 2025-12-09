# AOC 2025 Justfile

# Show available commands
default:
  @just --list

# Build optimized release binary (for benchmarking)
build:
  @mkdir -p dist
  @chmod +x ci/scripts/build.sh
  @./ci/scripts/build.sh

# Build debug binary (for development)
debug:
  @mkdir -p dist
  nimble --out:dist/kcen-aoc-debug --threads:on -d:nimDebugDlOpen c aoc.nim

# Run a specific day with input (debug mode, compiles on demand)
run DAY INPUT:
  AOC_DAY={{DAY}} AOC_INPUT={{INPUT}} nimble c --threads:on --out:dist/kcen-aoc-debug -d:nimDebugDlOpen -r --hints:off aoc.nim

# Run with example input: inputs/day_XX_example
example DAY:
  @just run {{DAY}} inputs/day_{{DAY}}_example

# Run with real input: inputs/day_XX
solve DAY:
  @just run {{DAY}} inputs/day_{{DAY}}

# Profile a specific day (enables profiler)
profile DAY INPUT:
  AOC_DAY={{DAY}} AOC_INPUT={{INPUT}} nimble c --out:dist/kcen-aoc-profile --profiler:on --stackTrace:on -d:nimDebugDlOpen -r aoc.nim

# Benchmark a specific day (uses optimized binary)
bench DAY INPUT: build
  AOC_DAY={{DAY}} AOC_INPUT={{INPUT}} hyperfine -w 100 -u microsecond -N dist/kcen-aoc

# Create template for a new day
new DAY:
  @echo 'import aoc_utils\n\nproc day_{{DAY}}*(): Solution =\n  let input = getInput()\n  result = Solution(part_one: "TODO", part_two: "TODO")' > aoc/day_{{DAY}}.nim
  @touch inputs/day_{{DAY}} inputs/day_{{DAY}}_example
  @echo "Created aoc/day_{{DAY}}.nim and input files"
  @echo "Remember to add day_{{DAY}} to aoc.nim imports and case statement!"

# Test the utils
test:
  nimble test

# Clean build artifacts
clean:
  rm -rf dist/ nimcache/
  rm -f profile_results.txt

# Format Nim code
fmt:
  @find aoc -name "*.nim" -exec nimpretty {} \;
  @find tests -name "*.nim" -exec nimpretty {} \;
  @nimpretty aoc.nim

# Build Docker containers
docker-build:
  docker build -f Dockerfile -t aoc2025-dev .
  docker build -f Dockerfile.bench -t aoc2025-bench .

# Compile inside Docker container
docker-compile:
  docker run -itv .:/repo/ aoc2025-dev ./ci/scripts/build.sh
