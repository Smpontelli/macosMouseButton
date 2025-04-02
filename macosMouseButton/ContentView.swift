//
//  ContentView.swift
//  macosMouseButton
//
//  Created by Stéfano Modena Pontelli on 01/04/25.
//

import SwiftUI

struct ContentView: View {
    @State private var lastKeyPressed: String = "Pressione uma tecla"

    var body: some View {
        VStack {
            Text(lastKeyPressed)
                .font(.largeTitle)
                .padding()

            KeyboardMonitor { key in
                lastKeyPressed = key
            }
        }
        .frame(width: 300, height: 200)
    }
}

#Preview {
    ContentView()
}



