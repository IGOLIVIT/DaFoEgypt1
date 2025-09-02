//
//  GamesView.swift
//  DaFoEgypt1
//
//  Created by IGOR on 29/08/2025.
//

import SwiftUI

struct GamesView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateCards = false
    @State private var selectedGame: GameType? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
            VStack(spacing: 24) {
                // Header
                headerView
                
                // High scores summary
                highScoresView
                
                // Games grid
                gamesGrid
                
                // Tips section
                tipsSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.2)) {
                animateCards = true
            }
        }
        .fullScreenCover(item: $selectedGame) { game in
            gameView(for: game)
        }
        }
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    private var headerView: some View {
        VStack(spacing: 12) {
            Text("🎮 Egyptian Games")
                .font(EgyptianFonts.title())
                .foregroundColor(EgyptianColors.textDark)
            
            Text("Test your knowledge and skills with games inspired by ancient Egypt")
                .font(EgyptianFonts.body())
                .foregroundColor(EgyptianColors.textDark.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 0.8), value: animateCards)
    }
    
    @ViewBuilder
    private var highScoresView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🏆 Your Best Scores")
                .font(EgyptianFonts.headline())
                .foregroundColor(EgyptianColors.textDark)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                scoreCard(
                    title: "Hieroglyphs",
                    score: appState.gameScores.hieroglyphPuzzleHighScore,
                    icon: "𓂀",
                    color: EgyptianColors.turquoise
                )
                
                scoreCard(
                    title: "History Quiz",
                    score: appState.gameScores.historyQuizHighScore,
                    icon: "📚",
                    color: EgyptianColors.golden
                )
                
                scoreCard(
                    title: "Pyramid Builder",
                    score: appState.gameScores.pyramidBuilderHighScore,
                    icon: "🔺",
                    color: EgyptianColors.deepRed
                )
            }
        }
        .padding(20)
        .egyptianCard()
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 0.8).delay(0.2), value: animateCards)
    }
    
    private func scoreCard(title: String, score: Int, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Text(icon)
                .font(.system(size: 24))
                .minimumScaleFactor(0.8)
            
            Text("\(score)")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(color)
                .minimumScaleFactor(0.8)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(EgyptianColors.textDark)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
    }
    
    @ViewBuilder
    private var gamesGrid: some View {
        LazyVGrid(columns: adaptiveColumns, spacing: 16) {
            gameCard(
                game: .hieroglyphPuzzle,
                title: "Hieroglyph Puzzle",
                description: "Decode ancient Egyptian symbols and learn their meanings",
                icon: "𓂀",
                color: EgyptianColors.turquoise,
                delay: 0.4
            )
            
            gameCard(
                game: .historyQuiz,
                title: "History Quiz",
                description: "Test your knowledge of ancient Egyptian history and culture",
                icon: "📚",
                color: EgyptianColors.golden,
                delay: 0.6
            )
            
            gameCard(
                game: .pyramidBuilder,
                title: "Build the Pyramid",
                description: "Stack blocks to build magnificent pyramids like the ancients",
                icon: "🔺",
                color: EgyptianColors.deepRed,
                delay: 0.8
            )
        }
    }
    
    private var adaptiveColumns: [GridItem] {
        // Use different column layouts based on device size
        let columns = [
            GridItem(.adaptive(minimum: 300, maximum: 500), spacing: 16)
        ]
        return columns
    }
    
    private func gameCard(game: GameType, title: String, description: String, icon: String, color: Color, delay: Double) -> some View {
        Button(action: {
            selectedGame = game
        }) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(icon)
                        .font(.system(size: 40))
                        .minimumScaleFactor(0.8)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("High Score")
                            .font(.system(size: 12))
                            .foregroundColor(EgyptianColors.textDark.opacity(0.6))
                            .minimumScaleFactor(0.8)
                        
                        Text("\(highScore(for: game))")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(color)
                            .minimumScaleFactor(0.8)
                    }
                }
                
                Text(title)
                    .font(EgyptianFonts.headline())
                    .foregroundColor(EgyptianColors.textDark)
                    .multilineTextAlignment(.leading)
                    .minimumScaleFactor(0.8)
                    .lineLimit(2)
                
                Text(description)
                    .font(EgyptianFonts.body())
                    .foregroundColor(EgyptianColors.textDark.opacity(0.8))
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
                    .minimumScaleFactor(0.8)
                    .lineLimit(3)
                
                HStack {
                    Text("Play Now")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(EgyptianColors.textLight)
                        .minimumScaleFactor(0.8)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(EgyptianColors.textLight)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [color, color.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
        .egyptianCard()
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(animateCards ? 1.0 : 0.8)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 0.6).delay(delay), value: animateCards)
    }
    
    @ViewBuilder
    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🎯 Game Tips")
                .font(EgyptianFonts.headline())
                .foregroundColor(EgyptianColors.textDark)
            
            VStack(spacing: 12) {
                tipRow(icon: "𓂀", tip: "Start with Hieroglyph Puzzle to learn ancient symbols")
                tipRow(icon: "📚", tip: "Read History articles to improve your quiz scores")
                tipRow(icon: "🔺", tip: "Practice Pyramid Builder to master ancient construction")
                tipRow(icon: "🏆", tip: "Challenge yourself to beat your high scores")
            }
        }
        .padding(20)
        .egyptianCard()
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 0.8).delay(1.0), value: animateCards)
    }
    
    private func tipRow(icon: String, tip: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(icon)
                .font(.system(size: 20))
                .foregroundColor(EgyptianColors.golden)
            
            Text(tip)
                .font(EgyptianFonts.body())
                .foregroundColor(EgyptianColors.textDark.opacity(0.8))
                .lineSpacing(4)
        }
    }
    
    private func highScore(for game: GameType) -> Int {
        switch game {
        case .hieroglyphPuzzle:
            return appState.gameScores.hieroglyphPuzzleHighScore
        case .historyQuiz:
            return appState.gameScores.historyQuizHighScore
        case .pyramidBuilder:
            return appState.gameScores.pyramidBuilderHighScore
        }
    }
    
    @ViewBuilder
    private func gameView(for game: GameType) -> some View {
        switch game {
        case .hieroglyphPuzzle:
            HieroglyphPuzzleGameView()
                .environmentObject(appState)
        case .historyQuiz:
            HistoryQuizGameView()
                .environmentObject(appState)
        case .pyramidBuilder:
            PyramidBuilderGameView()
                .environmentObject(appState)
        }
    }
}

#Preview {
    GamesView()
        .environmentObject(AppState())
}

