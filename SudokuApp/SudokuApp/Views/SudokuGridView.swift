import SwiftUI

struct SudokuGridView: View {
    @ObservedObject var gameViewModel: SudokuGameViewModel
    
    var body: some View {
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
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .border(getBorderColor(row: row, column: column), width: getBorderWidth(row: row, column: column))
                    }
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .padding()
    }
    
    private func getBorderColor(row: Int, column: Int) -> Color {
        return Color.black
    }
    
    private func getBorderWidth(row: Int, column: Int) -> CGFloat {
        var width: CGFloat = 1
        
        // Thicker borders for 3x3 grid sections
        if row % 3 == 0 && row > 0 {
            width = 2
        }
        if column % 3 == 0 && column > 0 {
            width = 2
        }
        
        return width
    }
}

struct SudokuCellView: View {
    let value: Int?
    let isFixed: Bool
    let isSelected: Bool
    let hasError: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)
            
            if let value = value, value > 0 {
                Text("\(value)")
                    .font(.title)
                    .fontWeight(isFixed ? .bold : .regular)
                    .foregroundColor(textColor)
            }
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return Color.blue.opacity(0.3)
        } else if hasError {
            return Color.red.opacity(0.3)
        } else {
            return Color.white
        }
    }
    
    private var textColor: Color {
        if hasError {
            return Color.red
        } else if isFixed {
            return Color.black
        } else {
            return Color.blue
        }
    }
}