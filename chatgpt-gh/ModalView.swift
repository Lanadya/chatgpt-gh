import SwiftUI

struct ModalView: View {
    @Environment(\.dismiss) var dismiss

    @State private var className: String = ""
    @State private var freeInput: String = "" // Zurück zu freeInput
    @State private var showClassNameError: Bool = false
    @FocusState private var focusedField: FocusField?

    var onSave: (String, String) -> Void

    enum FocusField {
        case className
        case freeInput
    }

    var body: some View {
        VStack(spacing: 20) {
            // Überschrift
            Text("Neue Klasse anlegen")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 20)

            VStack(spacing: 30) {
                Spacer()

                // Klassenname
                VStack(alignment: .leading, spacing: 8) {
                    Text("Klassenname")
                        .font(.headline)
                        .bold()

                    TextField("Max. 8 Zeichen", text: $className)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    className.isEmpty ? Color.red : Color.blue,
                                    lineWidth: 2
                                )
                        )
                        .font(.title2)
                        .focused($focusedField, equals: .className)
                        .onChange(of: className) { newValue in
                            if newValue.count > 8 {
                                className = String(newValue.prefix(8))
                            }
                        }
                }

                // Notizen (freeInput)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notizen (optional)")
                        .font(.subheadline)

                    TextEditor(text: $freeInput)
                        .frame(height: 40)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .focused($focusedField, equals: .freeInput)
                        .font(.body)
                        .onChange(of: freeInput) { newValue in
                            if newValue.count > 10 {
                                freeInput = String(newValue.prefix(10))
                            }
                        }
                }
            }

            Spacer()

            // Buttons
            VStack(spacing: 12) {
                Button(action: {
                    if className.isEmpty {
                        showClassNameError = true
                    } else {
                        onSave(className, freeInput)
                        dismiss()
                    }
                }) {
                    Text("Speichern")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(className.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .font(.headline)
                }
                .disabled(className.isEmpty)

                Button(action: {
                    dismiss()
                }) {
                    Text("Abbrechen")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.blue)
                        .font(.subheadline)
                }
            }
            .padding(.top, 20)
        }
        .padding(16)
        .frame(maxWidth: 260)
        .onAppear {
            focusedField = .className
        }
    }
}

//
//struct ModalView: View {
//    @Environment(\.dismiss) var dismiss
//
//    @State private var className: String = ""
//    @State private var notesInput: String = ""
//    @State private var showClassNameError: Bool = false
//    @FocusState private var focusedField: FocusField?
//
//    var onSave: (String, String) -> Void
//
//    enum FocusField {
//        case className
//        case notes
//    }
//
//    var body: some View {
//        VStack(spacing: 20) {
//            // Überschrift
//            Text("Neue Klasse anlegen")
//                .font(.title2)
//                .fontWeight(.bold)
//                .multilineTextAlignment(.center)
//                .padding(.top, 20)
//
//            VStack(spacing: 30) {
//                Spacer()
//
//                // Klassenname
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("Klassenname")
//                        .font(.headline)
//                        .bold()
//
//                    TextField("Max. 8 Zeichen", text: $className)
//                        .padding(10)
//                        .background(
//                            RoundedRectangle(cornerRadius: 8)
//                                .stroke(
//                                    className.isEmpty ? Color.red : Color.blue,
//                                    lineWidth: 2
//                                )
//                        )
//                        .font(.title2)
//                        .focused($focusedField, equals: .className)
//                        .onChange(of: className) { newValue in
//                            if newValue.count > 8 {
//                                className = String(newValue.prefix(8))
//                            }
//                        }
//
//                    // Notizen
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text("Notizen (optional)")
//                            .font(.subheadline)
//
//                        TextEditor(text: $notesInput)
//                            .frame(height: 40)
//                            .padding(10)
//                            .background(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .stroke(Color.gray, lineWidth: 1)
//                            )
//                            .focused($focusedField, equals: .notes)
//                            .font(.body)
//                            .onChange(of: notesInput) { newValue in
//                                if newValue.count > 10 {
//                                    notesInput = String(newValue.prefix(10))
//                                }
//                            }
//                    }
//                }
//
//                Spacer()
//
//                // Buttons
//                VStack(spacing: 12) {
//                    Button(action: {
//                        if className.isEmpty {
//                            showClassNameError = true
//                        } else {
//                            onSave(className, notesInput)
//                            dismiss()
//                        }
//                    }) {
//                        Text("Speichern")
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(className.isEmpty ? Color.gray : Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                            .font(.headline)
//                    }
//                    .disabled(className.isEmpty)
//
//                    Button(action: {
//                        dismiss()
//                    }) {
//                        Text("Abbrechen")
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .foregroundColor(.blue)
//                            .font(.subheadline)
//                    }
//                }
//                .padding(.top, 20)
//            }
//            .padding(16) // Einheitliches Padding
//            .frame(maxWidth: 260) // Modalbreite
//            .onAppear {
//                focusedField = .className // Fokus auf Klassenname beim Öffnen
//            }
//        }
//    }
//}
//
