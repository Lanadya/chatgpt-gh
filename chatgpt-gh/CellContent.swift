//
//  CellContent.swift
//  chatgpt-gh
//
//  Created by Nina Klee on 20.11.24.
//

import SwiftUI

struct CellContent {
    var className: String?
    var room: String?
    var subject: String?
    var isSwitchOn: Bool
}

// Beispiel für Preview
let exampleCellContent = CellContent(
    className: "1A",
    room: "101",
    subject: "Mathematik",
    isSwitchOn: true
)
