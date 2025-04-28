import SwiftUI

struct NumberPadView: View {
    @ObservedObject var gameViewModel: SudokuGameViewModel
    @Environment(\.colorScheme) var colorScheme
    
    // 3x3 grid for numbers 1-9, plus a row for controls
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 15) {
            // Number pad 1-9
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(1...9, id: \.self) { number in
                    NumberButton(number: number) {
                        withAnimation {
                            gameViewModel.enterNumber(number)
                        }
                    }
                    .accessibilityLabel("Number \(number)")
                }
            }
            .padding(.horizontal)
            
            // Control buttons
            HStack(spacing: 15) {
                // Clear cell button
                ControlButton(icon: "delete.left", label: "Clear") {
                    withAnimation {
                        gameViewModel.clearSelectedCell()
                    }
                }
                
                // Check solution button
                ControlButton(icon: "checkmark.circle", label: "Check") {
                    gameViewModel.checkSolution()
                }
                
                // New game button
                ControlButton(icon: "arrow.clockwise", label: "New") {
                    withAnimation {
                        gameViewModel.startNewGame()
                    }
                }
                
                // Reveal solution button
                ControlButton(icon: "eye", label: "Reveal") {
                    gameViewModel.revealSolution()
                }
            }
            .padding(.horizontal)
            
            // Removed timer display as it's already shown in the header
        }
        .padding(.bottom)
    }
}

// Reusable number button component
struct NumberButton: View {
    let number: Int
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            isPressed = true
            action()
            
            // Reset the pressed state after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                isPressed = false
            }
        }) {
            Text("\(number)")
                .font(.title)
                .fontWeight(.semibold)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(buttonColor)
                        .shadow(color: shadowColor, radius: isPressed ? 1 : 3, x: 0, y: isPressed ? 1 : 2)
                )
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var buttonColor: Color {
        colorScheme == .dark ? Color.gray.opacity(0.3) : Color.white
    }
    
    private var shadowColor: Color {
        colorScheme == .dark ? Color.black.opacity(0.3) : Color.gray.opacity(0.3)
    }
}

// Reusable control button component
struct ControlButton: View {
    let icon: String
    let label: String
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            isPressed = true
            action()
            
            // Reset the pressed state after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                isPressed = false
            }
        }) {
            VStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.title2)
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(buttonColor)
                    .shadow(color: shadowColor, radius: isPressed ? 1 : 3, x: 0, y: isPressed ? 1 : 2)
            )
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(label)
    }
    
    private var buttonColor: Color {
        colorScheme == .dark ? Color.gray.opacity(0.3) : Color.white
    }
    
    private var shadowColor: Color {
        colorScheme == .dark ? Color.black.opacity(0.3) : Color.gray.opacity(0.3)
    }
}