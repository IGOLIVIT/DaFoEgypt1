//
//  MindTrainingDetailView.swift
//  DaFoEgypt1
//
//  Created by IGOR on 29/08/2025.
//

import SwiftUI

struct MindTrainingDetailView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    let card: MindTrainingCard
    
    @State private var isCompleted = false
    @State private var showCompletion = false
    @State private var animateIcon = false
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    colors: [
                        card.category.color.opacity(0.1),
                        EgyptianColors.papyrus,
                        EgyptianColors.desertSand.opacity(0.3)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        headerView
                        
                        // Task description
                        taskDescriptionView
                        
                        // Action steps
                        actionStepsView
                        
                        // Notes section
                        notesSection
                        
                        // Completion button
                        completionButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .onAppear {
            startAnimations()
        }
        .sheet(isPresented: $showCompletion) {
            MindTrainingCompletionView(card: card)
                .environmentObject(appState)
        }
    }
    
    @ViewBuilder
    private var headerView: some View {
        VStack(spacing: 20) {
            // Close button
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(EgyptianColors.textDark.opacity(0.6))
                }
                
                Spacer()
            }
            
            // Icon and category
            VStack(spacing: 16) {
                Text(card.icon)
                    .font(.system(size: 80))
                    .scaleEffect(animateIcon ? 1.1 : 1.0)
                    .animation(
                        .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                        value: animateIcon
                    )
                
                Text(card.category.rawValue)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(card.category.color)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(card.category.color.opacity(0.2))
                    )
            }
            
            // Title
            Text(card.title)
                .font(EgyptianFonts.title())
                .foregroundColor(EgyptianColors.textDark)
                .multilineTextAlignment(.center)
        }
    }
    
    @ViewBuilder
    private var taskDescriptionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("About This Exercise")
                .font(EgyptianFonts.headline())
                .foregroundColor(EgyptianColors.textDark)
            
            Text(card.description)
                .font(EgyptianFonts.body())
                .foregroundColor(EgyptianColors.textDark.opacity(0.8))
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .egyptianCard()
    }
    
    @ViewBuilder
    private var actionStepsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Task")
                .font(EgyptianFonts.headline())
                .foregroundColor(EgyptianColors.textDark)
            
            HStack(alignment: .top, spacing: 16) {
                Text(EgyptianSymbols.ankh)
                    .font(.system(size: 24))
                    .foregroundColor(EgyptianColors.golden)
                
                Text(card.task)
                    .font(EgyptianFonts.body())
                    .foregroundColor(EgyptianColors.textDark)
                    .lineSpacing(4)
            }
            
            // Additional tips based on category
            additionalTips
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .egyptianCard()
    }
    
    @ViewBuilder
    private var additionalTips: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ancient Wisdom")
                .font(EgyptianFonts.headline())
                .foregroundColor(EgyptianColors.golden)
            
            ForEach(tipsForCategory, id: \.self) { tip in
                HStack(alignment: .top, spacing: 12) {
                    Text("•")
                        .foregroundColor(EgyptianColors.golden)
                        .font(EgyptianFonts.body())
                    
                    Text(tip)
                        .font(EgyptianFonts.body())
                        .foregroundColor(EgyptianColors.textDark.opacity(0.8))
                        .lineSpacing(2)
                }
            }
        }
        .padding(.top, 16)
    }
    
    @ViewBuilder
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Reflections")
                .font(EgyptianFonts.headline())
                .foregroundColor(EgyptianColors.textDark)
            
            TextField("Write your thoughts about this exercise...", text: $notes)
                .font(EgyptianFonts.body())
                .foregroundColor(EgyptianColors.textDark)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(EgyptianColors.papyrus.opacity(0.5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(EgyptianColors.golden.opacity(0.3), lineWidth: 1)
                        )
                )
                .lineLimit(10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .egyptianCard()
    }
    
    @ViewBuilder
    private var completionButton: some View {
        VStack(spacing: 16) {
            if !isCompleted {
                Button("Mark as Complete") {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isCompleted = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showCompletion = true
                    }
                }
                .egyptianButton()
            } else {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(EgyptianColors.turquoise)
                    
                    Text("Exercise Completed!")
                        .font(EgyptianFonts.body())
                        .foregroundColor(EgyptianColors.turquoise)
                }
                .padding(.vertical, 16)
            }
            
            Button("Close") {
                dismiss()
            }
            .egyptianButton(secondary: true)
        }
    }
    
    private var tipsForCategory: [String] {
        switch card.category {
        case .wisdom:
            return [
                "The ancient Egyptians believed wisdom came from observing nature and reflecting on experiences.",
                "Take time to pause and consider what each experience teaches you.",
                "Write down insights to remember them, like scribes recorded important knowledge."
            ]
        case .focus:
            return [
                "Pharaohs needed intense focus to rule vast kingdoms effectively.",
                "Start with short periods of focused attention and gradually increase.",
                "Remove distractions from your environment, like clearing a temple for worship."
            ]
        case .creativity:
            return [
                "Egyptian artists and scribes were highly creative, inventing beautiful art and writing.",
                "Don't judge your creative output - let ideas flow freely like the Nile.",
                "Combine different ideas, like Egyptians blended various cultural influences."
            ]
        case .resilience:
            return [
                "The pyramids have stood for thousands of years through storms and time.",
                "Build your inner strength gradually, like laying pyramid stones one by one.",
                "Remember that challenges are temporary, but your growth is permanent."
            ]
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 0.8)) {
            animateIcon = true
        }
    }
}

