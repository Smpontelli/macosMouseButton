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
    @State private var lastKey = "Nenhuma tecla pressionada"
    @State private var lastEscPressTime: TimeInterval = 0
    
    var body: some View {
        VStack {
            Text("Tecla Pressionada:")
                .font(.title)
            Text(lastKey)
                .font(.largeTitle)
                .padding()
            Text("Pressione ESC duas vezes para fechar")
                .font(.caption)
                .padding()
                .foregroundColor(.red)
            
            HStack {
                            Button("Cancelar") {
                                NSApplication.shared.keyWindow?.close() // Fecha a janela sem salvar
                            }
                            .keyboardShortcut(.cancelAction)

                            Button("Salvar") {
                                onSave(lastKey) // Envia a tecla escolhida para a janela principal
                            }
                            .keyboardShortcut(.defaultAction)
                        }
                        .padding()
        }
        .frame(width: 400, height: 300)
        .onAppear {
            startKeyMonitoring()
        }
    }

    func startKeyMonitoring() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            let key = getKeyFromKeyCode(event.keyCode)
            let modifiers = getModifiers(event.modifierFlags)
            let fullKey = modifiers.isEmpty ? key : "\(modifiers) + \(key)"
            lastKey = fullKey

            // Verifica se ESC foi pressionado duas vezes em menos de 1 segundo
            if key == "Escape" {
                let now = Date().timeIntervalSince1970
                if now - lastEscPressTime < 1.0 {
                    NSApplication.shared.keyWindow?.close() // Fecha a janela
                }
                lastEscPressTime = now
            }

            return nil
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { event in
            let modifiers = getModifiers(event.modifierFlags)
            if !modifiers.isEmpty {
                print("Modificador pressionado: \(modifiers)")
                lastKey = modifiers
            }
            return nil
        }
    }
    
    private func getModifiers(_ flags: NSEvent.ModifierFlags) -> String {
        var modifiers: [String] = []

        if flags.contains(.shift) {
            modifiers.append("Shift")
        }
        if flags.contains(.command) {
            modifiers.append("Command")
        }
        if flags.contains(.option) {
            modifiers.append("Option")
        }
        if flags.contains(.control) {
            modifiers.append("Control")
        }
        if flags.contains(.capsLock) {
            modifiers.append("CapsLock")
        }

        return modifiers.joined(separator: " + ")
    }

    func getKeyFromKeyCode(_ keyCode: UInt16) -> String {
        let keyMap: [UInt16: String] = [
            0x00: "A", 0x0B: "B", 0x08: "C", 0x02: "D", 0x0E: "E",
            0x03: "F", 0x05: "G", 0x04: "H", 0x22: "I", 0x26: "J",
            0x28: "K", 0x25: "L", 0x2E: "M", 0x2D: "N", 0x1F: "O",
            0x23: "P", 0x0C: "Q", 0x0F: "R", 0x01: "S", 0x11: "T",
            0x20: "U", 0x09: "V", 0x0D: "W", 0x07: "X", 0x10: "Y",
            0x06: "Z", 0x12: "1", 0x13: "2", 0x14: "3", 0x15: "4",
            0x17: "5", 0x16: "6", 0x1A: "7", 0x1C: "8", 0x19: "9",
            0x1D: "0", 0x1B: "-", 0x18: "=", 0x33: "Backspace",
            0x30: "Tab", 0x24: "Enter", 0x31: "Space", 0x35: "Escape",
            0x21: "[", 0x1E: "]", 0x2A: "\\", 0x27: ";", 0x29: "'",
            0x32: "`", 0x2B: ",", 0x2F: ".", 0x2C: "/"
        ]
        
        return keyMap[keyCode] ?? "Unknown"
    }
}
