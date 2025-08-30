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
        NavigationView {
            ScrollView {
            VStack(spacing: 24) {
                // Section selector
                sectionSelector
                
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
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.2)) {
                animateCards = true
            }
        }
        }
    }
    
    @ViewBuilder
    private var sectionSelector: some View {
        HStack(spacing: 12) {
            ForEach(SelfDevelopmentSection.allCases, id: \.self) { section in
                sectionButton(for: section)
            }
        }
        .padding(.horizontal, 4)
    }
    
    private func sectionButton(for section: SelfDevelopmentSection) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedSection = section
            }
        }) {
            VStack(spacing: 8) {
                Text(section.egyptianIcon)
                    .font(.system(size: 24))
                    .foregroundColor(
                        selectedSection == section ? 
                        EgyptianColors.textLight : 
                        EgyptianColors.textDark
                    )
                
                Text(section.rawValue)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(
                        selectedSection == section ? 
                        EgyptianColors.textLight : 
                        EgyptianColors.textDark
                    )
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        selectedSection == section ? 
                        LinearGradient(
                            colors: [EgyptianColors.golden, EgyptianColors.goldenDark],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) : 
                        LinearGradient(
                            colors: [EgyptianColors.papyrus, EgyptianColors.papyrus],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(
                        color: EgyptianColors.darkBrown.opacity(0.2),
                        radius: selectedSection == section ? 8 : 4,
                        x: 0,
                        y: selectedSection == section ? 4 : 2
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(animateCards ? 1.0 : 0.8)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(
            .easeInOut(duration: 0.6)
            .delay(Double(SelfDevelopmentSection.allCases.firstIndex(of: section) ?? 0) * 0.1),
            value: animateCards
        )
    }
}

// MARK: - Meditation Section
struct MeditationSectionView: View {
    @EnvironmentObject var appState: AppState

    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("🧘‍♀️ Egyptian Meditation")
                    .font(EgyptianFonts.headline())
                    .foregroundColor(EgyptianColors.textDark)
                
                Spacer()
                
                Text("\(appState.meditationProgress.count) sessions")
                    .font(EgyptianFonts.caption())
                    .foregroundColor(EgyptianColors.golden)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(EgyptianColors.golden.opacity(0.2))
                    )
            }
            
            // Meditation types
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(MeditationType.allCases, id: \.self) { meditation in
                    meditationCard(for: meditation)
                }
            }
            
            // Recent sessions
            if !appState.meditationProgress.isEmpty {
                recentSessionsView
            }
        }
    }
    
    private func meditationCard(for meditation: MeditationType) -> some View {
        NavigationLink(destination: 
            MeditationPlayerView(meditation: meditation)
                .environmentObject(appState)
                .navigationBarHidden(true)
        ) {
            VStack(spacing: 12) {
                Text(meditation.icon)
                    .font(.system(size: 40))
                
                Text(meditation.rawValue)
                    .font(EgyptianFonts.caption())
                    .foregroundColor(EgyptianColors.textDark)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text("\(Int(meditation.duration / 60)) min")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(EgyptianColors.golden)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
        }
        .egyptianCard()
        .buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    private var recentSessionsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Sessions")
                .font(EgyptianFonts.headline())
                .foregroundColor(EgyptianColors.textDark)
            
            ForEach(appState.meditationProgress.suffix(3).reversed(), id: \.id) { session in
                HStack {
                    Text(session.type.icon)
                        .font(.system(size: 20))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(session.type.rawValue)
                            .font(EgyptianFonts.body())
                            .foregroundColor(EgyptianColors.textDark)
                        
                        Text(session.date, style: .date)
                            .font(EgyptianFonts.caption())
                            .foregroundColor(EgyptianColors.textDark.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    if session.completed {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(EgyptianColors.turquoise)
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(EgyptianColors.papyrus.opacity(0.5))
                )
            }
        }
    }
}

// MARK: - Journal Section
struct JournalSectionView: View {
    @EnvironmentObject var appState: AppState
    @State private var showNewEntry = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("📜 Pharaoh's Journal")
                    .font(EgyptianFonts.headline())
                    .foregroundColor(EgyptianColors.textDark)
                
                Spacer()
                
                Button(action: {
                    showNewEntry = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(EgyptianColors.golden)
                }
            }
            
            // Journal prompts
            journalPromptsView
            
            // Recent entries
            if !appState.journalEntries.isEmpty {
                recentEntriesView
            } else {
                emptyJournalView
            }
        }
        .sheet(isPresented: $showNewEntry) {
            NewJournalEntryView()
                .environmentObject(appState)
        }
    }
    
    @ViewBuilder
    private var journalPromptsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daily Reflections")
                .font(EgyptianFonts.headline())
                .foregroundColor(EgyptianColors.textDark)
            
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 12) {
                ForEach(journalPrompts, id: \.self) { prompt in
                    Button(action: {
                        // This would open the journal entry with this prompt
                        showNewEntry = true
                    }) {
                        HStack {
                            Text(EgyptianSymbols.papyrus)
                                .font(.system(size: 20))
                                .foregroundColor(EgyptianColors.golden)
                            
                            Text(prompt)
                                .font(EgyptianFonts.body())
                                .foregroundColor(EgyptianColors.textDark)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right.circle")
                                .foregroundColor(EgyptianColors.golden)
                        }
                        .padding(16)
                    }
                    .egyptianCard()
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    @ViewBuilder
    private var recentEntriesView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Entries")
                .font(EgyptianFonts.headline())
                .foregroundColor(EgyptianColors.textDark)
            
            ForEach(appState.journalEntries.suffix(3).reversed(), id: \.id) { entry in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(entry.mood.emoji)
                            .font(.system(size: 20))
                        
                        Text(entry.mood.rawValue)
                            .font(EgyptianFonts.caption())
                            .foregroundColor(entry.mood.color)
                        
                        Spacer()
                        
                        Text(entry.date, style: .date)
                            .font(EgyptianFonts.caption())
                            .foregroundColor(EgyptianColors.textDark.opacity(0.7))
                    }
                    
                    Text(entry.prompt)
                        .font(EgyptianFonts.caption())
                        .foregroundColor(EgyptianColors.textDark.opacity(0.8))
                        .italic()
                    
                    Text(entry.response)
                        .font(EgyptianFonts.body())
                        .foregroundColor(EgyptianColors.textDark)
                        .lineLimit(3)
                }
                .padding(16)
                .egyptianCard()
            }
        }
    }
    
    @ViewBuilder
    private var emptyJournalView: some View {
        VStack(spacing: 16) {
            Text(EgyptianSymbols.papyrus)
                .font(.system(size: 60))
                .foregroundColor(EgyptianColors.golden.opacity(0.6))
            
            Text("Begin Your Journey")
                .font(EgyptianFonts.headline())
                .foregroundColor(EgyptianColors.textDark)
            
            Text("Start writing your thoughts and reflections like the ancient scribes")
                .font(EgyptianFonts.body())
                .foregroundColor(EgyptianColors.textDark.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Button("Write First Entry") {
                showNewEntry = true
            }
            .egyptianButton()
        }
        .padding(32)
        .egyptianCard()
    }
    
    private let journalPrompts = [
        "What wisdom did I gain today, like the ancient pharaohs?",
        "How can I build my inner pyramid of strength?",
        "What would the gods of Egypt teach me about this challenge?",
        "Like the Nile's flow, how can I adapt to change?",
        "What treasures of knowledge did I discover today?"
    ]
}

