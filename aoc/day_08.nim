import aoc_utils
import std/sequtils, std/algorithm, std/sugar

type Edge = tuple[u, v: int, distance: int]

proc distance_squared*(a, b: Coord3): int {.inline, noSideEffect.} =
  let dx = a.x - b.x
  let dy = a.y - b.y
  let dz = a.z - b.z
  dx*dx + dy*dy + dz*dz

proc edges_by_length(junction_boxes: seq[Coord3]): seq[Edge] =
  let num_junctions = junction_boxes.len
  for i in 0..<num_junctions:
    for j in (i+1)..<num_junctions:
      let dist = distance_squared(junction_boxes[i], junction_boxes[j])
      result.add((u: i, v: j, distance: dist))
  result.sort((a,b) => cmp(a.distance, b.distance))

proc find_root(parent: var seq[int], x: int): int {.inline, noSideEffect.} =
  if parent[x] != x:
    parent[x] = find_root(parent, parent[x])
  return parent[x]

proc union(parent: var seq[int], rank, size: var seq[int], x, y: int) =
  let root_x = find_root(parent, x)
  let root_y = find_root(parent, y)
  if root_x != root_y:
    if rank[root_x] < rank[root_y]:
      parent[root_x] = root_y
      size[root_y].inc(size[root_x])
    elif rank[root_x] > rank[root_y]:
      parent[root_y] = root_x
      size[root_x].inc(size[root_y])
    else:
      parent[root_y] = root_x
      size[root_x].inc(size[root_y])
      rank[root_x].inc

# https://en.wikipedia.org/wiki/Kruskal%27s_algorithm
proc compute_circuit_products(junction_boxes: seq[Coord3], num_wires = 1000): (int, int) =
  let num_junctions = junction_boxes.len

  # Get distances for all edges and sort
  var edge_list = edges_by_length(junction_boxes)

  # Initialize union-find structures
  var parent = toSeq(0..<num_junctions)
  var rank = newSeqWith(num_junctions, 0)
  var component_size = newSeqWith(num_junctions, 1)

  var part_one = 0
  var part_two = 0
  var edge_count = 0

  for edge in edge_list:
    edge_count.inc

    if find_root(parent, edge.u) != find_root(parent, edge.v):
      union(parent, rank, component_size, edge.u, edge.v)

    if edge_count == num_wires:
      var circuit_sizes = toSeq(0..<num_junctions).filterIt(parent[it] == it).mapIt(component_size[it])
      circuit_sizes.sort(Descending)
      part_one = circuit_sizes[0] * circuit_sizes[1] * circuit_sizes[2]

    if component_size[find_root(parent, edge.u)] == num_junctions:
      part_two = junction_boxes[edge.u].x * junction_boxes[edge.v].x
      break
  (part_one, part_two)

proc day_08*(): Solution =
  let points = getInput().parseLines().mapIt(it.parseIntLine).mapIt((x: it[0], y: it[1], z: it[2]))

  let (part_one, part_two) = compute_circuit_products(points, 1000)

  result = Solution(part_one: $part_one, part_two: $part_two)
