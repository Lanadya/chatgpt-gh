//
//  FirstColumnCell.swift
//  chatgpt-gh
//
//  Created by Nina Klee on 20.11.24.
//

import SwiftUI

struct FirstColumnCell: View {
    let text: String

    var body: some View {
        Text(text)
            .frame(width: 50, height: 60) // Einheitliche Höhe
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
    }
}
