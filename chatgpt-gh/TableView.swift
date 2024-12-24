
import SwiftUI

struct TableView: View {
    let rows: Int = 12
    let columns: Int = 5
    let weekdays: [String] = ["Mo", "Di", "Mi", "Do", "Fr"]

    @State private var tableData: [[CellContent?]] = Array(
        repeating: Array(repeating: nil, count: 5),
        count: 12
    )

    @State private var showModal: Bool = false
    @State private var selectedRow: Int = 0
    @State private var selectedColumn: Int = 0
    @State private var showInfo: Bool = false
    @State private var showEditingView: Bool = false
    @State private var showDetailView: Bool = false
    @State private var selectedCellContent: CellContent? = nil
    @State private var keyboardHeight: CGFloat = 0
    @State private var activeSheet: ActiveSheet? = nil
    @FocusState private var isInputActive: Bool

    enum ActiveSheet: Identifiable {
        case modal
        case editing
        case detail

        var id: String {
            switch self {
            case .modal: return "modal"
            case .editing: return "editing"
            case .detail: return "detail"
            }
        }
    }


    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerSection()
                    gridSection()


                    .padding(.top, 20)
                    .padding([.leading, .trailing], 15)
                }
                .padding([.leading, .trailing], 15)
            } .onAppear {
                // Beobachte Tastaturereignisse
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                    if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                        keyboardHeight = keyboardFrame.height
                    }
                }

                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    keyboardHeight = 0
                }
            }
            .onDisappear {
                // Entferne Tastatur-Beobachter
                NotificationCenter.default.removeObserver(self)
            }



            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .modal:
                    ModalView(onSave: { className, freeInput in
                        updateCell(
                            row: selectedRow,
                            column: selectedColumn,
                            className: className,
                            freeInput: freeInput
                        )
                    })
                case .editing:
                    EditableTableView(tableData: $tableData, rows: rows, columns: columns)
                case .detail:
                    if let content = selectedCellContent {
                        ClassDetailView(cellContent: content)
                    }
                }
            }

            .alert("Hinweis", isPresented: $showInfo) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Auf dieser Startseite bitte die Klassennamen anlegen.")
            }
        }
    }

    @ViewBuilder
    private func headerSection() -> some View {
        HStack {
            Spacer()
            Text("Stundenplan")
                .font(.largeTitle)
                .bold()
            Spacer()
        }
        .padding(.top, 20)
    }

    private func rowAndColumn(for index: Int) -> (row: Int, column: Int) {
        let row = index / (columns + 1)  // Berechnet die Zeile
        let column = index % (columns + 1)  // Berechnet die Spalte
        return (row, column)  // Gibt ein Tuple mit Zeile und Spalte zurück
    }

    @ViewBuilder
    private func gridSection() -> some View {
        LazyVGrid(columns: gridColumns, spacing: 5) {
            ForEach(0..<(rows + 1) * (columns + 1), id: \.self) { index in
                let (row, column) = rowAndColumn(for: index)
                gridCell(row: row, column: column) // Aufruf von gridCell
            }
        }
    }

    
    @ViewBuilder
    private func gridCell(row: Int, column: Int) -> some View {
        if row == 0 && column > 0 {
            headerCell(for: column)
        } else if column == 0 && row > 0 {
            firstColumnCell(for: row)
        } else if row > 0 && column > 0 {
            contentCell(row: row, column: column)
        } else {
            Text("")
                .frame(height: 60)
        }
    }

    @ViewBuilder
    private func headerCell(for column: Int) -> some View {
        HeaderCell(text: weekdays[column - 1])
            .frame(height: 60)
    }

    @ViewBuilder
    private func firstColumnCell(for row: Int) -> some View {
        FirstColumnCell(text: FirstColumnCell.timeForRow(row))
            .frame(height: 60)
    }

    @ViewBuilder
    private func contentCell(row: Int, column: Int) -> some View {
        if let cellContent = tableData[row - 1][column - 1] {
            InteractiveCell(
                row: row,
                column: column,
                content: cellContent,
                onTap: {
                    handleCellTap(row: row, column: column)
                }
            )
        } else {
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(height: 60)
                .overlay(
                    Text("+")
                        .foregroundColor(.gray)
                        .font(.headline)
                )
                .onTapGesture {
                    handleCellTap(row: row, column: column)
                }
        }
    }


    var gridColumns: [GridItem] {
        var columnsArray: [GridItem] = [GridItem(.fixed(50), spacing: 5)]
        for _ in 1...columns {
            columnsArray.append(GridItem(.flexible(), spacing: 5))
        }
        return columnsArray
    }

    @ViewBuilder
    private func modalSheet() -> some View {
        ModalView(
            onSave: { className, freeInput in
                updateCell(
                    row: selectedRow,
                    column: selectedColumn,
                    className: className,
                    freeInput: freeInput
                )
            }
        )
        .frame(maxHeight: .infinity, alignment: .top)
    }

    private func handleCellTap(row: Int, column: Int) {
        guard isValidIndex(row: row, column: column) else {
            print("Fehler: Ungültiger Index bei [\(row - 1), \(column - 1)]")
            return
        }

        if let cell = tableData[row - 1][column - 1], cell.className != nil {
            print("Detailansicht öffnen für Zelle [\(row - 1), \(column - 1)] mit Inhalt: \(cell)")
            selectedCellContent = cell
            activeSheet = .detail
           // showDetailView = true
        } else {
            print("Öffne Modal für Zelle [\(row), \(column)]")
            selectedRow = row
            selectedColumn = column
            activeSheet = .modal
          //  showModal = true
        }
    }

    private func updateCell(row: Int, column: Int, className: String?, freeInput: String?) {
        guard isValidIndex(row: row, column: column) else {
            print("Fehler: Ungültiger Index [\(row), \(column)]")
            return
        }

        print("Debug: Schreibe in Zelle [\(row), \(column)] - Klassenname: \(className ?? "Keine Klasse"), Notiz: \(freeInput ?? "Keine Notiz")")
        tableData[row - 1][column - 1] = CellContent(
            className: className,
            freeInput: freeInput
        )
    }

    private func isValidIndex(row: Int, column: Int) -> Bool {
        let isValid = row > 0 && row <= rows && column > 0 && column <= columns
        if !isValid {
            print("Fehler: Index nicht gültig - row: \(row), column: \(column)")
        }
        return isValid
    }
}
