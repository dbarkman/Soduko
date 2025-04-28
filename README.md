# Sudoku App

A Swift and SwiftUI-based Sudoku game for iPhone with a modern, intuitive interface.

## Features

- Clean, modern UI built with SwiftUI
- Multiple difficulty levels (Easy, Medium, Hard, Expert)
- Real-time validation of moves
- Game timer to track your solving speed
- Dark mode support
- Accessibility features (VoiceOver support)
- Visual feedback for user interactions
- Unique solution guarantee for all puzzles
- Reveal solution option
- Animated UI elements for better user experience

## Enhanced Gameplay

- Intelligent highlighting of related cells (same row, column, and 3x3 box)
- Visual distinction between fixed and user-entered numbers
- Error highlighting with visual feedback
- Haptic feedback for button presses
- Improved 3x3 box visualization with distinct borders

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture:

- **Models**: Contains the core game logic and data structures
  - `SudokuGame.swift`: Handles game state, board generation, validation, and ensures puzzles have unique solutions

- **Views**: UI components built with SwiftUI
  - `ContentView.swift`: Main view that orchestrates the game UI with difficulty selection
  - `SudokuGridView.swift`: Displays the Sudoku grid with enhanced visual cues
  - `NumberPadView.swift`: Input pad with tactile feedback and game controls
  - Custom button components with animations and feedback

- **ViewModels**: Connects the models and views
  - `SudokuGameViewModel.swift`: Manages game state, user interactions, and timer functionality

## Requirements

- iOS 14.0+
- Xcode 12.0+
- Swift 5.3+

## Installation

1. Clone the repository
2. Open `SudokuApp.xcodeproj` in Xcode
3. Build and run the app on your device or simulator

## How to Play

1. Select a difficulty level (Easy, Medium, Hard, or Expert)
2. Tap on an empty cell to select it
3. Use the number pad to enter a number
4. The app will highlight related cells and any errors
5. Use the "Check" button to verify your solution
6. Start a new game with the "New" button
7. Use "Reveal" to see the solution if you're stuck
8. The timer tracks how long you've been playing

## Accessibility

The app includes comprehensive VoiceOver support:
- Cell values and states are properly announced
- Button actions are clearly labeled
- Game status is communicated effectively

## License

This project is available under the MIT license. See the LICENSE file for more info.