// MARK: - Mind Training Section
struct MindTrainingSectionView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedCard: MindTrainingCard?
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("🧠 Mind Training")
                    .font(EgyptianFonts.headline())
                    .foregroundColor(EgyptianColors.textDark)
                
                Spacer()
                
                Text("Daily Exercises")
                    .font(EgyptianFonts.caption())
                    .foregroundColor(EgyptianColors.golden)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(EgyptianColors.golden.opacity(0.2))
                    )
            }
            
            // Mind training cards
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
                ForEach(mindTrainingCards, id: \.id) { card in
                    mindTrainingCardView(card: card)
                }
            }
        }
        .sheet(item: $selectedCard) { card in
            MindTrainingDetailView(card: card)
                .environmentObject(appState)
        }
    }
    
    private func mindTrainingCardView(card: MindTrainingCard) -> some View {
        Button(action: {
            selectedCard = card
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(card.icon)
                        .font(.system(size: 30))
                    
                    Spacer()
                    
                    Text(card.category.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(card.category.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(card.category.color.opacity(0.2))
                        )
                }
                
                Text(card.title)
                    .font(EgyptianFonts.headline())
                    .foregroundColor(EgyptianColors.textDark)
                    .multilineTextAlignment(.leading)
                
                Text(card.description)
                    .font(EgyptianFonts.body())
                    .foregroundColor(EgyptianColors.textDark.opacity(0.8))
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
        .egyptianCard()
        .buttonStyle(PlainButtonStyle())
    }
    
    private let mindTrainingCards = [
        MindTrainingCard(
            title: "Pharaoh's Focus",
            description: "Like a pharaoh ruling Egypt, train your mind to focus on one task with unwavering attention.",
            task: "Choose one important task today and give it your complete focus for 25 minutes, like a pharaoh's decree.",
            icon: "👑",
            category: .focus
        ),
        MindTrainingCard(
            title: "Scribe's Creativity",
            description: "Channel the creativity of ancient scribes who created beautiful hieroglyphs and stories.",
            task: "Write or draw something creative for 15 minutes, letting your imagination flow like the Nile.",
            icon: "✍️",
            category: .creativity
        ),
        MindTrainingCard(
            title: "Desert Resilience",
            description: "Build mental strength like the pyramids that have withstood thousands of years in the desert.",
            task: "When facing a challenge today, pause and ask: 'How would a pyramid endure this?'",
            icon: "🏜️",
            category: .resilience
        ),
        MindTrainingCard(
            title: "Ancient Wisdom",
            description: "Seek wisdom like the ancient Egyptian philosophers and priests who studied the mysteries of life.",
            task: "Spend 10 minutes reflecting on a lesson you learned recently and how it applies to your life.",
            icon: EgyptianSymbols.eye,
            category: .wisdom
        ),
        MindTrainingCard(
            title: "Nile's Patience",
            description: "Learn patience from the Nile River, which carved the landscape slowly over millennia.",
            task: "Practice patience today by taking three deep breaths before responding to any frustration.",
            icon: "🌊",
            category: .resilience
        ),
        MindTrainingCard(
            title: "Hieroglyph Memory",
            description: "Train your memory like ancient scribes who memorized thousands of hieroglyphic symbols.",
            task: "Memorize a short poem, quote, or list of items using visualization techniques.",
            icon: "🧠",
            category: .focus
        )
    ]
}

#Preview {
    SelfDevelopmentView()
        .environmentObject(AppState())
}

