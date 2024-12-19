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
                        if let room = content?.room {
                            Text(room)
                                .lineLimit(1)
                        }
                    }
                }
                .frame(height: 60) // Einheitliche Höhe
            }
        }
    }
//    var body: some View {
//        Button(action: {
//            onTap()
//        }) {
//            ZStack {
//                // Hintergrundfarbe basierend auf dem Zustand der Zelle
//                RoundedRectangle(cornerRadius: 8)
//                    .fill(backgroundColor(for: content))
//
//                VStack(alignment: .center, spacing: 8) { // Zentrierte Inhalte
//                    if let className = content?.className {
//                        Text(className)
//                            .font(.headline)
//                            .bold()
//                            .foregroundColor(.black)
//                            .lineLimit(1) // Begrenze auf eine Zeile
//                    }
//
//                    if let room = content?.room, !room.isEmpty {
//                        Text(room)
//                            .font(.caption)
//                            .foregroundColor(.black)
//                            .lineLimit(1) // Begrenze auf eine Zeile
//                    }
//
//                    if let subject = content?.subject, !subject.isEmpty {
//                        Text(subject)
//                            .font(.caption)
//                            .foregroundColor(.black)
//                            .lineLimit(1) // Begrenze auf eine Zeile
//                    }
//                }
//                .padding(8)
//                .frame(height: 60) // Einheitliche Höhe für die gesamte Zelle
//                .padding(8)
//
//            }
//            .frame(maxWidth: .infinity, minHeight: 70)
//        }
//        .buttonStyle(PlainButtonStyle())
//    }

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

