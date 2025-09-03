//
//  SelfDevelopmentView.swift
//  DaFoEgypt1
//
//  Created by IGOR on 29/08/2025.
//

import SwiftUI

struct SelfDevelopmentView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedSection: SelfDevelopmentSection = .meditation
    @State private var animateCards = false
    
    enum SelfDevelopmentSection: String, CaseIterable {
        case meditation = "Meditation"
        case journal = "Journal"
        case mindTraining = "Mind Training"
        
        var icon: String {
            switch self {
            case .meditation: return EgyptianSymbols.meditation
            case .journal: return EgyptianSymbols.journal
            case .mindTraining: return "brain.head.profile"
            }
        }
        
        var egyptianIcon: String {
            switch self {
            case .meditation: return EgyptianSymbols.lotus
            case .journal: return EgyptianSymbols.papyrus
            case .mindTraining: return EgyptianSymbols.eye
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                LinearGradient(
                    colors: [
                        EgyptianColors.papyrus,
                        EgyptianColors.desertSand.opacity(0.8),
                        EgyptianColors.papyrus
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: geometry.size.width < 400 ? 16 : 24) {
                        // Header
                        headerView(geometry: geometry)
                        
                        // Section selector
                        sectionSelector(geometry: geometry)
                        
                        // Content based on selected section
                        switch selectedSection {
                        case .meditation:
                            MeditationSectionView()
                                .environmentObject(appState)
                        case .journal:
                            JournalSectionView()
                                .environmentObject(appState)
                        case .mindTraining:
                            MindTrainingSectionView()
                                .environmentObject(appState)
                        }
                    }
                    .padding(.horizontal, geometry.size.width < 400 ? 16 : 20)
                    .padding(.top, geometry.size.width < 400 ? 16 : 20)
                    .padding(.bottom, 100) // Extra padding for tab bar
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 0.8).delay(0.2)) {
                    animateCards = true
                }
            }
        }
    }
    
    @ViewBuilder
    private func headerView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 12) {
            Text("🧘‍♀️ Self Development")
                .font(EgyptianFonts.title(for: geometry))
                .foregroundColor(EgyptianColors.textDark)
            
            Text("Develop your mind, body, and spirit with ancient Egyptian wisdom")
                .font(EgyptianFonts.body(for: geometry))
                .foregroundColor(EgyptianColors.textDark.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineSpacing(geometry.size.width < 400 ? 2 : 4)
        }
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 0.8), value: animateCards)
    }
    
    @ViewBuilder
    private func sectionSelector(geometry: GeometryProxy) -> some View {
        HStack(spacing: geometry.size.width < 400 ? 8 : 12) {
            ForEach(SelfDevelopmentSection.allCases, id: \.self) { section in
                sectionButton(for: section, geometry: geometry)
            }
        }
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 0.8).delay(0.3), value: animateCards)
    }
    
    private func sectionButton(for section: SelfDevelopmentSection, geometry: GeometryProxy) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedSection = section
            }
        }) {
            VStack(spacing: geometry.size.width < 400 ? 6 : 8) {
                Text(section.egyptianIcon)
                    .font(.system(size: geometry.size.width < 400 ? 20 : 24))
                    .foregroundColor(
                        selectedSection == section ?
                        EgyptianColors.hieroglyphGold :
                        EgyptianColors.textDark.opacity(0.6)
                    )
                
                Text(section.rawValue)
                    .font(EgyptianFonts.caption(for: geometry))
                    .foregroundColor(
                        selectedSection == section ?
                        EgyptianColors.textDark :
                        EgyptianColors.textDark.opacity(0.6)
                    )
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, geometry.size.width < 400 ? 12 : 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        selectedSection == section ?
                        EgyptianColors.golden.opacity(0.2) :
                        Color.clear
                    )
                    .animation(.easeInOut(duration: 0.3), value: selectedSection)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Meditation Section
struct MeditationSectionView: View {
    @EnvironmentObject var appState: AppState
    @State private var showMeditationPlayer = false
    @State private var selectedMeditation: MeditationType?
    
    var body: some View {
        VStack(spacing: 20) {
            // Progress overview
            progressOverview
            
            // Meditation types
            meditationGrid
        }
        .fullScreenCover(item: $selectedMeditation) { meditation in
            MeditationPlayerView(meditation: meditation)
                .environmentObject(appState)
        }
    }
    
    @ViewBuilder
    private var progressOverview: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🧘‍♀️ Your Meditation Journey")
                .font(EgyptianFonts.headline())
                .foregroundColor(EgyptianColors.textDark)
            
            HStack(spacing: 20) {
                statCard(
                    title: "Sessions",
                    value: "\(appState.meditationProgress.count)",
                    icon: "🧘‍♀️"
                )
                
                statCard(
                    title: "Total Time",
                    value: formatTotalTime(),
                    icon: "⏰"
                )
                
                statCard(
                    title: "Streak",
                    value: "\(calculateStreak()) days",
                    icon: "🔥"
                )
            }
        }
        .padding(20)
        .egyptianCard()
    }
    
    private func statCard(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 8) {
            Text(icon)
                .font(.system(size: 24))
            
            Text(value)
                .font(EgyptianFonts.headline())
                .foregroundColor(EgyptianColors.textDark)
            
            Text(title)
                .font(EgyptianFonts.caption())
                .foregroundColor(EgyptianColors.textDark.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var meditationGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            ForEach(MeditationType.allCases) { meditation in
                meditationCard(for: meditation)
            }
        }
    }
    
    private func meditationCard(for meditation: MeditationType) -> some View {
        Button(action: {
            selectedMeditation = meditation
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(meditation.icon)
                        .font(.system(size: 32))
                    
                    Spacer()
                    
                    Text("\(Int(meditation.duration / 60)) min")
                        .font(EgyptianFonts.caption())
                        .foregroundColor(EgyptianColors.textDark.opacity(0.7))
                }
                
                Text(meditation.rawValue)
                    .font(EgyptianFonts.headline())
                    .foregroundColor(EgyptianColors.textDark)
                    .multilineTextAlignment(.leading)
                
                Text(meditation.description)
                    .font(EgyptianFonts.caption())
                    .foregroundColor(EgyptianColors.textDark.opacity(0.8))
                    .lineSpacing(2)
                    .multilineTextAlignment(.leading)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(PlainButtonStyle())
        .egyptianCard()
    }
    
    private func formatTotalTime() -> String {
        let totalSeconds = appState.meditationProgress.reduce(0) { $0 + $1.duration }
        let hours = Int(totalSeconds) / 3600
        let minutes = (Int(totalSeconds) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    private func calculateStreak() -> Int {
        // Simple streak calculation - count consecutive days with sessions
        let calendar = Calendar.current
        let today = Date()
        var streak = 0
        
        for i in 0..<30 { // Check last 30 days
            let date = calendar.date(byAdding: .day, value: -i, to: today)!
            let hasSession = appState.meditationProgress.contains { session in
                calendar.isDate(session.date, inSameDayAs: date)
            }
            
            if hasSession {
                streak += 1
            } else if i > 0 { // Don't break on today if no session yet
                break
            }
        }
        
        return streak
    }
}

// MARK: - Journal Section
struct JournalSectionView: View {
    @EnvironmentObject var appState: AppState
    @State private var showNewEntry = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with add button
            journalHeader
            
            // Recent entries
            if appState.journalEntries.isEmpty {
                emptyJournalView
            } else {
                journalEntries
            }
        }
        .sheet(isPresented: $showNewEntry) {
            NewJournalEntryView()
                .environmentObject(appState)
        }
    }
    
    @ViewBuilder
    private var journalHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("📜 Wisdom Journal")
                    .font(EgyptianFonts.headline())
                    .foregroundColor(EgyptianColors.textDark)
                
                Text("Record your thoughts and insights")
                    .font(EgyptianFonts.caption())
                    .foregroundColor(EgyptianColors.textDark.opacity(0.7))
            }
            
            Spacer()
            
            Button("New Entry") {
                showNewEntry = true
            }
            .egyptianButton()
        }
        .padding(20)
        .egyptianCard()
    }
    
    @ViewBuilder
    private var emptyJournalView: some View {
        VStack(spacing: 16) {
            Text("📜")
                .font(.system(size: 60))
            
            Text("Begin Your Journey")
                .font(EgyptianFonts.headline())
                .foregroundColor(EgyptianColors.textDark)
            
            Text("Start writing your first journal entry to capture your thoughts and wisdom.")
                .font(EgyptianFonts.body())
                .foregroundColor(EgyptianColors.textDark.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            
            Button("Write First Entry") {
                showNewEntry = true
            }
            .egyptianButton()
        }
        .padding(40)
        .egyptianCard()
    }
    
    @ViewBuilder
    private var journalEntries: some View {
        LazyVStack(spacing: 12) {
            ForEach(appState.journalEntries.sorted(by: { $0.date > $1.date }).prefix(5), id: \.id) { entry in
                journalEntryCard(entry)
            }
        }
    }
    
    private func journalEntryCard(_ entry: JournalEntry) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(entry.mood.emoji)
                    .font(.system(size: 24))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.mood.rawValue)
                        .font(EgyptianFonts.caption())
                        .foregroundColor(entry.mood.color)
                    
                    Text(entry.date, style: .date)
                        .font(EgyptianFonts.caption())
                        .foregroundColor(EgyptianColors.textDark.opacity(0.6))
                }
                
                Spacer()
            }
            
            Text(entry.prompt)
                .font(EgyptianFonts.body())
                .foregroundColor(EgyptianColors.textDark)
                .fontWeight(.medium)
            
            Text(entry.response)
                .font(EgyptianFonts.body())
                .foregroundColor(EgyptianColors.textDark.opacity(0.8))
                .lineSpacing(4)
                .lineLimit(3)
        }
        .padding(16)
        .egyptianCard()
    }
}

