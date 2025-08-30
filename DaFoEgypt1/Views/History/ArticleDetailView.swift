//
//  ArticleDetailView.swift
//  DaFoEgypt1
//
//  Created by IGOR on 29/08/2025.
//

import SwiftUI

struct ArticleDetailView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    let article: HistoryArticle
    
    @State private var scrollOffset: CGFloat = 0
    @State private var showContent = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    colors: [
                        article.category.color.opacity(0.1),
                        EgyptianColors.papyrus,
                        EgyptianColors.desertSand.opacity(0.3)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        headerView
                        
                        // Content
                        contentView
                    }
                }
                .coordinateSpace(name: "scroll")
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                showContent = true
            }
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
                
                // Reading time
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                    Text("\(article.readingTime) min read")
                        .font(.system(size: 12, weight: .medium))
                }
                .foregroundColor(EgyptianColors.golden)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(EgyptianColors.golden.opacity(0.2))
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Article icon and category
            VStack(spacing: 16) {
                Text(article.imageIcon)
                    .font(.system(size: 80))
                    .scaleEffect(showContent ? 1.0 : 0.8)
                    .opacity(showContent ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.8), value: showContent)
                
                Text(article.category.rawValue)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(article.category.color)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(article.category.color.opacity(0.2))
                    )
                    .opacity(showContent ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.8).delay(0.2), value: showContent)
            }
            
            // Title
            Text(article.title)
                .font(EgyptianFonts.title())
                .foregroundColor(EgyptianColors.textDark)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .opacity(showContent ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.8).delay(0.4), value: showContent)
            
            // Summary
            Text(article.summary)
                .font(EgyptianFonts.body())
                .foregroundColor(EgyptianColors.textDark.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 20)
                .opacity(showContent ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.8).delay(0.6), value: showContent)
        }
        .padding(.bottom, 30)
    }
    
    @ViewBuilder
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Decorative divider
            HStack {
                decorativeDivider
                
                Text(EgyptianSymbols.ankh)
                    .font(.system(size: 20))
                    .foregroundColor(EgyptianColors.golden)
                
                decorativeDivider
            }
            .padding(.horizontal, 20)
            .opacity(showContent ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 0.8).delay(0.8), value: showContent)
            
            // Article content
            articleContentView
                .padding(.horizontal, 20)
                .opacity(showContent ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.8).delay(1.0), value: showContent)
            
            // Bottom padding
            Color.clear.frame(height: 50)
        }
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(EgyptianColors.papyrus)
                .shadow(
                    color: EgyptianColors.darkBrown.opacity(0.1),
                    radius: 10,
                    x: 0,
                    y: -5
                )
        )
    }
    
    @ViewBuilder
    private var decorativeDivider: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        Color.clear,
                        EgyptianColors.golden.opacity(0.5),
                        Color.clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: 1)
    }
    
    @ViewBuilder
    private var articleContentView: some View {
        VStack(alignment: .leading, spacing: 16) {
            let paragraphs = article.content.components(separatedBy: "\n\n")
            
            ForEach(Array(paragraphs.enumerated()), id: \.offset) { index, paragraph in
                if paragraph.hasPrefix("**") && paragraph.hasSuffix("**") {
                    // This is a heading
                    let heading = String(paragraph.dropFirst(2).dropLast(2))
                    Text(heading)
                        .font(EgyptianFonts.headline())
                        .foregroundColor(EgyptianColors.golden)
                        .padding(.top, index == 0 ? 0 : 8)
                } else {
                    // This is regular content
                    Text(formatText(paragraph))
                        .font(EgyptianFonts.body())
                        .foregroundColor(EgyptianColors.textDark)
                        .lineSpacing(6)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
    
    private func formatText(_ text: String) -> AttributedString {
        var attributedString = AttributedString(text)
        
        // Handle bold text (**text**)
        let boldPattern = "\\*\\*(.*?)\\*\\*"
        if let regex = try? NSRegularExpression(pattern: boldPattern, options: []) {
            let nsString = text as NSString
            let results = regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsString.length))
            
            for result in results.reversed() {
                let range = result.range(at: 1)
                if range.location != NSNotFound {
                    let boldText = nsString.substring(with: range)
                    let fullRange = result.range
                    let startIndex = attributedString.index(attributedString.startIndex, offsetByCharacters: fullRange.location)
                    let endIndex = attributedString.index(startIndex, offsetByCharacters: fullRange.length)
                    
                    attributedString.replaceSubrange(startIndex..<endIndex, with: AttributedString(boldText))
                    if let newRange = Range(NSRange(location: fullRange.location, length: boldText.count), in: attributedString) {
                        attributedString[newRange].font = EgyptianFonts.body().weight(.semibold)
                        attributedString[newRange].foregroundColor = EgyptianColors.golden
                    }
                }
            }
        }
        
        return attributedString
    }
}

struct PharaoDetailView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    let pharao: PharaoTimeline
    
    @State private var showContent = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    colors: [
                        EgyptianColors.golden.opacity(0.1),
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
                        
                        // Reign info
                        reignInfoView
                        
                        // Achievements
                        achievementsView
                        
                        // Fun fact
                        funFactView
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                showContent = true
            }
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
            
            // Crown icon
            Text("👑")
                .font(.system(size: 80))
                .scaleEffect(showContent ? 1.0 : 0.8)
                .opacity(showContent ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.8), value: showContent)
            
            // Name and dynasty
            VStack(spacing: 8) {
                Text(pharao.name)
                    .font(EgyptianFonts.title())
                    .foregroundColor(EgyptianColors.textDark)
                    .multilineTextAlignment(.center)
                
                Text(pharao.dynasty)
                    .font(EgyptianFonts.headline())
                    .foregroundColor(EgyptianColors.golden)
            }
            .opacity(showContent ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 0.8).delay(0.2), value: showContent)
        }
    }
    
    @ViewBuilder
    private var reignInfoView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Reign Period")
                .font(EgyptianFonts.headline())
                .foregroundColor(EgyptianColors.textDark)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Started")
                        .font(EgyptianFonts.caption())
                        .foregroundColor(EgyptianColors.textDark.opacity(0.7))
                    Text("\(pharao.reignStart) BCE")
                        .font(EgyptianFonts.body())
                        .foregroundColor(EgyptianColors.golden)
                }
                
                Spacer()
                
                Text("→")
                    .font(.system(size: 24))
                    .foregroundColor(EgyptianColors.golden)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Ended")
                        .font(EgyptianFonts.caption())
                        .foregroundColor(EgyptianColors.textDark.opacity(0.7))
                    Text("\(pharao.reignEnd) BCE")
                        .font(EgyptianFonts.body())
                        .foregroundColor(EgyptianColors.golden)
                }
            }
            
            Text("Ruled for \(pharao.reignStart - pharao.reignEnd) years")
                .font(EgyptianFonts.body())
                .foregroundColor(EgyptianColors.textDark.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(24)
        .egyptianCard()
        .opacity(showContent ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 0.8).delay(0.4), value: showContent)
    }
    
    @ViewBuilder
    private var achievementsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Major Achievements")
                .font(EgyptianFonts.headline())
                .foregroundColor(EgyptianColors.textDark)
            
            ForEach(Array(pharao.achievements.enumerated()), id: \.offset) { index, achievement in
                HStack(alignment: .top, spacing: 12) {
                    Text(EgyptianSymbols.ankh)
                        .font(.system(size: 16))
                        .foregroundColor(EgyptianColors.golden)
                    
                    Text(achievement)
                        .font(EgyptianFonts.body())
                        .foregroundColor(EgyptianColors.textDark)
                        .lineSpacing(4)
                }
                .opacity(showContent ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.6).delay(0.6 + Double(index) * 0.1), value: showContent)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .egyptianCard()
    }
    
    @ViewBuilder
    private var funFactView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("💡")
                    .font(.system(size: 24))
                
                Text("Fun Fact")
                    .font(EgyptianFonts.headline())
                    .foregroundColor(EgyptianColors.golden)
                
                Spacer()
            }
            
            Text(pharao.funFact)
                .font(EgyptianFonts.body())
                .foregroundColor(EgyptianColors.textDark)
                .lineSpacing(6)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(EgyptianColors.golden.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(EgyptianColors.golden.opacity(0.3), lineWidth: 1)
                )
        )
        .opacity(showContent ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 0.8).delay(0.8), value: showContent)
    }
}

