import Foundation

struct SudokuGame {
    var board: [[Int?]] = Array(repeating: Array(repeating: nil, count: 9), count: 9)
    var solution: [[Int]] = Array(repeating: Array(repeating: 0, count: 9), count: 9)
    var fixedCells: [[Bool]] = Array(repeating: Array(repeating: false, count: 9), count: 9)
    
    init(difficulty: Difficulty = .medium) {
        generateNewGame(difficulty: difficulty)
    }
    
    mutating func generateNewGame(difficulty: Difficulty) {
        // First, generate a solved board
        generateSolvedBoard()
        
        // Copy the solution
        for row in 0..<9 {
            for col in 0..<9 {
                board[row][col] = solution[row][col]
                fixedCells[row][col] = true
            }
        }
        
        // Remove numbers based on difficulty
        let cellsToRemove = difficulty.cellsToRemove
        var removedCells = 0
        
        while removedCells < cellsToRemove {
            let row = Int.random(in: 0..<9)
            let col = Int.random(in: 0..<9)
            
            if board[row][col] != nil {
                board[row][col] = nil
                fixedCells[row][col] = false
                removedCells += 1
            }
        }
    }
    
    private mutating func generateSolvedBoard() {
        // Start with an empty board
        for row in 0..<9 {
            for col in 0..<9 {
                solution[row][col] = 0
            }
        }
        
        // Fill the board using backtracking
        _ = solveSudoku()
    }
    
    private mutating func solveSudoku() -> Bool {
        for row in 0..<9 {
            for col in 0..<9 {
                if solution[row][col] == 0 {
                    for num in 1...9 {
                        if isValidPlacement(row: row, col: col, num: num) {
                            solution[row][col] = num
                            
                            if solveSudoku() {
                                return true
                            }
                            
                            solution[row][col] = 0
                        }
                    }
                    return false
                }
            }
        }
        return true
    }
    
    private func isValidPlacement(row: Int, col: Int, num: Int) -> Bool {
        // Check row
        for c in 0..<9 {
            if solution[row][c] == num {
                return false
            }
        }
        
        // Check column
        for r in 0..<9 {
            if solution[r][col] == num {
                return false
            }
        }
        
        // Check 3x3 box
        let boxRow = row - row % 3
        let boxCol = col - col % 3
        
        for r in 0..<3 {
            for c in 0..<3 {
                if solution[boxRow + r][boxCol + c] == num {
                    return false
                }
            }
        }
        
        return true
    }
    
    func isValidMove(row: Int, column: Int, number: Int) -> Bool {
        // Check if the cell is fixed
        if fixedCells[row][column] {
            return false
        }
        
        // Check row
        for col in 0..<9 {
            if col != column && board[row][col] == number {
                return false
            }
        }
        
        // Check column
        for r in 0..<9 {
            if r != row && board[r][column] == number {
                return false
            }
        }
        
        // Check 3x3 box
        let boxRow = row - row % 3
        let boxCol = column - column % 3
        
        for r in 0..<3 {
            for c in 0..<3 {
                let currentRow = boxRow + r
                let currentCol = boxCol + c
                if currentRow != row && currentCol != column && board[currentRow][currentCol] == number {
                    return false
                }
            }
        }
        
        return true
    }
    
    func isBoardComplete() -> Bool {
        for row in 0..<9 {
            for col in 0..<9 {
                if board[row][col] == nil {
                    return false
                }
            }
        }
        return true
    }
    
    func isBoardCorrect() -> Bool {
        for row in 0..<9 {
            for col in 0..<9 {
                if let value = board[row][col], value != solution[row][col] {
                    return false
                }
            }
        }
        return true
    }
    
    enum Difficulty {
        case easy
        case medium
        case hard
        case expert
        
        var cellsToRemove: Int {
            switch self {
            case .easy:
                return 30
            case .medium:
                return 40
            case .hard:
                return 50
            case .expert:
                return 60
            }
        }
    }
}