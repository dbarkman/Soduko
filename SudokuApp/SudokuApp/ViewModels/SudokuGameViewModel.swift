import Foundation
import SwiftUI

// Define a struct for cell position to use in error tracking
struct CellPosition: Hashable {
    let row: Int
    let column: Int
}

class SudokuGameViewModel: ObservableObject {
    @Published var game: SudokuGame
    @Published var board: [[Int?]] = Array(repeating: Array(repeating: nil, count: 9), count: 9)
    @Published var fixedCells: [[Bool]] = Array(repeating: Array(repeating: false, count: 9), count: 9)
    @Published var selectedCell: (row: Int, column: Int)? = nil
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var errors: Set<CellPosition> = []
    @Published var gameTime: TimeInterval = 0
    @Published var isTimerRunning = false
    private var timer: Timer?
    private var startTime: Date?
    
    init(difficulty: SudokuGame.Difficulty = .medium) {
        game = SudokuGame(difficulty: difficulty)
        board = game.board
        fixedCells = game.fixedCells
        startTimer()
    }
    
    func startNewGame(difficulty: SudokuGame.Difficulty = .medium) {
        game = SudokuGame(difficulty: difficulty)
        board = game.board
        fixedCells = game.fixedCells
        selectedCell = nil
        errors.removeAll()
        resetTimer()
        startTimer()
    }
    
    private func startTimer() {
        isTimerRunning = true
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, let startTime = self.startTime else { return }
            self.gameTime = Date().timeIntervalSince(startTime)
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
    }
    
    private func resetTimer() {
        stopTimer()
        gameTime = 0
    }
    
    // Format the time as MM:SS
    func formattedTime() -> String {
        let minutes = Int(gameTime) / 60
        let seconds = Int(gameTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func selectCell(row: Int, column: Int) {
        if !fixedCells[row][column] {
            selectedCell = (row, column)
        }
    }
    
    func enterNumber(_ number: Int) {
        guard let selectedCell = selectedCell else { return }
        
        let row = selectedCell.row
        let column = selectedCell.column
        
        if !fixedCells[row][column] {
            // Check if the move is valid
            if game.isValidMove(row: row, column: column, number: number) {
                board[row][column] = number
                game.board[row][column] = number
                
                // Remove any errors for this cell
                errors.remove(CellPosition(row: row, column: column))
                
                // Check if the board is complete
                if game.isBoardComplete() {
                    checkSolution()
                }
            } else {
                // Mark this cell as having an error
                errors.insert(CellPosition(row: row, column: column))
                
                // Still allow the move but mark it as an error
                board[row][column] = number
                game.board[row][column] = number
            }
        }
    }
    
    func clearSelectedCell() {
        guard let selectedCell = selectedCell else { return }
        
        let row = selectedCell.row
        let column = selectedCell.column
        
        if !fixedCells[row][column] {
            board[row][column] = nil
            game.board[row][column] = nil
            
            // Remove any errors for this cell
            errors.remove(CellPosition(row: row, column: column))
        }
    }
    
    func cellHasError(row: Int, column: Int) -> Bool {
        return errors.contains(CellPosition(row: row, column: column))
    }
    
    func checkSolution() {
        if game.isBoardComplete() {
            if game.isBoardCorrect() {
                stopTimer()
                alertTitle = "Congratulations!"
                alertMessage = "You've solved the puzzle correctly in \(formattedTime())!"
            } else {
                alertTitle = "Not Quite Right"
                alertMessage = "There are some errors in your solution. Keep trying!"
            }
            showAlert = true
        } else {
            alertTitle = "Incomplete"
            alertMessage = "Please fill in all cells before checking the solution."
            showAlert = true
        }
    }
    
    // Method to reveal the solution
    func revealSolution() {
        stopTimer()
        for row in 0..<9 {
            for col in 0..<9 {
                board[row][col] = game.solution[row][col]
            }
        }
        alertTitle = "Solution Revealed"
        alertMessage = "Here's the correct solution. Try a new game!"
        showAlert = true
    }
}