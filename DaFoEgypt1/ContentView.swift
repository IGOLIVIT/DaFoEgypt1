//
//  ContentView.swift
//  DaFoEgypt1
//
//  Created by IGOR on 29/08/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if isLoading {
                // Loading screen
                ZStack {
                    LinearGradient(
                        colors: [EgyptianColors.nightSky, EgyptianColors.desertSand],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        Text(EgyptianSymbols.ankh)
                            .font(.system(size: 80))
                            .foregroundColor(EgyptianColors.hieroglyphGold)
                        
                        Text("Eterna Egypt")
                            .font(EgyptianFonts.title())
                            .foregroundColor(EgyptianColors.textLight)
                        
                        Text("Loading ancient wisdom...")
                            .font(EgyptianFonts.body())
                            .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                    }
                }
            } else if appState.hasSeenOnboarding {
                MainTabView()
                    .environmentObject(appState)
            } else {
                OnboardingView()
                    .environmentObject(appState)
            }
        }
        .preferredColorScheme(.light)
        .onAppear {
            // Simulate loading time to ensure proper initialization
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
