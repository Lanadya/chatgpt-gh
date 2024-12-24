//
//  InteractiveCell.swift
//  chatgpt-gh
//
//  Created by Nina Klee on 20.11.24.
//

import SwiftUI


    struct InteractiveCell: View {
        let row: Int
        let column: Int
        let content: CellContent?
        let onTap: () -> Void

        var body: some View {
            Button(action: onTap) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(content == nil ? Color.gray.opacity(0.2) : Color.green.opacity(0.2))

                    VStack {
                        if let className = content?.className {
                            Text(className)
                                .lineLimit(1)
                        }
                        if let freeInput = content?.freeInput {
                            Text(freeInput)
                                .lineLimit(1)
                        }
                    }
                }
                .frame(height: 60) // Einheitliche Höhe
            }
        }
    }

    // MARK: - Hintergrundfarbe festlegen
    private func backgroundColor(for content: CellContent?) -> Color {
        if let _ = content?.className {
            return Color.green.opacity(0.5) // Hauptzellen
        } else if content != nil {
            return Color.green.opacity(0.3) // Folgezellen
        } else {
            return Color.gray.opacity(0.2) // Leere Zellen
        }
    }

