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
            let key = event.charactersIgnoringModifiers ?? "?"
            print("Tecla pressionada no app: \(key)")
            keyPressed(key)
            return nil // <- Isso impede que o macOS emita o som padrão
        }
        return viewController
    }

    func updateNSViewController(_ nsViewController: NSViewController, context: Context) {}
}


