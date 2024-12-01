const fs = require("fs");
const assert = require("node:assert/strict")
const test = require("node:test")

function main() {
    const input = parseData("data.txt");
    const dist = distance(input);
    const simScore = similarity(input)

    console.log("Solution 1:", dist);
    console.log("Solution 2:", simScore);
}

/**
 * Get the data as a list of pairs.
 * @param {string} filename The txt file containing number list
 * @returns A list of pairs of numbers
 */
function parseData(filename) {
    return fs.readFileSync(filename, "utf-8")
        .split("\n")
        .map(p => p.split("   "))
        .map(p => p.map(x => parseInt(x)));
}

/**
 * Get the distance between the sorted columns
 * @param {number[][]} pairs 
 * @returns A number representing the distance between the two columns
 * @see https://adventofcode.com/2024/day/1 part 1
 */
function distance(pairs) {
    let left = pairs.map(p => p[0]);
    let right = pairs.map(p => p[1]);

    left.sort();
    right.sort();

    let sum = 0;
    for (let index = 0; index < left.length; index++) {
        sum += Math.abs(left[index] - right[index]);
    }

    return sum;
}

/**
 * Get the similarity score of the list
 * @param {number[][]} pairs 
 * @returns A number representing the similarity score of the list
 * @see https://adventofcode.com/2024/day/1 part 2
 */
function similarity(pairs) {
    let sim = 0;

    pairs.forEach(pair => {
        let [first, _] = pair;
        sim += pairs.filter(p => p[1] == first).length * first
    })

    return sim;
}

function parseArgs() {
    let args = process.argv

    if (args.includes("--help") || args.includes("-h")) {
        console.log("Solution for advent of code day 1")
        console.log("\nUsage:\n\tnode historian_hysteria.js [--test|-h]")
        console.log("\nOptions:\n\t--help/-h\tshow this message")
        console.log("\t--test/-t\trun testsuites")
        return;
    }

    if (args.includes("--test") || args.includes("-t")) {
        test.describe("Unit tests", () => {
            const testArr = parseData("test.txt")

            test.it("Distance should be 11", () => {
                assert.equal(distance(testArr), 11)
            })

            test.it("Similarity score should be 31", () => {
                assert.equal(similarity(testArr), 31)
            })
        });
        return;
    }

    main();
}

parseArgs()
