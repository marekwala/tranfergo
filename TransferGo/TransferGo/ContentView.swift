//
//  ContentView.swift
//  TransferGo
//
//  Created by Marek Wala on 13/07/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        /// ☕ TODO: Add Views, ViewModel, handling of error popup
        /// ☕ TODO: Add colors and images to Assets
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
