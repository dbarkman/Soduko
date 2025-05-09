import SwiftUI

struct SudokuGridView: View {
    @ObservedObject var gameViewModel: SudokuGameViewModel
    @Environment(\.colorScheme) var colorScheme
    
    // Constants for border styling
    private let thinBorderWidth: CGFloat = 0.5
    private let thickBorderWidth: CGFloat = 2.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Rectangle()
                    .fill(colorScheme == .dark ? Color.black : Color.white)
                
                // Grid with cells
                VStack(spacing: 0) {
                    ForEach(0..<9) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<9) { column in
                                SudokuCellView(
                                    value: gameViewModel.board[row][column],
                                    isFixed: gameViewModel.fixedCells[row][column],
                                    isSelected: gameViewModel.selectedCell?.row == row && gameViewModel.selectedCell?.column == column,
                                    hasError: gameViewModel.cellHasError(row: row, column: column)
                                )
                                .onTapGesture {
                                    gameViewModel.selectCell(row: row, column: column)
                                }
                            }
                        }
                    }
                }
                
                // Draw the grid lines
                GridLinesView(
                    size: min(geometry.size.width, geometry.size.height),
                    thinWidth: thinBorderWidth,
                    thickWidth: thickBorderWidth
                )
            }
            .aspectRatio(1, contentMode: .fit)
            .frame(width: min(geometry.size.width, geometry.size.height))
            .position(
                x: geometry.size.width / 2,
                y: geometry.size.height / 2
            )
        }
    }
}

// Separate view for drawing grid lines
struct GridLinesView: View {
    let size: CGFloat
    let thinWidth: CGFloat
    let thickWidth: CGFloat
    
    var body: some View {
        ZStack {
            // Vertical lines
            ForEach(1..<9) { column in
                Rectangle()
                    .fill(Color.white)
                    .frame(
                        width: column % 3 == 0 ? thickWidth : thinWidth,
                        height: size
                    )
                    .position(
                        x: size / 9 * CGFloat(column),
                        y: size / 2
                    )
            }
            
            // Horizontal lines
            ForEach(1..<9) { row in
                Rectangle()
                    .fill(Color.white)
                    .frame(
                        width: size,
                        height: row % 3 == 0 ? thickWidth : thinWidth
                    )
                    .position(
                        x: size / 2,
                        y: size / 9 * CGFloat(row)
                    )
            }
            
            // Outer border
            Rectangle()
                .stroke(Color.white, lineWidth: thickWidth)
                .frame(width: size, height: size)
        }
    }
}

struct SudokuCellView: View {
    let value: Int?
    let isFixed: Bool
    let isSelected: Bool
    let hasError: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .fill(backgroundColor)
                
                if let value = value, value > 0 {
                    Text("\(value)")
                        .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.6))
                        .fontWeight(isFixed ? .bold : .regular)
                        .foregroundColor(textColor)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return Color.blue.opacity(0.3)
        } else if hasError {
            return Color.red.opacity(0.3)
        } else {
            return colorScheme == .dark ? Color.black : Color.white
        }
    }
    
    private var textColor: Color {
        if hasError {
            return Color.red
        } else if isFixed {
            return colorScheme == .dark ? Color.white : Color.black
        } else {
            return Color.blue
        }
    }
}