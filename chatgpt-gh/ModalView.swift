//
//  ModalView.swift
//  chatgpt-gh
//
//  Created by Nina Klee on 20.11.24.
//

import SwiftUI

struct ModalView: View {
    @Environment(\.dismiss) var dismiss

    let row: Int
    let column: Int

    @State private var className: String = "" // Klassenname
    @State private var room: String = "" // Raum (optional)
    @State private var subject: String = "" // Fach (optional)
    @State private var attachClassBook: Bool = false // Toggle-Status für Klassenbuch
    @State private var selectedHours: [Int] = [] // Folgestunden-Auswahl
    @State private var showError: Bool = false // Fehlerstatus
    @State private var showInfo: Bool = false // Status für das Info-Popup

    var maxHours: Int = 4 // Maximale Anzahl der Folgestunden
    var onSave: (String, String?, String?, Bool, [Int]) -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                // Klassenname mit Info-Symbol
                HStack(spacing: 5) {
                    Text("Klassenname")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.red) // Optische Hervorhebung
                    Button(action: {
                        showInfo = true
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.red)
                            .font(.headline)
                    }
                    .alert("Hinweis", isPresented: $showInfo) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text("Bitte einen Klassennamen eingeben. Dieser ist erforderlich, um die Daten zu speichern.")
                    }
                    Spacer()
                }
                .padding(.bottom, 2)

                TextField("Klasse (z. B. 1A)", text: $className)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.bottom, 15)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            UIApplication.shared.sendAction(
                                #selector(UIResponder.becomeFirstResponder),
                                to: nil,
                                from: nil,
                                for: nil
                            )
                        }
                    }

                // Optionale Angaben
                VStack(spacing: 8) {
                    Text("Optionale Angaben")
                        .font(.subheadline)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)

                    TextField("Raum (optional)", text: $room)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Fach (optional)", text: $subject)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.bottom, 15)

                // Toggle für Klassenbuch
                HStack {
                    Text("Klassenbuch mitbringen")
                        .font(.subheadline)
                        .bold()
                    Spacer()
                    Toggle("", isOn: $attachClassBook)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                }
                .padding(.bottom, 20)

                // Speichern- und Abbrechen-Buttons
                VStack(spacing: 10) {
                    Button(action: {
                        if className.isEmpty {
                            showError = true
                        } else {
                            saveChanges()
                        }
                    }) {
                        Text("Speichern")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(className.isEmpty ? Color.gray : Color.blue) // Deaktivieren bei leerem Klassennamen
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .disabled(className.isEmpty)
                    }
                    .alert("Fehler", isPresented: $showError) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text("Der Klassenname muss ausgefüllt werden.")
                    }

                    Button(action: {
                        dismiss()
                    }) {
                        Text("Abbrechen")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
    }

    private func saveChanges() {
        onSave(
            className,
            room.isEmpty ? nil : room,
            subject.isEmpty ? nil : subject,
            attachClassBook,
            selectedHours
        )
        dismiss()
    }
}
