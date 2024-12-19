//
//  ClassDetailView.swift
//  chatgpt-gh
//
//  Created by Nina Klee on 22.11.24.
//

import SwiftUI

struct ClassDetailView: View {
    let cellContent: CellContent // Erwartet ein CellContent-Objekt

    var body: some View {
        VStack(spacing: 20) {
            // Klassenname
            Text(cellContent.className ?? "Unbekannte Klasse")
                .font(.largeTitle)
                .bold()

            // Raum
            if let room = cellContent.room {
                Text("Raum: \(room)")
                    .font(.title2)
            }

            // Fach
            if let subject = cellContent.subject {
                Text("Fach: \(subject)")
                    .font(.title2)
            }

            // Klassenbuch-Status
            if cellContent.isSwitchOn {
                Text("Klassenbuch mitbringen")
                    .font(.headline)
                    .foregroundColor(.green)
            } else {
                Text("Kein Klassenbuch erforderlich")
                    .font(.headline)
                    .foregroundColor(.red)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Details zur Klasse")
    }
}

#Preview {
    ClassDetailView(cellContent: exampleCellContent)
}
