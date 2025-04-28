import SwiftUI

struct SudokuGridView: View {
    @ObservedObject var gameViewModel: SudokuGameViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<9) { row in
                HStack(spacing: 0) {
                    ForEach(0..<9) { column in
                        SudokuCellView(
                            value: gameViewModel.board[row][column],
                            isFixed: gameViewModel.fixedCells[row][column],
                            isSelected: gameViewModel.selectedCell?.row == row && gameViewModel.selectedCell?.column == column,
                            hasError: gameViewModel.cellHasError(row: row, column: column),
                            inSameRowColAs: isSameRowColAs(row: row, column: column),
                            inSameBoxAs: isSameBoxAs(row: row, column: column),
                            colorScheme: colorScheme
                        )
                        .onTapGesture {
                            gameViewModel.selectCell(row: row, column: column)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .overlay(
                            Rectangle()
                                .stroke(getBorderColor(), lineWidth: getBorderWidth(row: row, column: column))
                        )
                        .animation(.easeInOut(duration: 0.2), value: gameViewModel.selectedCell)
                    }
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .padding()
        .background(
            Rectangle()
                .stroke(getBorderColor(), lineWidth: 3)
        )
    }
    
    // Check if cell is in same row or column as selected cell
    private func isSameRowColAs(row: Int, column: Int) -> Bool {
        guard let selectedCell = gameViewModel.selectedCell else { return false }
        return selectedCell.row == row || selectedCell.column == column
    }
    
    // Check if cell is in same 3x3 box as selected cell
    private func isSameBoxAs(row: Int, column: Int) -> Bool {
        guard let selectedCell = gameViewModel.selectedCell else { return false }
        let selectedBoxRow = selectedCell.row / 3
        let selectedBoxCol = selectedCell.column / 3
        let cellBoxRow = row / 3
        let cellBoxCol = column / 3
        return selectedBoxRow == cellBoxRow && selectedBoxCol == cellBoxCol
    }

    private func getBorderColor() -> Color {
        return colorScheme == .dark ? Color.white : Color.black
    }

    private func getBorderWidth(row: Int, column: Int) -> CGFloat {
        // Outer borders
        if row == 0 || row == 8 || column == 0 || column == 8 {
            return 2
        }
        
        // Box borders
        if row % 3 == 2 && row < 8 {
            return 2
        }
        if column % 3 == 2 && column < 8 {
            return 2
        }
        
        return 0.5
    }
}

struct SudokuCellView: View {
    let value: Int?
    let isFixed: Bool
    let isSelected: Bool
    let hasError: Bool
    let inSameRowColAs: Bool
    let inSameBoxAs: Bool
    let colorScheme: ColorScheme
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)
                .animation(.easeInOut(duration: 0.2), value: isSelected)
                .animation(.easeInOut(duration: 0.2), value: hasError)
            
            if let value = value, value > 0 {
                Text("\(value)")
                    .font(.title)
                    .fontWeight(isFixed ? .bold : .regular)
                    .foregroundColor(textColor)
            }
        }
        .accessibilityLabel(accessibilityLabel)
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return Color.blue.opacity(0.4)
        } else if hasError {
            return Color.red.opacity(0.3)
        } else if inSameRowColAs {
            return Color.blue.opacity(0.1)
        } else if inSameBoxAs {
            return Color.blue.opacity(0.05)
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
    
    private var accessibilityLabel: String {
        var label = ""
        
        if let value = value {
            label += "Value \(value). "
        } else {
            label += "Empty cell. "
        }
        
        if isFixed {
            label += "Fixed. "
        }
        
        if hasError {
            label += "Error. "
        }
        
        if isSelected {
            label += "Selected. "
        }
        
        return label
    }
}