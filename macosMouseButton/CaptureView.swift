//
//  CaptureView.swift
//  macosMouseButton
//
//  Created by Stéfano Modena Pontelli on 01/04/25.
//

import SwiftUI
import AppKit

struct CaptureView: View {
    var onSave: (String) -> Void
    var onCancel: () -> Void

    @State private var capturedKey: String = "Pressione uma tecla..."
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            Text("Pressione a combinação de teclas")
                .font(.headline)
            Text(capturedKey)
                .font(.largeTitle)
                .padding()

            HStack {
                Button("Cancelar") {
                    onCancel()
                    presentationMode.wrappedValue.dismiss()
                }
                Button("Salvar") {
                    onSave(capturedKey)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(capturedKey == "Pressione uma tecla...")
            }
        }
        .frame(width: 400, height: 200)
        .onAppear {
            listenForKeyPress()
        }
    }

    private func listenForKeyPress() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            var keys: [String] = []

            if event.modifierFlags.contains(.command) { keys.append("Command") }
            if event.modifierFlags.contains(.control) { keys.append("Control") }
            if event.modifierFlags.contains(.option) { keys.append("Option") }
            if event.modifierFlags.contains(.shift) { keys.append("Shift") }

            if let characters = event.charactersIgnoringModifiers {
                let functionKeyMapping: [UInt16: String] = [
                    122: "F1", 120: "F2", 99: "F3", 118: "F4",
                    96: "F5", 97: "F6", 98: "F7", 100: "F8",
                    101: "F9", 109: "F10", 103: "F11", 111: "F12"
                ]

                if let functionKey = functionKeyMapping[event.keyCode] {
                    keys.append(functionKey)
                } else {
                    keys.append(characters.uppercased())
                }

                capturedKey = keys.joined(separator: " + ")
            }

            return nil // Consumir o evento
        }
    }
}
