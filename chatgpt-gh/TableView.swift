

//
//  TableView.swift
//  chatgpt-gh
//
//  Created by Nina Klee on 20.11.24.
//

import SwiftUI

struct TableView: View {
    let rows: Int = 12
    let columns: Int = 5
    let weekdays: [String] = ["Mo", "Di", "Mi", "Do", "Fr"]

    @State private var tableData: [[CellContent?]] = Array(
        repeating: Array(repeating: nil, count: 5), // 5 Spalten
        count: 12 // 12 Zeilen
    )
    @State private var showModal: Bool = false
    @State private var selectedRow: Int = 0
    @State private var selectedColumn: Int = 0
    @State private var showInfo: Bool = false
    @State private var showEditingView: Bool = false
    @State private var showDetailView: Bool = false // Steuert das Öffnen der ClassDetailView
    @State private var selectedCellContent: CellContent? = nil // Speichert die Zelleninformationen

    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Überschrift mit Info-Button
                    headerSection()

                    // Tabellenbereich
                    gridSection()

                    // Bearbeiten-Schaltfläche
                    Button(action: {
                        showEditingView = true // Navigation zur Bearbeitungsseite
                    }) {
                        Text("Bearbeiten")
                            .font(.headline)
                            .frame(maxWidth: .infinity) // Button über gesamte Breite
                            .padding() // Innenabstand
                            .background(Color.blue) // Hintergrundfarbe
                            .foregroundColor(.white) // Schriftfarbe
                            .cornerRadius(10) // Abgerundete Ecken
                    }
                    .padding(.top, 20) // Abstand nach oben
                    .padding([.leading, .trailing], 15) // Abstand zu den Seiten
                }
                .padding([.leading, .trailing], 15)
            }
        
        .sheet(isPresented: $showModal) {
            modalSheet() // Öffnet den ModalView für das Anlegen einer neuen Klasse
        }
        .sheet(isPresented: $showEditingView) {
            EditableTableView(tableData: $tableData, rows: rows, columns: columns) // Öffnet die Bearbeitungsansicht
        }
        .sheet(isPresented: $showDetailView) {
            if let cellContent = selectedCellContent {
                ClassDetailView(cellContent: cellContent) // Öffnet die Detailansicht für eine belegte Zelle
            }
        }
        
        .alert("Hinweis", isPresented: $showInfo) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Auf dieser Startseite bitte die Klassennamen anlegen.")
        }
        }
    }
    // MARK: - Header Section
    @ViewBuilder
    private func headerSection() -> some View {
        HStack {
            Spacer()
            Text("Stundenplan")
                .font(.largeTitle)
                .bold()
                .overlay(alignment: .topTrailing) {
                    Button(action: {
                        showInfo = true
                    }) {
                        Image(systemName: "info.circle")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .offset(x: 20, y: 5)
                    .buttonStyle(PlainButtonStyle())
                }
            Spacer()
        }
        .padding(.top, 20)
    }

    // MARK: - Grid Section

    @ViewBuilder
    private func gridSection() -> some View {
        LazyVGrid(columns: gridColumns, spacing: 5) {
            ForEach(0..<(rows + 1) * (columns + 1), id: \.self) { index in
                let row = index / (columns + 1)
                let column = index % (columns + 1)

                if row == 0 && column > 0 {
                    HeaderCell(text: weekdays[column - 1])
                        .frame(height: 60) // Einheitliche Höhe
                } else if column == 0 && row > 0 {
                    FirstColumnCell(text: "\(row)")
                        .frame(height: 60) // Einheitliche Höhe
                } else if row > 0 && column > 0 {
                    InteractiveCell(
                        row: row,
                        column: column,
                        content: tableData[row - 1][column - 1],
                        onTap: {
                            handleCellTap(row: row, column: column)
                        }
                    )
                } else {
                    Text("")
                        .frame(height: 60) // Einheitliche Höhe
                }
            }
        }
    }

    private func isValidIndex(row: Int, column: Int) -> Bool {
        return row > 0 && row <= rows && column > 0 && column <= columns
    }

    // MARK: - Modal Sheet
    @ViewBuilder
    private func modalSheet() -> some View {
        ModalView(
            row: selectedRow,
            column: selectedColumn,
            onSave: { className, room, subject, isSwitchOn, _ in // Ignoriere selectedHours
                updateCell(
                    row: selectedRow,
                    column: selectedColumn,
                    className: className,
                    room: room,
                    subject: subject,
                    isSwitchOn: isSwitchOn
                )
            }
        )
    }

    private func handleCellTap(row: Int, column: Int) {
        guard isValidIndex(row: row, column: column) else {
            print("Ungültiger Index: \(row), \(column)")
            return
        }

        if let cell = tableData[row - 1][column - 1], cell.className != nil {
            selectedCellContent = cell
            showDetailView = true
        } else {
            selectedRow = row
            selectedColumn = column
            showModal = true
        }
    }

    private func updateCell(
        row: Int,
        column: Int,
        className: String?,
        room: String? = nil,
        subject: String? = nil,
        isSwitchOn: Bool = false
    ) {
        guard isValidIndex(row: row, column: column) else {
            print("Ungültiger Index: \(row), \(column)")
            return
        }

        tableData[row - 1][column - 1] = CellContent(
            className: className,
            room: room,
            subject: subject,
            isSwitchOn: isSwitchOn
        )
    }

    // MARK: - Grid Columns Definition
    var gridColumns: [GridItem] {
        var columnsArray: [GridItem] = [GridItem(.fixed(50), spacing: 5)]
        for _ in 1...columns {
            columnsArray.append(GridItem(.flexible(), spacing: 5))
        }
        return columnsArray
    }
}
