//
//  KeyListener.swift
//  macosMouseButton
//
//  Created by Stéfano Modena Pontelli on 01/04/25.
//

import Cocoa

class KeyListener {
    static let shared = KeyListener()
    private var eventMonitor: Any?

    func startListening(updateKey: @escaping (String) -> Void) {
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            let keyPressed = event.charactersIgnoringModifiers ?? "?"
            print("Tecla pressionada: \(keyPressed)")
            updateKey(keyPressed)
        }
    }

    deinit {
        if let eventMonitor = eventMonitor {
            NSEvent.removeMonitor(eventMonitor)
        }
    }
}

