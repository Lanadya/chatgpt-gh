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

            // freier Eintrag
            if let freeInput = cellContent.freeInput {
                Text("Raum: \(freeInput)")
                    .font(.title2)
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
