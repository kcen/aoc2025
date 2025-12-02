#!/bin/sh
nim --out:dist/kcen-aoc -d:danger --mm:orc -d:pgo -d:lto --passC:-march=native c aoc.nim
