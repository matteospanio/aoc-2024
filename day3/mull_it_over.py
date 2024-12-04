#/usr/bin/env python3

import re
import pathlib as pt


REGEXP1 = r"mul\((\d+),(\d+)\)"
REGEXP2 = r"(mul)\((\d+),(\d+)\)|(do\(\))|(don't\(\))"

def read_data(filepath: str) -> str:
    with pt.Path(filepath).open("r") as f:
        data = f.read()
    return data

def task1() -> None:
    data = read_data("data.txt")
    matches = re.findall(REGEXP1, data)
    sum = 0
    for op1, op2 in matches:
        sum += int(op1) * int(op2)
    print(sum)

def task2() -> None:
    data = read_data("data.txt")
    matches = re.findall(REGEXP2, data)
    sum = 0
    do = True
    for t in matches:
        if "do()" in t:
            do = True
        if "don't()" in t:
            do = False
        if "mul" in t:
            if do:
                sum += int(t[1]) * int(t[2])
    print(sum)

if __name__ == "__main__":
    task1()
    task2()