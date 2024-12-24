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
            .font(.footnote) // Kleinere Schrift für Uhrzeiten
            .multilineTextAlignment(.center) // Mittige Ausrichtung
            .frame(width: 50, height: 60) // Breitere Zellen für die Uhrzeiten
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
    }

    static func timeForRow(_ row: Int) -> String {
        let times = [
            "07:45 - 08:30",
            "08:30 - 09:15",
            "09:35 - 10:20",
            "10:25 - 11:10",
            "11:20 - 12:05",
            "12:15 - 13:00",
            "13:10 - 13:55",
            "14:05 - 14:50",
            "15:00 - 15:45",
            "15:55 - 16:40",
            "16:50 - 17:35",
            "17:45 - 18:05"
        ]
        return row > 0 && row <= times.count ? times[row - 1] : "Ungültige Zeit"
    }

}
