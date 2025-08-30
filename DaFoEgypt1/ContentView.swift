//
//  ContentView.swift
//  DaFoEgypt1
//
//  Created by IGOR on 29/08/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()
    
    var body: some View {
        Group {
            if appState.hasSeenOnboarding {
                MainTabView()
                    .environmentObject(appState)
            } else {
                OnboardingView()
                    .environmentObject(appState)
            }
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
