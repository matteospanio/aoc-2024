<?php

function get_data($filename) {
    $result = [];
    $data = file_get_contents($filename);
    $lines = explode("\n", $data);
    foreach ($lines as $line) {
        $line = explode(" ", $line);
        $line[0] = trim($line[0], ":");
        $result[] = $line;
    }

    return $result;
}

function concat($a, $b) {
    return $a == 0 ? $b : (int)sprintf("%d%d", $a, $b);
}

function pass(int $cnt, int $goal, array $input, int $task) {
    if ($cnt == $goal && $input == []) return true;
    if ($input == [] || $cnt > $goal) return false;

    $value = (int)$input[0];

    $addition = pass($cnt+$value, $goal, array_slice($input, 1), $task);
    $mult     = pass(($cnt == 0 ? 1 : $cnt)*$value, $goal, array_slice($input, 1), $task);
    if ($task == 1) return $addition || $mult;

    $concat   = pass(concat($cnt, $value), $goal, array_slice($input, 1), $task);
    return $addition || $mult || $concat;
}

$data = get_data("data.txt");

$sum = 0;
$TASK = 2;
foreach ($data as $line) {
    if (pass(0, (int)$line[0], array_slice($line, 1), 2)) {
        $sum += (int)$line[0];
    }
}
print_r($sum . "\n");
