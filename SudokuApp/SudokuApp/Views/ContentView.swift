import SwiftUI

struct ContentView: View {
    @StateObject private var gameViewModel = SudokuGameViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SudokuGridView(gameViewModel: gameViewModel)
                
                Spacer()
                
                NumberPadView(gameViewModel: gameViewModel)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        gameViewModel.startNewGame()
                    }) {
                        Text("New Game")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        gameViewModel.checkSolution()
                    }) {
                        Text("Check")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            .navigationTitle("Sudoku")
            .alert(isPresented: $gameViewModel.showAlert) {
                Alert(
                    title: Text(gameViewModel.alertTitle),
                    message: Text(gameViewModel.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}