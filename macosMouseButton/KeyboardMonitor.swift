//
//  KeyboardMonitor.swift
//  macosMouseButton
//
//  Created by Stéfano Modena Pontelli on 01/04/25.
//

import SwiftUI
import AppKit

struct KeyboardMonitor: NSViewControllerRepresentable {
    var keyPressed: (String) -> Void

    func makeNSViewController(context: Context) -> NSViewController {
        let viewController = NSViewController()
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            let key = getKeyFromKeyCode(event.keyCode) // Agora usamos o código da tecla
            let modifiers = getModifiers(event.modifierFlags)
            let fullKey = modifiers.isEmpty ? key : "\(modifiers) + \(key)"
            
            print("Tecla pressionada no app: \(fullKey)")
            keyPressed(fullKey)

            return nil // Evita o som do macOS
        }
        return viewController
    }

    func updateNSViewController(_ nsViewController: NSViewController, context: Context) {}

    /// Função para obter os modificadores pressionados
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

    /// Função para mapear os códigos das teclas
    private func getKeyFromKeyCode(_ keyCode: UInt16) -> String {
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
