#!/bin/bash
nimble --out:dist/kcen-aoc -d:danger --mm:orc -d:lto --passC:-march=native c aoc.nim
