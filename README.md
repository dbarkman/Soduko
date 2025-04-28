# Sudoku App

A Swift and SwiftUI-based Sudoku game for iPhone.

## Features

- Clean, modern UI built with SwiftUI
- Multiple difficulty levels (Easy, Medium, Hard, Expert)
- Real-time validation of moves
- New game generation
- Solution checking

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture:

- **Models**: Contains the core game logic and data structures
  - `SudokuGame.swift`: Handles game state, board generation, and validation

- **Views**: UI components built with SwiftUI
  - `ContentView.swift`: Main view that orchestrates the game UI
  - `SudokuGridView.swift`: Displays the Sudoku grid
  - `NumberPadView.swift`: Input pad for entering numbers

- **ViewModels**: Connects the models and views
  - `SudokuGameViewModel.swift`: Manages game state and user interactions

## Requirements

- iOS 14.0+
- Xcode 12.0+
- Swift 5.3+

## Installation

1. Clone the repository
2. Open `SudokuApp.xcodeproj` in Xcode
3. Build and run the app on your device or simulator

## How to Play

1. Tap on an empty cell to select it
2. Use the number pad to enter a number
3. The app will highlight errors in red
4. Use the "Check" button to verify your solution
5. Start a new game with the "New Game" button

## License

This project is available under the MIT license. See the LICENSE file for more info.