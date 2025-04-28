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
        
        // Remove numbers based on difficulty while ensuring a unique solution
        let cellsToRemove = difficulty.cellsToRemove
        var cellsToTry = (0..<81).map { (($0 / 9), ($0 % 9)) }.shuffled()
        var removedCells = 0
        
        for (row, col) in cellsToTry {
            // Skip if already removed
            if board[row][col] == nil {
                continue
            }
            
            // Remember the value
            let temp = board[row][col]
            
            // Try removing it
            board[row][col] = nil
            fixedCells[row][col] = false
            
            // Check if the puzzle still has a unique solution
            if hasUniqueSolution() {
                removedCells += 1
                if removedCells >= cellsToRemove {
                    break
                }
            } else {
                // If not, put it back
                board[row][col] = temp
                fixedCells[row][col] = true
            }
        }
    }
    
    // Check if the current board has a unique solution
    private func hasUniqueSolution() -> Bool {
        // Create a copy of the board for solving
        var tempBoard = board
        var firstSolution: [[Int?]] = Array(repeating: Array(repeating: nil, count: 9), count: 9)
        var solutionCount = 0
        
        // Find the first solution
        if solvePuzzle(board: &tempBoard) {
            // Save the first solution
            firstSolution = tempBoard
            solutionCount += 1
            
            // Reset the board to try finding a second solution
            tempBoard = board
            
            // Try to find a different solution
            if findDifferentSolution(board: &tempBoard, firstSolution: firstSolution) {
                solutionCount += 1
            }
        }
        
        return solutionCount == 1
    }
    
    // Solve the puzzle using backtracking
    private func solvePuzzle(board: inout [[Int?]]) -> Bool {
        for row in 0..<9 {
            for col in 0..<9 {
                if board[row][col] == nil {
                    for num in 1...9 {
                        if isValidPlacementInBoard(board: board, row: row, col: col, num: num) {
                            board[row][col] = num
                            
                            if solvePuzzle(board: &board) {
                                return true
                            }
                            
                            board[row][col] = nil
                        }
                    }
                    return false
                }
            }
        }
        return true
    }
    
    // Try to find a solution different from the first one
    private func findDifferentSolution(board: inout [[Int?]], firstSolution: [[Int?]]) -> Bool {
        for row in 0..<9 {
            for col in 0..<9 {
                if board[row][col] == nil {
                    for num in 1...9 {
                        if isValidPlacementInBoard(board: board, row: row, col: col, num: num) {
                            board[row][col] = num
                            
                            // Check if this is leading to a different solution
                            if board[row][col] != firstSolution[row][col] {
                                if solvePuzzle(board: &board) {
                                    return true
                                }
                            }
                            
                            if findDifferentSolution(board: &board, firstSolution: firstSolution) {
                                return true
                            }
                            
                            board[row][col] = nil
                        }
                    }
                    return false
                }
            }
        }
        
        // Check if the solution is different from the first one
        for row in 0..<9 {
            for col in 0..<9 {
                if board[row][col] != firstSolution[row][col] {
                    return true
                }
            }
        }
        
        return false
    }
    
    // Check if a number can be placed in a specific position on the board
    private func isValidPlacementInBoard(board: [[Int?]], row: Int, col: Int, num: Int) -> Bool {
        // Check row
        for c in 0..<9 {
            if board[row][c] == num {
                return false
            }
        }
        
        // Check column
        for r in 0..<9 {
            if board[r][col] == num {
                return false
            }
        }
        
        // Check 3x3 box
        let boxRow = row - row % 3
        let boxCol = col - col % 3
        
        for r in 0..<3 {
            for c in 0..<3 {
                if board[boxRow + r][boxCol + c] == num {
                    return false
                }
            }
        }
        
        return true
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
                if (currentRow != row || currentCol != column) && board[currentRow][currentCol] == number {
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