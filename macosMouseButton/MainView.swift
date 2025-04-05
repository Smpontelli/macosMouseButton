//
//  MainView.swift.swift
//  macosMouseButton
//
//  Created by Stéfano Modena Pontelli on 01/04/25.
//

import SwiftUI
import AppKit

struct MainView: View {
    @State private var scrollUpKey: String? = nil
    @State private var scrollDownKey: String? = nil
    @State private var captureTarget: CaptureTarget? = nil
    @State private var isMappingEnabled: Bool = false
    @State private var eventMonitor: Any? = nil

    enum CaptureTarget: Identifiable {
        case scrollUp
        case scrollDown

        var id: String {
            switch self {
            case .scrollUp: return "scrollUp"
            case .scrollDown: return "scrollDown"
            }
        }
    }

    var body: some View {
        VStack {
            Toggle("Ativar mapeamento de scroll", isOn: $isMappingEnabled)
                .padding()
                .onChange(of: isMappingEnabled) { enabled in
                    if enabled {
                        startMonitoring()
                    } else {
                        stopMonitoring()
                    }
                }

            HStack {
                Text("Scroll Up")
                Button("Mapear") {
                    captureTarget = .scrollUp
                }
                Text(scrollUpKey ?? "Nenhuma tecla mapeada")
                    .frame(width: 200, alignment: .leading)
            }
            .padding()

            HStack {
                Text("Scroll Down")
                Button("Mapear") {
                    captureTarget = .scrollDown
                }
                Text(scrollDownKey ?? "Nenhuma tecla mapeada")
                    .frame(width: 200, alignment: .leading)
            }
            .padding()
        }
        .sheet(item: $captureTarget) { target in
            CaptureView(onSave: { key in
                switch target {
                case .scrollUp:
                    scrollUpKey = key
                case .scrollDown:
                    scrollDownKey = key
                }
                captureTarget = nil
            }, onCancel: {
                captureTarget = nil
            })
        }
    }

    private func startMonitoring() {
        stopMonitoring()
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .scrollWheel) { event in
            handleScrollEvent(event)
        }
    }

    private func stopMonitoring() {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
    }

    private func handleScrollEvent(_ event: NSEvent) {
        guard isMappingEnabled else { return }

        if event.scrollingDeltaY > 0 {
            if let keyCombo = scrollUpKey {
                sendKeyCombo(keyCombo)
            }
        } else if event.scrollingDeltaY < 0 {
            if let keyCombo = scrollDownKey {
                sendKeyCombo(keyCombo)
            }
        }
    }

    private func sendKeyCombo(_ combo: String) {
        let keys = combo.components(separatedBy: " + ")

        let src = CGEventSource(stateID: .hidSystemState)
        var modifierFlags: CGEventFlags = []

        let keyCodes: [String: CGKeyCode] = [
            "Command": 0x37,
            "Shift": 0x38,
            "CapsLock": 0x39,
            "Option": 0x3A,
            "Control": 0x3B,
            "Return": 0x24,
            "Tab": 0x30,
            "Space": 0x31,
            "Delete": 0x33,
            "Escape": 0x35,
            "F1": 0x7A, "F2": 0x78, "F3": 0x63, "F4": 0x76,
            "F5": 0x60, "F6": 0x61, "F7": 0x62, "F8": 0x64,
            "F9": 0x65, "F10": 0x6D, "F11": 0x67, "F12": 0x6F,
            "A": 0x00, "B": 0x0B, "C": 0x08, "D": 0x02, "E": 0x0E,
            "F": 0x03, "G": 0x05, "H": 0x04, "I": 0x22, "J": 0x26,
            "K": 0x28, "L": 0x25, "M": 0x2E, "N": 0x2D, "O": 0x1F,
            "P": 0x23, "Q": 0x0C, "R": 0x0F, "S": 0x01, "T": 0x11,
            "U": 0x20, "V": 0x09, "W": 0x0D, "X": 0x07, "Y": 0x10,
            "Z": 0x06, "1": 0x12, "2": 0x13, "3": 0x14, "4": 0x15,
            "5": 0x17, "6": 0x16, "7": 0x1A, "8": 0x1C, "9": 0x19,
            "0": 0x1D, "-": 0x1B, "=": 0x18, ";": 0x27, "'": 0x29,
            ",": 0x2B, ".": 0x2F, "/": 0x2C, "[": 0x21, "]": 0x1E,
            "\\": 0x2A, "`": 0x32
        ]

        var mainKey: CGKeyCode? = nil

        for key in keys {
            switch key {
            case "Shift": modifierFlags.insert(.maskShift)
            case "Control": modifierFlags.insert(.maskControl)
            case "Option": modifierFlags.insert(.maskAlternate)
            case "Command": modifierFlags.insert(.maskCommand)
            case "CapsLock": modifierFlags.insert(.maskAlphaShift)
            default:
                if let code = keyCodes[key] {
                    mainKey = code
                }
            }
        }

        guard let keyCode = mainKey else { return }

        let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: true)
        keyDown?.flags = modifierFlags

        let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: false)
        keyUp?.flags = modifierFlags

        keyDown?.post(tap: .cghidEventTap)
        keyUp?.post(tap: .cghidEventTap)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
