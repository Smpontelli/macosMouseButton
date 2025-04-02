//
//  MainView.swift.swift
//  macosMouseButton
//
//  Created by Stéfano Modena Pontelli on 01/04/25.
//

import SwiftUI

struct MainView: View {
    @State private var windowController: NSWindowController?

    var body: some View {
        VStack {
            Text("Pressione o botão para capturar teclas")
                .padding()
            
            Button("Abrir Captura") {
                openCaptureWindow()
            }
            .padding()
        }
        .frame(width: 300, height: 200)
    }

    func openCaptureWindow() {
        let captureView = CaptureView()
        let hostingController = NSHostingController(rootView: captureView)

        let window = NSWindow(
            contentViewController: hostingController
        )
        window.setContentSize(NSSize(width: 400, height: 300))
        window.styleMask = [.titled, .closable, .resizable]
        window.title = "Captura de Teclas"
        window.makeKeyAndOrderFront(nil)

        windowController = NSWindowController(window: window)
    }
}
