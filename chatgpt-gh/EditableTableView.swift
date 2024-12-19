//
//  EditableTableView.swift
//  chatgpt-gh
//
//  Created by Nina Klee on 22.11.24.
//

import SwiftUI

struct EditableTableView: View {
    @Binding var tableData: [[CellContent?]] // Referenz auf die Daten
    let rows: Int
    let columns: Int

    var body: some View {
        NavigationView {
            List {
                // Iteriere über alle Zeilen und Spalten
                ForEach(0..<rows, id: \.self) { row in
                    Section(header: Text("Zeile \(row + 1)")) {
                        ForEach(0..<columns, id: \.self) { column in
                            HStack {
                                Text("Spalte \(column + 1):")
                                    .font(.subheadline)

                                Spacer()

                                if let content = tableData[row][column] {
                                    Text(content.className ?? "Keine Klasse")
                                        .foregroundColor(.blue)
                                } else {
                                    Text("Leer")
                                        .foregroundColor(.gray)
                                }

                                Button(action: {
                                    editCell(row: row, column: column)
                                }) {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Bearbeiten")
        }
    }

    private func editCell(row: Int, column: Int) {
        // Logik für Bearbeitung der Zelle hier
        print("Bearbeite Zelle: Zeile \(row), Spalte \(column)")
    }
}
