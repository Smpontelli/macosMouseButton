//
//  MainView.swift.swift
//  macosMouseButton
//
//  Created by Stéfano Modena Pontelli on 01/04/25.
//

import SwiftUI

struct MainView: View {
    @State private var scrollUpKey: String? = nil
    @State private var scrollDownKey: String? = nil
    @State private var isCapturingScrollUp = false
    @State private var isCapturingScrollDown = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Scroll Up")
                Button("Mapear") {
                    isCapturingScrollUp = true
                }
                Text(scrollUpKey ?? "Nenhuma tecla mapeada")
                    .frame(width: 150, alignment: .leading)
            }
            .padding()
            
            HStack {
                Text("Scroll Down")
                Button("Mapear") {
                    isCapturingScrollDown = true
                }
                Text(scrollDownKey ?? "Nenhuma tecla mapeada")
                    .frame(width: 150, alignment: .leading)
            }
            .padding()
        }
        .sheet(isPresented: $isCapturingScrollUp) {
            CaptureView { key in
                scrollUpKey = key
                isCapturingScrollUp = false
            }
            .onDisappear {
                isCapturingScrollUp = false
            }
        }
        .sheet(isPresented: $isCapturingScrollDown) {
            CaptureView { key in
                scrollDownKey = key
                isCapturingScrollDown = false
            }
            .onDisappear {
                isCapturingScrollDown = false
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
