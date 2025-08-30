//
//  HistoryView.swift
//  DaFoEgypt1
//
//  Created by IGOR on 29/08/2025.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedSection: HistorySection = .articles
    @State private var animateCards = false
    
    enum HistorySection: String, CaseIterable {
        case articles = "Articles"
        case timeline = "Timeline"
        case artifacts = "Artifacts"
        
        var icon: String {
            switch self {
            case .articles: return EgyptianSymbols.history
            case .timeline: return EgyptianSymbols.timeline
            case .artifacts: return EgyptianSymbols.artifact
            }
        }
        
        var egyptianIcon: String {
            switch self {
            case .articles: return EgyptianSymbols.papyrus
            case .timeline: return "⏳"
            case .artifacts: return "🏺"
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Section selector
                sectionSelector
                
                // Content based on selected section
                switch selectedSection {
                case .articles:
                    HistoryArticlesView()
                        .environmentObject(appState)
                case .timeline:
                    PharaoTimelineView()
                        .environmentObject(appState)
                case .artifacts:
                    ArtifactGalleryView()
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
    
    @ViewBuilder
    private var sectionSelector: some View {
        HStack(spacing: 12) {
            ForEach(HistorySection.allCases, id: \.self) { section in
                sectionButton(for: section)
            }
        }
        .padding(.horizontal, 4)
    }
    
    private func sectionButton(for section: HistorySection) -> some View {
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
            .delay(Double(HistorySection.allCases.firstIndex(of: section) ?? 0) * 0.1),
            value: animateCards
        )
    }
}

// MARK: - History Articles View
struct HistoryArticlesView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedCategory: HistoryCategory? = nil
    @State private var selectedArticle: HistoryArticle? = nil
    
    var filteredArticles: [HistoryArticle] {
        if let category = selectedCategory {
            return HistoryDataProvider.articles.filter { $0.category == category }
        }
        return HistoryDataProvider.articles
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("📚 Ancient Chronicles")
                    .font(EgyptianFonts.headline())
                    .foregroundColor(EgyptianColors.textDark)
                
                Spacer()
                
                Text("\(filteredArticles.count) articles")
                    .font(EgyptianFonts.caption())
                    .foregroundColor(EgyptianColors.golden)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(EgyptianColors.golden.opacity(0.2))
                    )
            }
            
            // Category filter
            categoryFilter
            
            // Articles grid
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
                ForEach(filteredArticles, id: \.id) { article in
                    articleCard(for: article)
                }
            }
        }
        .sheet(item: $selectedArticle) { article in
            ArticleDetailView(article: article)
                .environmentObject(appState)
        }
    }
    
    @ViewBuilder
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // All categories button
                categoryButton(for: nil, title: "All", icon: "📖")
                
                ForEach(HistoryCategory.allCases, id: \.self) { category in
                    categoryButton(for: category, title: category.rawValue, icon: category.icon)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func categoryButton(for category: HistoryCategory?, title: String, icon: String) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedCategory = category
            }
        }) {
            HStack(spacing: 8) {
                Text(icon)
                    .font(.system(size: 16))
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(
                        selectedCategory == category ? 
                        EgyptianColors.textLight : 
                        EgyptianColors.textDark
                    )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        selectedCategory == category ? 
                        EgyptianColors.golden : 
                        EgyptianColors.papyrus.opacity(0.5)
                    )
                    .shadow(
                        color: EgyptianColors.darkBrown.opacity(0.1),
                        radius: 2
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func articleCard(for article: HistoryArticle) -> some View {
        Button(action: {
            selectedArticle = article
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(article.imageIcon)
                        .font(.system(size: 30))
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(article.category.rawValue)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(article.category.color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(article.category.color.opacity(0.2))
                            )
                        
                        Text("\(article.readingTime) min read")
                            .font(.system(size: 10))
                            .foregroundColor(EgyptianColors.textDark.opacity(0.6))
                    }
                }
                
                Text(article.title)
                    .font(EgyptianFonts.headline())
                    .foregroundColor(EgyptianColors.textDark)
                    .multilineTextAlignment(.leading)
                
                Text(article.summary)
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
}

// MARK: - Pharao Timeline View
struct PharaoTimelineView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedPharao: PharaoTimeline? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("👑 Royal Timeline")
                    .font(EgyptianFonts.headline())
                    .foregroundColor(EgyptianColors.textDark)
                
                Spacer()
                
                Text("\(HistoryDataProvider.pharaohs.count) rulers")
                    .font(EgyptianFonts.caption())
                    .foregroundColor(EgyptianColors.golden)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(EgyptianColors.golden.opacity(0.2))
                    )
            }
            
            // Timeline
            LazyVStack(spacing: 16) {
                ForEach(HistoryDataProvider.pharaohs, id: \.id) { pharao in
                    pharaoTimelineCard(for: pharao)
                }
            }
        }
        .sheet(item: $selectedPharao) { pharao in
            PharaoDetailView(pharao: pharao)
                .environmentObject(appState)
        }
    }
    
    private func pharaoTimelineCard(for pharao: PharaoTimeline) -> some View {
        Button(action: {
            selectedPharao = pharao
        }) {
            HStack(spacing: 16) {
                // Timeline indicator
                VStack {
                    Circle()
                        .fill(EgyptianColors.golden)
                        .frame(width: 12, height: 12)
                    
                    Rectangle()
                        .fill(EgyptianColors.golden.opacity(0.3))
                        .frame(width: 2, height: 60)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(pharao.name)
                            .font(EgyptianFonts.headline())
                            .foregroundColor(EgyptianColors.textDark)
                        
                        Spacer()
                        
                        Text("\(pharao.reignStart) - \(pharao.reignEnd) BCE")
                            .font(EgyptianFonts.caption())
                            .foregroundColor(EgyptianColors.golden)
                    }
                    
                    Text(pharao.dynasty)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(EgyptianColors.textDark.opacity(0.7))
                    
                    Text(pharao.funFact)
                        .font(EgyptianFonts.body())
                        .foregroundColor(EgyptianColors.textDark.opacity(0.8))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
        }
        .egyptianCard()
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Artifact Gallery View
struct ArtifactGalleryView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedArtifact: Artifact? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("🏺 Treasure Gallery")
                    .font(EgyptianFonts.headline())
                    .foregroundColor(EgyptianColors.textDark)
                
                Spacer()
                
                Text("\(HistoryDataProvider.artifacts.count) artifacts")
                    .font(EgyptianFonts.caption())
                    .foregroundColor(EgyptianColors.golden)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(EgyptianColors.golden.opacity(0.2))
                    )
            }
            
            // Artifacts grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(HistoryDataProvider.artifacts, id: \.id) { artifact in
                    artifactCard(for: artifact)
                }
            }
        }
        .sheet(item: $selectedArtifact) { artifact in
            ArtifactDetailView(artifact: artifact)
                .environmentObject(appState)
        }
    }
    
    private func artifactCard(for artifact: Artifact) -> some View {
        Button(action: {
            selectedArtifact = artifact
        }) {
            VStack(spacing: 12) {
                Text(artifact.imageIcon)
                    .font(.system(size: 50))
                
                Text(artifact.name)
                    .font(EgyptianFonts.caption())
                    .foregroundColor(EgyptianColors.textDark)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text(artifact.period)
                    .font(.system(size: 12))
                    .foregroundColor(EgyptianColors.golden)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                
                if artifact.discoveryYear > 0 {
                    Text("Discovered \(artifact.discoveryYear)")
                        .font(.system(size: 10))
                        .foregroundColor(EgyptianColors.textDark.opacity(0.6))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(16)
        }
        .egyptianCard()
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HistoryView()
        .environmentObject(AppState())
}

