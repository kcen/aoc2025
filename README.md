# Advent of Code 2025

Solutions for [Advent of Code 2025](https://adventofcode.com/2025) written in Nim.

## Usage

### Quick Start

Run the example (day 0):
```bash
just test
```

### Available Commands

View all available just commands:
```bash
just
```

Key commands:
- `just build` - Build optimized release binary (for benchmarking)
- `just debug` - Build debug binary (for development)
- `just run DAY INPUT` - Run a specific day with input file (debug mode)
- `just example DAY` - Run with example input
- `just solve DAY` - Run with real input
- `just bench DAY INPUT` - Benchmark a solution (uses optimized binary)
- `just profile DAY INPUT` - Profile a solution
- `just new DAY` - Create template for a new day
- `just clean` - Clean build artifacts
- `just fmt` - Format Nim code

### Creating a New Day

```bash
just new 01
```

This creates:
- `aoc/day_01.nim` - Solution template
- `inputs/day_01` - Real input file (add your input)
- `inputs/day_01_example` - Example input file

Don't forget to add the new day to `aoc.nim`:
```nim
import aoc/[aoc_utils, day_00, day_01]

case getDay():
  of 0:
    printSolution day_00()
  of 1:
    printSolution day_01()
  # ...
```

### Running Solutions

Run with example input:
```bash
just example 01
```

Run with real input:
```bash
just solve 01
```

### Benchmarking

Benchmark your solution (requires hyperfine):
```bash
just bench 01 inputs/day_01
```

### Docker

Build containers:
```bash
just docker-build
```

Compile inside Docker:
```bash
just docker-compile
```

## Project Structure

```
.
├── aoc/                  # Solution modules
│   ├── aoc_utils.nim    # Shared utilities
│   └── day_XX.nim       # Day solutions
├── aoc.nim              # Entry point
├── aoc.nimble           # Package definition
├── ci/                  # Build scripts
│   └── scripts/
│       └── build.sh     # Build script
├── inputs/              # Input files
├── justfile             # Task runner configuration
├── Dockerfile           # Development container
└── Dockerfile.bench     # Benchmark container
```

## Benchmarking

This repository includes benchmark tooling for performance analysis. The benchmark setup uses the same tooling as last year for consistent measurements.

## License

See LICENSE file.
