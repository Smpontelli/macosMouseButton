//
//  macosMouseButtonApp.swift
//  macosMouseButton
//
//  Created by Stéfano Modena Pontelli on 01/04/25.
//

import SwiftUI

@main
struct macosMouseButtonApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true // Fecha o app completamente ao fechar a janela
    }

    func applicationWillTerminate(_ notification: Notification) {
        // Limpa qualquer monitor de evento ou outro recurso aqui
        print("App está encerrando. Limpando recursos...")

        // Se quiser encerrar mapeamentos ativos, você pode usar alguma variável global ou
        // NotificationCenter para avisar a `MainView` de remover o monitor
    }
}
