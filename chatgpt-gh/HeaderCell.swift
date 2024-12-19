//
//  HeaderCell.swift
//  chatgpt-gh
//
//  Created by Nina Klee on 20.11.24.
//

import SwiftUI

struct HeaderCell: View {
    let text: String

    var body: some View {
        Text(text)
            .frame(maxWidth: .infinity)
            .frame(height: 60) // Separat definierte Höhe
            .background(Color.blue.opacity(0.2))
            .cornerRadius(8)
    }
}
