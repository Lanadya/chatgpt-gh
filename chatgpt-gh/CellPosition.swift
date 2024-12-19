//
//  CellPosition.swift
//  chatgpt-gh
//
//  Created by Nina Klee on 20.11.24.
//

import Foundation

public struct CellPosition: Identifiable, Equatable {
    public let id = UUID() // Eindeutige ID für Identifiable
    let row: Int // Zeilenindex
    let column: Int // Spaltenindex
}
