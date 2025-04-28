import Foundation
import SwiftUI

class SudokuGameViewModel: ObservableObject {
    @Published var game: SudokuGame
    @Published var board: [[Int?]] = Array(repeating: Array(repeating: nil, count: 9), count: 9)
    @Published var fixedCells: [[Bool]] = Array(repeating: Array(repeating: false, count: 9), count: 9)
    @Published var selectedCell: (row: Int, column: Int)? = nil
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var errors: Set<String> = []
    
    init(difficulty: SudokuGame.Difficulty = .medium) {
        game = SudokuGame(difficulty: difficulty)
        board = game.board
        fixedCells = game.fixedCells
    }
    
    func startNewGame(difficulty: SudokuGame.Difficulty = .medium) {
        game = SudokuGame(difficulty: difficulty)
        board = game.board
        fixedCells = game.fixedCells
        selectedCell = nil
        errors.removeAll()
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
                errors.remove("\(row),\(column)")
                
                // Check if the board is complete
                if game.isBoardComplete() {
                    checkSolution()
                }
            } else {
                // Mark this cell as having an error
                errors.insert("\(row),\(column)")
                
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
            errors.remove("\(row),\(column)")
        }
    }
    
    func cellHasError(row: Int, column: Int) -> Bool {
        return errors.contains("\(row),\(column)")
    }
    
    func checkSolution() {
        if game.isBoardComplete() {
            if game.isBoardCorrect() {
                alertTitle = "Congratulations!"
                alertMessage = "You've solved the puzzle correctly!"
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
}