import SwiftUI

struct ContentView: View {
    @StateObject private var gameViewModel = SudokuGameViewModel()
    @State private var showDifficultyPicker = false
    @State private var selectedDifficulty: SudokuGame.Difficulty = .medium
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Game header with timer and difficulty
                HStack {
                    // Timer display
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.secondary)
                        Text(gameViewModel.formattedTime())
                            .font(.headline)
                            .monospacedDigit()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                    )
                    
                    Spacer()
                    
                    // Difficulty button
                    Button(action: {
                        showDifficultyPicker = true
                    }) {
                        HStack {
                            Text(difficultyText)
                                .font(.headline)
                            Image(systemName: "chevron.down")
                                .font(.caption)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white)
                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                        )
                    }
                    .accessibilityLabel("Change difficulty, currently \(difficultyText)")
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Sudoku grid
                SudokuGridView(gameViewModel: gameViewModel)
                    .padding(.horizontal)
                
                // Number pad and controls
                NumberPadView(gameViewModel: gameViewModel)
                    .padding(.top)
            }
            .navigationTitle("Sudoku")
            .navigationBarTitleDisplayMode(.inline)
            .background(
                colorScheme == .dark ? 
                    Color.black : 
                    Color.gray.opacity(0.05)
            )
            .alert(isPresented: $gameViewModel.showAlert) {
                Alert(
                    title: Text(gameViewModel.alertTitle),
                    message: Text(gameViewModel.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .actionSheet(isPresented: $showDifficultyPicker) {
                ActionSheet(
                    title: Text("Select Difficulty"),
                    buttons: [
                        .default(Text("Easy")) { 
                            selectedDifficulty = .easy
                            gameViewModel.startNewGame(difficulty: .easy)
                        },
                        .default(Text("Medium")) { 
                            selectedDifficulty = .medium
                            gameViewModel.startNewGame(difficulty: .medium)
                        },
                        .default(Text("Hard")) { 
                            selectedDifficulty = .hard
                            gameViewModel.startNewGame(difficulty: .hard)
                        },
                        .default(Text("Expert")) { 
                            selectedDifficulty = .expert
                            gameViewModel.startNewGame(difficulty: .expert)
                        },
                        .cancel()
                    ]
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var difficultyText: String {
        switch selectedDifficulty {
        case .easy:
            return "Easy"
        case .medium:
            return "Medium"
        case .hard:
            return "Hard"
        case .expert:
            return "Expert"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.light)
            
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}