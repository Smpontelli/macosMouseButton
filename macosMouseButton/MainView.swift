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
    @State private var captureTarget: CaptureTarget? = nil

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
            HStack {
                Text("Scroll Up")
                Button("Mapear") {
                    captureTarget = .scrollUp
                }
                Text(scrollUpKey ?? "Nenhuma tecla mapeada")
                    .frame(width: 150, alignment: .leading)
            }
            .padding()

            HStack {
                Text("Scroll Down")
                Button("Mapear") {
                    captureTarget = .scrollDown
                }
                Text(scrollDownKey ?? "Nenhuma tecla mapeada")
                    .frame(width: 150, alignment: .leading)
            }
            .padding()
        }
        .sheet(item: $captureTarget) { target in
            CaptureView { key in
                switch target {
                case .scrollUp:
                    scrollUpKey = key
                case .scrollDown:
                    scrollDownKey = key
                }
                captureTarget = nil
            } onCancel: {
                captureTarget = nil
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