struct MindTrainingCompletionView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    let card: MindTrainingCard
    
    @State private var showCelebration = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    card.category.color.opacity(0.3),
                    EgyptianColors.darkBrown,
                    EgyptianColors.nightSky
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Celebration animation
                if showCelebration {
                    Text(EgyptianSymbols.ankh)
                        .font(.system(size: 100))
                        .foregroundColor(EgyptianColors.hieroglyphGold)
                        .scaleEffect(showCelebration ? 1.2 : 0.8)
                        .shadow(
                            color: EgyptianColors.hieroglyphGold.opacity(0.8),
                            radius: 20
                        )
                        .animation(
                            .easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                            value: showCelebration
                        )
                }
                
                Text("Exercise Complete!")
                    .font(EgyptianFonts.title())
                    .foregroundColor(EgyptianColors.textLight)
                    .multilineTextAlignment(.center)
                
                Text("You have completed the \(card.title) exercise. Your mind grows stronger like the eternal pyramids.")
                    .font(EgyptianFonts.body())
                    .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                
                // Wisdom quote
                VStack(spacing: 12) {
                    Text("\"")
                        .font(.system(size: 40))
                        .foregroundColor(EgyptianColors.golden)
                    
                    Text(wisdomQuote)
                        .font(.body.italic())
                        .foregroundColor(EgyptianColors.textLight)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                    
                    Text("- Ancient Egyptian Wisdom")
                        .font(EgyptianFonts.caption())
                        .foregroundColor(EgyptianColors.golden)
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(EgyptianColors.darkBrown.opacity(0.5))
                )
                
                Spacer()
                
                Button("Continue Journey") {
                    dismiss()
                }
                .egyptianButton()
            }
            .padding(.horizontal, 32)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                showCelebration = true
            }
        }
    }
    
    private var wisdomQuote: String {
        switch card.category {
        case .wisdom:
            return "The wise person learns from every experience, like the Nile learns from every stone in its path."
        case .focus:
            return "A focused mind is like a sharp chisel that can carve the hardest stone into beautiful art."
        case .creativity:
            return "Creativity flows like the Nile, bringing life and beauty wherever it touches."
        case .resilience:
            return "Be like the pyramid - built to last through any storm that time may bring."
        }
    }
}

#Preview {
    MindTrainingDetailView(
        card: MindTrainingCard(
            title: "Pharaoh's Focus",
            description: "Like a pharaoh ruling Egypt, train your mind to focus on one task with unwavering attention.",
            task: "Choose one important task today and give it your complete focus for 25 minutes, like a pharaoh's decree.",
            icon: "👑",
            category: .focus
        )
    )
    .environmentObject(AppState())
}