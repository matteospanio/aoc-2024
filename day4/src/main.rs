use std::fs;

const DATA_PATH: &str = "data/data.txt";
type XMatrix = Vec<Vec<char>>;

fn read_data(file_path: &str) -> String {
    fs::read_to_string(file_path).expect("Where is the file?")
}

fn data2matrix(data: String) -> XMatrix {
    data.lines()
        .map(|line| line.chars().collect())
        .collect()
}

fn check_horizontal(matrix: &XMatrix) -> i32 {
    let mut sum = 0;
    for row in matrix {
        let len = row.len();
        for i in 0..len-3 {
            let mut subv = row[i..i+4].to_vec();
            if subv == ['X', 'M', 'A', 'S'] {
                sum += 1;
            }
            subv.reverse();
            if subv == ['X', 'M', 'A', 'S'] {
                sum += 1;
            }
        }
    }
    sum
}
 
fn check_vertical(matrix: &XMatrix) -> i32 {
    let mut sum = 0;
    let collen = matrix.len();
    let rowlen = matrix[0].len();

    for i in 0..collen-3 {
        for j in 0..rowlen {
            if matrix[i][j] == 'X' && matrix[i+1][j] == 'M' && matrix[i+2][j] == 'A' && matrix[i+3][j] == 'S' {
                sum += 1;
            }
            if matrix[collen-1-i][j] == 'X' && matrix[collen-1-i-1][j] =='M' && matrix[collen-1-i-2][j] == 'A' && matrix[collen-1-i-3][j] == 'S' {
                sum += 1;
            }
        }
    }

    sum
}

fn check_diagonal(matrix: &XMatrix) -> i32 { 
    let mut sum = 0;
    let collen = matrix.len();
    let rowlen = matrix[0].len();

    for i in 0..collen - 3 {
        for j in 0..rowlen - 3 {
            if matrix[i][j] == 'X' && matrix[i+1][j+1] == 'M' && matrix[i+2][j+2] == 'A' && matrix[i+3][j+3] == 'S' {
                sum += 1;
            }
        }
    }

    for i in (3..collen).rev() {
        for j in (3..rowlen).rev() {
            if matrix[i][j] == 'X' && matrix[i-1][j-1] == 'M' && matrix[i-2][j-2] == 'A' && matrix[i-3][j-3] == 'S' {
                sum += 1;
            }
        }
    }

    for i in 0..collen-3 {
        for j in (3..rowlen).rev() {
            if matrix[i][j] == 'X' && matrix[i+1][j-1] == 'M' && matrix[i+2][j-2] == 'A' && matrix[i+3][j-3] == 'S' {
                sum += 1;
            }
        }
    }

    for i in (3..collen).rev() {
        for j in 0..rowlen - 3 {
            if matrix[i][j] == 'X' && matrix[i-1][j+1] == 'M' && matrix[i-2][j+2] == 'A' && matrix[i-3][j+3] == 'S' {
                sum += 1;
            }
        }
    }

    sum
}

fn check_x(m: &XMatrix, i: usize, j: usize) -> bool {
    (m[i-1][j-1] == 'M' && m[i+1][j-1] == 'M' && m[i-1][j+1] == 'S' && m[i+1][j+1] == 'S') ||
    (m[i-1][j-1] == 'M' && m[i+1][j-1] == 'S' && m[i-1][j+1] == 'M' && m[i+1][j+1] == 'S') ||
    (m[i-1][j-1] == 'S' && m[i+1][j-1] == 'M' && m[i-1][j+1] == 'S' && m[i+1][j+1] == 'M') ||
    (m[i-1][j-1] == 'S' && m[i+1][j-1] == 'S' && m[i-1][j+1] == 'M' && m[i+1][j+1] == 'M')
}

fn find_xmas(matrix: &XMatrix) -> i32 {
    let mut sum = 0;
    let nrows = matrix.len();
    let ncols = matrix[0].len();

    for i in 1..nrows-1 {
        for j in 1..ncols-1 {
            if matrix[i][j] == 'A' {
                if check_x(matrix, i, j) {
                    sum += 1;
                }
            }
        }
    }

    sum
}

fn count_xmas(matrix: &XMatrix) -> i32 {
    check_horizontal(matrix) + check_vertical(matrix) + check_diagonal(matrix)
}

fn main() {
    let data = read_data(DATA_PATH);
    let matrix = data2matrix(data);
    let count = count_xmas(&matrix);
    println!("{}", count);
    let xmas = find_xmas(&matrix);
    println!("{}", xmas);
}