// MARK: - Mind Training Section
struct MindTrainingSectionView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedCard: MindTrainingCard?
    
    private let mindTrainingCards: [MindTrainingCard] = [
        MindTrainingCard(
            title: "Pharaoh's Focus",
            description: "Develop laser-sharp concentration like ancient rulers",
            task: "Practice focused attention on a single object for 10 minutes",
            icon: "👑",
            category: .focus
        ),
        MindTrainingCard(
            title: "Scribe's Memory",
            description: "Enhance your memory using ancient Egyptian techniques",
            task: "Memorize and recite a sequence of hieroglyphs",
            icon: "📜",
            category: .wisdom
        ),
        MindTrainingCard(
            title: "Desert Resilience",
            description: "Build mental toughness through challenging exercises",
            task: "Complete a difficult task without giving up",
            icon: "🏜️",
            category: .resilience
        ),
        MindTrainingCard(
            title: "Creative Visualization",
            description: "Use imagination to create vivid mental images",
            task: "Visualize building a pyramid step by step",
            icon: "🎨",
            category: .creativity
        )
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            mindTrainingHeader
            
            // Training cards
            trainingGrid
        }
        .sheet(item: $selectedCard) { card in
            MindTrainingDetailView(card: card)
                .environmentObject(appState)
        }
    }
    
    @ViewBuilder
    private var mindTrainingHeader: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🧠 Mind Training")
                .font(EgyptianFonts.headline())
                .foregroundColor(EgyptianColors.textDark)
            
            Text("Strengthen your mental abilities with exercises inspired by ancient Egyptian wisdom and practices.")
                .font(EgyptianFonts.body())
                .foregroundColor(EgyptianColors.textDark.opacity(0.8))
                .lineSpacing(4)
        }
        .padding(20)
        .egyptianCard()
    }
    
    @ViewBuilder
    private var trainingGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            ForEach(mindTrainingCards, id: \.id) { card in
                trainingCard(card)
            }
        }
    }
    
    private func trainingCard(_ card: MindTrainingCard) -> some View {
        Button(action: {
            selectedCard = card
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(card.icon)
                        .font(.system(size: 32))
                    
                    Spacer()
                    
                    Circle()
                        .fill(card.category.color)
                        .frame(width: 12, height: 12)
                }
                
                Text(card.title)
                    .font(EgyptianFonts.headline())
                    .foregroundColor(EgyptianColors.textDark)
                    .multilineTextAlignment(.leading)
                
                Text(card.description)
                    .font(EgyptianFonts.caption())
                    .foregroundColor(EgyptianColors.textDark.opacity(0.8))
                    .lineSpacing(2)
                    .multilineTextAlignment(.leading)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(PlainButtonStyle())
        .egyptianCard()
    }
}

#Preview {
    SelfDevelopmentView()
        .environmentObject(AppState())
}