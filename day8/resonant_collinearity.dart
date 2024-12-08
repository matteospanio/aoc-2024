import 'dart:io';

typedef Grid<T> = List<List<T>>;
typedef Pair<T> = (T, T);
typedef Point = Pair<int>;

const TASK = 1; // 1 or 2

void main() {
  var lines = readFile("data.txt");
  var grid = lines2grid(lines);
  var (rows, cols) = getGridDim(grid);

  var antennas = getAntennas(grid);
  var pairs = getPairs(grid, antennas);
  var antinodes = <Pair<int>>[];
  for (final pair in pairs) {
    antinodes.addAll(TASK == 2 ? updatedGetAntinodes(pair, grid) : getAntinodes(pair));
  }
  if (TASK == 2) {
    antinodes.addAll(antennas);
  }

  var sum = 0;
  for (final (i, j) in antinodes.toSet()) {
    if (isInGrid(i, j, rows, cols)) {
      sum += 1;
    }
  }

  print(sum);
}

Point sumPoints(Point a, Point b) {
  return (a.$1 + b.$1, a.$2 + b.$2);
}

Point diffPoints(Point a, Point b) {
  return (a.$1 - b.$1, a.$2 - b.$2);
}

List<Point> updatedGetAntinodes(Pair<Point> pair, Grid<String> grid) {
  var (rows, cols) = getGridDim(grid);
  var (a, b) = pair;
  var distance = distanceVector(a, b);
  var antinodes = <Point>[];

  var np = sumPoints(a, distance);
  while (isInGrid(np.$1, np.$2, rows, cols)) {
    antinodes.add(np);
    np = sumPoints(np, distance);
  }

  np = diffPoints(b, distance);
  while (isInGrid(np.$1, np.$2, rows, cols)) {
    antinodes.add(np);
    np = diffPoints(np, distance);
  }

  return antinodes;
}

List<Pair<int>> getAntinodes(Pair<Pair<int>> pair) {
  var (a, b) = pair;
  var distance = distanceVector(a, b);
  var antinodes = <Pair<int>>[];
  antinodes.add((a.$1 + distance.$1, a.$2 + distance.$2));
  antinodes.add((b.$1 - distance.$1, b.$2 - distance.$2));
  return antinodes;
}

List<String> readFile(String fileName) {
  return File(fileName).readAsLinesSync();
}

Pair<int> distanceVector(Pair<int> a, Pair<int> b) {
  return ((a.$1 - b.$1), (a.$2 - b.$2));
}

Set<Pair<Point>> getPairs(Grid<String> grid, List<Pair<int>> antennas) {
  var result = <Pair<Point>>{};
  for (final (i, j) in antennas) {
    var c = grid[i][j];
    for (final (k, l) in antennas) {
      if (i != k && j != l && c == grid[k][l]) {
        var (a, b) = ((i, j), (k, l));
        if (!result.contains((b, a)) && !result.contains((a, b))) {
          result.add((a, b));
        }
      }
    }
  }
  return result;
}

Grid<String> lines2grid(List<String> lines) {
  return lines.map((line) => line.split("")).toList();
}

(int, int) getGridDim(Grid<String> grid) {
  return (grid.length, grid[0].length);
}

bool isInGrid(int i, int j, int rows, int cols) {
  return i >= 0 && i < rows && j >= 0 && j < cols;
}

List<(int, int)> getAntennas(Grid<String> grid) {
  var antennas = <(int, int)>[];
  for (var i = 0; i < grid.length; i++) {
    for (var j = 0; j < grid[i].length; j++) {
      if (grid[i][j] != ".") {
        antennas.add((i, j));
      }
    }
  }
  return antennas;
}
