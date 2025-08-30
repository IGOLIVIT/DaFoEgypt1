//
//  OnboardingView.swift
//  DaFoEgypt1
//
//  Created by IGOR on 29/08/2025.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentStep: OnboardingStep = .welcome
    @State private var showAnkh = false
    @State private var showPyramids = false
    @State private var showHieroglyphs = false
    @State private var glowIntensity: Double = 0.0
    @State private var pyramidOffset: CGFloat = 200
    @State private var textOpacity: Double = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        EgyptianColors.nightSky,
                        EgyptianColors.darkBrown,
                        EgyptianColors.desertSand
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Animated background elements
                backgroundAnimations(geometry: geometry)
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Main content
                    onboardingContent
                    
                    Spacer()
                    
                    // Navigation buttons
                    navigationButtons
                }
                .padding(.horizontal, 32)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    @ViewBuilder
    private func backgroundAnimations(geometry: GeometryProxy) -> some View {
        ZStack {
            // Animated Ankh
            if showAnkh {
                Text(EgyptianSymbols.ankh)
                    .font(.system(size: 120))
                    .foregroundColor(EgyptianColors.hieroglyphGold)
                    .opacity(0.3)
                    .scaleEffect(showAnkh ? 1.0 : 0.1)
                    .rotationEffect(.degrees(showAnkh ? 0 : 180))
                    .shadow(
                        color: EgyptianColors.hieroglyphGold.opacity(glowIntensity),
                        radius: 20
                    )
                    .position(
                        x: geometry.size.width * 0.5,
                        y: geometry.size.height * 0.3
                    )
                    .animation(.easeInOut(duration: 2.0), value: showAnkh)
            }
            
            // Animated Pyramids
            if showPyramids {
                HStack(spacing: 20) {
                    ForEach(0..<3, id: \.self) { index in
                        Text(EgyptianSymbols.pyramid)
                            .font(.system(size: 60 - CGFloat(index * 10)))
                            .foregroundColor(EgyptianColors.pyramidStone)
                            .opacity(0.4)
                            .offset(y: pyramidOffset)
                            .animation(
                                .easeOut(duration: 1.5)
                                .delay(Double(index) * 0.3),
                                value: pyramidOffset
                            )
                    }
                }
                .position(
                    x: geometry.size.width * 0.5,
                    y: geometry.size.height * 0.7
                )
            }
            
            // Floating Hieroglyphs
            if showHieroglyphs {
                ForEach(0..<5, id: \.self) { index in
                    Text([EgyptianSymbols.eye, EgyptianSymbols.scarab, EgyptianSymbols.lotus, "𓂋", "𓈖"][index])
                        .font(.system(size: 30))
                        .foregroundColor(EgyptianColors.golden.opacity(0.6))
                        .position(
                            x: geometry.size.width * Double.random(in: 0.1...0.9),
                            y: geometry.size.height * Double.random(in: 0.2...0.8)
                        )
                        .opacity(showHieroglyphs ? 1.0 : 0.0)
                        .scaleEffect(showHieroglyphs ? 1.0 : 0.1)
                        .animation(
                            .easeInOut(duration: 1.0)
                            .delay(Double(index) * 0.2),
                            value: showHieroglyphs
                        )
                }
            }
        }
    }
    
    @ViewBuilder
    private var onboardingContent: some View {
        VStack(spacing: 30) {
            // Title
            Text(currentStep.title)
                .font(EgyptianFonts.title())
                .foregroundColor(EgyptianColors.textLight)
                .multilineTextAlignment(.center)
                .opacity(textOpacity)
                .animation(.easeInOut(duration: 1.0), value: textOpacity)
            
            // Description
            Text(currentStep.description)
                .font(EgyptianFonts.body())
                .foregroundColor(EgyptianColors.textLight.opacity(0.9))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .opacity(textOpacity)
                .animation(.easeInOut(duration: 1.0).delay(0.3), value: textOpacity)
            
            // Step-specific content
            stepSpecificContent
                .opacity(textOpacity)
                .animation(.easeInOut(duration: 1.0).delay(0.6), value: textOpacity)
        }
    }
    
    @ViewBuilder
    private var stepSpecificContent: some View {
        switch currentStep {
        case .welcome:
            VStack(spacing: 16) {
                Text("🏺 Ancient Wisdom Awaits 🏺")
                    .font(EgyptianFonts.headline())
                    .foregroundColor(EgyptianColors.hieroglyphGold)
            }
            
        case .features:
            VStack(spacing: 20) {
                featureRow(
                    icon: EgyptianSymbols.meditation,
                    title: "Meditate",
                    description: "Find inner peace with Egyptian-inspired meditation"
                )
                
                featureRow(
                    icon: EgyptianSymbols.history,
                    title: "Learn",
                    description: "Discover the secrets of ancient Egypt"
                )
                
                featureRow(
                    icon: EgyptianSymbols.games,
                    title: "Play",
                    description: "Enjoy games inspired by Egyptian culture"
                )
            }
            
        case .ready:
            VStack(spacing: 16) {
                Text(EgyptianSymbols.ankh)
                    .font(.system(size: 80))
                    .foregroundColor(EgyptianColors.hieroglyphGold)
                    .shadow(
                        color: EgyptianColors.hieroglyphGold.opacity(0.5),
                        radius: 10
                    )
                
                Text("May the gods guide your path")
                    .font(EgyptianFonts.caption())
                    .foregroundColor(EgyptianColors.golden)
                    .italic()
            }
        }
    }
    
    private func featureRow(icon: String, title: String, description: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(EgyptianColors.golden)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(EgyptianFonts.headline())
                    .foregroundColor(EgyptianColors.textLight)
                
                Text(description)
                    .font(EgyptianFonts.caption())
                    .foregroundColor(EgyptianColors.textLight.opacity(0.8))
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private var navigationButtons: some View {
        HStack(spacing: 20) {
            if currentStep != .welcome {
                Button("Previous") {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        previousStep()
                    }
                }
                .egyptianButton(secondary: true)
            }
            
            Spacer()
            
            Button(currentStep == .ready ? "Begin Journey" : "Next") {
                withAnimation(.easeInOut(duration: 0.5)) {
                    if currentStep == .ready {
                        appState.completeOnboarding()
                    } else {
                        nextStep()
                    }
                }
            }
            .egyptianButton()
        }
        .opacity(textOpacity)
        .animation(.easeInOut(duration: 1.0).delay(0.9), value: textOpacity)
    }
    
    private func startAnimations() {
        // Start with ankh animation
        withAnimation(.easeInOut(duration: 2.0)) {
            showAnkh = true
            textOpacity = 1.0
        }
        
        // Add glow effect
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            glowIntensity = 0.8
        }
        
        // Show pyramids after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeOut(duration: 1.5)) {
                showPyramids = true
                pyramidOffset = 0
            }
        }
        
        // Show hieroglyphs after another delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 1.0)) {
                showHieroglyphs = true
            }
        }
    }
    
    private func nextStep() {
        let nextStepValue = OnboardingStep(rawValue: currentStep.rawValue + 1) ?? .ready
        currentStep = nextStepValue
        
        // Reset and restart animations for new step
        resetAnimations()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            startAnimations()
        }
    }
    
    private func previousStep() {
        let previousStepValue = OnboardingStep(rawValue: currentStep.rawValue - 1) ?? .welcome
        currentStep = previousStepValue
        
        // Reset and restart animations for new step
        resetAnimations()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            startAnimations()
        }
    }
    
    private func resetAnimations() {
        textOpacity = 0.0
        showAnkh = false
        showPyramids = false
        showHieroglyphs = false
        pyramidOffset = 200
        glowIntensity = 0.0
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
}