struct ArtifactDetailView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    let artifact: Artifact
    
    @State private var showContent = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    colors: [
                        EgyptianColors.turquoise.opacity(0.1),
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
                        
                        // Artifact info
                        artifactInfoView
                        
                        // Description
                        descriptionView
                        
                        // Significance
                        significanceView
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                showContent = true
            }
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
                
                if artifact.discoveryYear > 0 {
                    Text("Discovered \(artifact.discoveryYear)")
                        .font(EgyptianFonts.caption())
                        .foregroundColor(EgyptianColors.golden)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(EgyptianColors.golden.opacity(0.2))
                        )
                }
            }
            
            // Artifact icon
            Text(artifact.imageIcon)
                .font(.system(size: 80))
                .scaleEffect(showContent ? 1.0 : 0.8)
                .opacity(showContent ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.8), value: showContent)
            
            // Name
            Text(artifact.name)
                .font(EgyptianFonts.title())
                .foregroundColor(EgyptianColors.textDark)
                .multilineTextAlignment(.center)
                .opacity(showContent ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.8).delay(0.2), value: showContent)
        }
    }
    
    @ViewBuilder
    private var artifactInfoView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Period")
                .font(EgyptianFonts.headline())
                .foregroundColor(EgyptianColors.textDark)
            
            Text(artifact.period)
                .font(EgyptianFonts.body())
                .foregroundColor(EgyptianColors.golden)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .egyptianCard()
        .opacity(showContent ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 0.8).delay(0.4), value: showContent)
    }
    
    @ViewBuilder
    private var descriptionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Description")
                .font(EgyptianFonts.headline())
                .foregroundColor(EgyptianColors.textDark)
            
            Text(artifact.description)
                .font(EgyptianFonts.body())
                .foregroundColor(EgyptianColors.textDark.opacity(0.8))
                .lineSpacing(6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .egyptianCard()
        .opacity(showContent ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 0.8).delay(0.6), value: showContent)
    }
    
    @ViewBuilder
    private var significanceView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("⭐")
                    .font(.system(size: 24))
                
                Text("Historical Significance")
                    .font(EgyptianFonts.headline())
                    .foregroundColor(EgyptianColors.golden)
            }
            
            Text(artifact.significance)
                .font(EgyptianFonts.body())
                .foregroundColor(EgyptianColors.textDark)
                .lineSpacing(6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(EgyptianColors.turquoise.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(EgyptianColors.turquoise.opacity(0.3), lineWidth: 1)
                )
        )
        .opacity(showContent ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 0.8).delay(0.8), value: showContent)
    }
}

#Preview {
    ArticleDetailView(article: HistoryDataProvider.articles[0])
        .environmentObject(AppState())
}

