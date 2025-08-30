//
//  MainTabView.swift
//  DaFoEgypt1
//
//  Created by IGOR on 29/08/2025.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var appState = AppState()
    @State private var selectedTab: MainTab = .selfDevelopment
    @State private var tabAnimation = false
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [EgyptianColors.desertSand, EgyptianColors.papyrus],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Header
                headerView
                
                // Content
                TabView(selection: $selectedTab) {
                    SelfDevelopmentView()
                        .environmentObject(appState)
                        .tag(MainTab.selfDevelopment)
                    
                    HistoryView()
                        .environmentObject(appState)
                        .tag(MainTab.history)
                    
                    GamesView()
                        .environmentObject(appState)
                        .tag(MainTab.games)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Custom Tab Bar
                customTabBar
            }
        }
        .environmentObject(appState)
    }
    
    @ViewBuilder
    private var headerView: some View {
        HStack {
            // Egyptian ornament
            Text(EgyptianSymbols.eye)
                .font(.system(size: 24))
                .foregroundColor(EgyptianColors.golden)
            
            Spacer()
            
            // App title
            Text("Eterna Egypt")
                .font(EgyptianFonts.title())
                .foregroundColor(EgyptianColors.textDark)
            
            Spacer()
            
            // Egyptian ornament
            Text(EgyptianSymbols.ankh)
                .font(.system(size: 24))
                .foregroundColor(EgyptianColors.golden)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 16)
        .background(
            Rectangle()
                .fill(EgyptianColors.papyrus)
                .shadow(
                    color: EgyptianColors.darkBrown.opacity(0.1),
                    radius: 4,
                    x: 0,
                    y: 2
                )
        )
    }
    
    @ViewBuilder
    private var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach(MainTab.allCases, id: \.self) { tab in
                tabBarItem(for: tab)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(EgyptianColors.darkBrown)
                .shadow(
                    color: EgyptianColors.darkBrown.opacity(0.3),
                    radius: 10,
                    x: 0,
                    y: -5
                )
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
    
    private func tabBarItem(for tab: MainTab) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedTab = tab
                tabAnimation.toggle()
            }
        }) {
            VStack(spacing: 8) {
                // Egyptian symbol
                Text(tab.egyptianIcon)
                    .font(.system(size: selectedTab == tab ? 28 : 24))
                    .foregroundColor(
                        selectedTab == tab ? 
                        EgyptianColors.hieroglyphGold : 
                        EgyptianColors.textLight.opacity(0.6)
                    )
                    .scaleEffect(selectedTab == tab ? 1.1 : 1.0)
                    .shadow(
                        color: selectedTab == tab ? 
                        EgyptianColors.hieroglyphGold.opacity(0.5) : 
                        Color.clear,
                        radius: selectedTab == tab ? 8 : 0
                    )
                
                // Tab title
                Text(tab.rawValue)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(
                        selectedTab == tab ? 
                        EgyptianColors.hieroglyphGold : 
                        EgyptianColors.textLight.opacity(0.6)
                    )
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        selectedTab == tab ? 
                        EgyptianColors.golden.opacity(0.2) : 
                        Color.clear
                    )
                    .animation(.easeInOut(duration: 0.3), value: selectedTab)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.3), value: selectedTab)
    }
}

#Preview {
    MainTabView()
}

