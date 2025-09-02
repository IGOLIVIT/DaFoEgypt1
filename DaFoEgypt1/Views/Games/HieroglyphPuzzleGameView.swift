//
//  HieroglyphPuzzleGameView.swift
//  DaFoEgypt1
//
//  Created by IGOR on 29/08/2025.
//

import SwiftUI

struct HieroglyphPuzzleGameView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentPuzzle: HieroglyphPuzzle?
    @State private var currentPuzzleIndex = 0
    @State private var score = 0
    @State private var lives = 3
    @State private var selectedAnswer: String?
    @State private var showResult = false
    @State private var isCorrect = false
    @State private var gameOver = false
    @State private var showGameComplete = false
    @State private var puzzles: [HieroglyphPuzzle] = []
    @State private var animateHieroglyph = false
    @State private var timeRemaining = 30
    @State private var timer: Timer?
    
    private let totalPuzzles = 10
    
    var body: some View {
        ZStack {
            // Background
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
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // Header
                    headerView
                    
                    // Game content
                    if gameOver {
                        gameOverView
                    } else if showGameComplete {
                        gameCompleteView
                    } else {
                        gameContentView
                    }
                    
                    // Add some bottom padding for better scrolling
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
        }
        .onAppear {
            startGame()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    @ViewBuilder
    private var headerView: some View {
        HStack {
            // Close button
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(EgyptianColors.textLight.opacity(0.8))
            }
            
            Spacer()
            
            // Score and lives
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 8) {
                    Text("Score:")
                        .font(EgyptianFonts.caption())
                        .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                    
                    Text("\(score)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(EgyptianColors.hieroglyphGold)
                }
                
                HStack(spacing: 8) {
                    Text("Lives:")
                        .font(EgyptianFonts.caption())
                        .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                    
                    HStack(spacing: 4) {
                        ForEach(0..<3, id: \.self) { index in
                            Image(systemName: index < lives ? "heart.fill" : "heart")
                                .font(.system(size: 14))
                                .foregroundColor(index < lives ? EgyptianColors.deepRed : EgyptianColors.textLight.opacity(0.3))
                        }
                    }
                }
            }
        }
        .padding(.top, 10)
    }
    
    @ViewBuilder
    private var gameContentView: some View {
        VStack(spacing: 30) {
            // Progress and timer
            gameInfoView
            
            // Current hieroglyph
            if let puzzle = currentPuzzle {
                hieroglyphView(puzzle: puzzle)
            }
            
            // Answer options
            if let puzzle = currentPuzzle {
                answerOptionsView(puzzle: puzzle)
            }
            
            // Result feedback
            if showResult {
                resultFeedbackView
            }
        }
    }
    
    @ViewBuilder
    private var gameInfoView: some View {
        VStack(spacing: 16) {
            // Progress
            HStack {
                Text("Puzzle \(currentPuzzleIndex + 1) of \(totalPuzzles)")
                    .font(EgyptianFonts.body())
                    .foregroundColor(EgyptianColors.textLight)
                
                Spacer()
                
                // Timer
                HStack {
                    Image(systemName: "clock")
                        .font(.system(size: 16))
                        .foregroundColor(timeRemaining <= 10 ? EgyptianColors.deepRed : EgyptianColors.textLight)
                    
                    Text("\(timeRemaining)s")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(timeRemaining <= 10 ? EgyptianColors.deepRed : EgyptianColors.textLight)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(EgyptianColors.darkBrown.opacity(0.5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    timeRemaining <= 10 ? EgyptianColors.deepRed : EgyptianColors.golden.opacity(0.5),
                                    lineWidth: 1
                                )
                        )
                )
                .scaleEffect(timeRemaining <= 10 ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: timeRemaining <= 10)
            }
            
            // Progress bar
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(EgyptianColors.textLight.opacity(0.3))
                    .frame(height: 8)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [EgyptianColors.hieroglyphGold, EgyptianColors.golden],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: CGFloat(currentPuzzleIndex) / CGFloat(totalPuzzles) * UIScreen.main.bounds.width * 0.7, height: 8)
                    .animation(.linear(duration: 0.5), value: currentPuzzleIndex)
            }
            .frame(width: UIScreen.main.bounds.width * 0.7)
        }
    }
    
    private func hieroglyphView(puzzle: HieroglyphPuzzle) -> some View {
        VStack(spacing: 20) {
            Text("What does this hieroglyph mean?")
                .font(EgyptianFonts.headline())
                .foregroundColor(EgyptianColors.textLight)
                .multilineTextAlignment(.center)
            
            Text(puzzle.hieroglyph)
                .font(.system(size: 120))
                .foregroundColor(EgyptianColors.hieroglyphGold)
                .scaleEffect(animateHieroglyph ? 1.1 : 1.0)
                .shadow(
                    color: EgyptianColors.hieroglyphGold.opacity(0.5),
                    radius: 20
                )
                .animation(
                    .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                    value: animateHieroglyph
                )
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(EgyptianColors.darkBrown.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(EgyptianColors.golden.opacity(0.3), lineWidth: 2)
                )
        )
    }
    
    private func answerOptionsView(puzzle: HieroglyphPuzzle) -> some View {
        VStack(spacing: 16) {
            ForEach(puzzle.options, id: \.self) { option in
                answerButton(option: option, puzzle: puzzle)
            }
        }
    }
    
    private func answerButton(option: String, puzzle: HieroglyphPuzzle) -> some View {
        Button(action: {
            selectAnswer(option, puzzle: puzzle)
        }) {
            HStack {
                Text(option)
                    .font(EgyptianFonts.body())
                    .foregroundColor(
                        selectedAnswer == option ? 
                        EgyptianColors.textLight : 
                        EgyptianColors.textDark
                    )
                
                Spacer()
                
                if selectedAnswer == option && showResult {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(isCorrect ? EgyptianColors.turquoise : EgyptianColors.deepRed)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        selectedAnswer == option ? 
                        (showResult ? 
                         (isCorrect ? EgyptianColors.turquoise.opacity(0.8) : EgyptianColors.deepRed.opacity(0.8)) :
                         EgyptianColors.golden) :
                        EgyptianColors.papyrus
                    )
                    .shadow(
                        color: EgyptianColors.darkBrown.opacity(0.2),
                        radius: 4,
                        x: 0,
                        y: 2
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(showResult)
    }
    
    @ViewBuilder
    private var resultFeedbackView: some View {
        VStack(spacing: 16) {
            Text(isCorrect ? "Correct!" : "Incorrect!")
                .font(EgyptianFonts.headline())
                .foregroundColor(isCorrect ? EgyptianColors.turquoise : EgyptianColors.deepRed)
            
            if let puzzle = currentPuzzle {
                Text("The hieroglyph \(puzzle.hieroglyph) means \"\(puzzle.meaning)\"")
                    .font(EgyptianFonts.body())
                    .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            if isCorrect {
                Text("+\(puzzleScore) points")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(EgyptianColors.hieroglyphGold)
            }
            
            Button("Next Puzzle") {
                nextPuzzle()
            }
            .egyptianButton()
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(EgyptianColors.darkBrown.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(EgyptianColors.golden, lineWidth: 2)
                )
        )
    }
    
    @ViewBuilder
    private var gameCompleteView: some View {
        VStack(spacing: 30) {
            Text("🏆")
                .font(.system(size: 100))
                .foregroundColor(EgyptianColors.hieroglyphGold)
                .shadow(
                    color: EgyptianColors.hieroglyphGold.opacity(0.8),
                    radius: 20
                )
            
            Text("Master Scribe!")
                .font(EgyptianFonts.title())
                .foregroundColor(EgyptianColors.textLight)
            
            Text("Congratulations! You've mastered the ancient art of hieroglyphic reading!")
                .font(EgyptianFonts.body())
                .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            
            // Final score
            VStack(spacing: 12) {
                Text("Final Score")
                    .font(EgyptianFonts.headline())
                    .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                
                Text("\(score)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(EgyptianColors.hieroglyphGold)
                
                Text("Puzzles Solved: \(totalPuzzles)")
                    .font(EgyptianFonts.body())
                    .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                
                // Achievement
                VStack(spacing: 4) {
                    Text(GameDataProvider.getAchievementTitle(for: .hieroglyphPuzzle, score: score))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(EgyptianColors.golden)
                    
                    Text(GameDataProvider.getAchievementDescription(for: .hieroglyphPuzzle, score: score))
                        .font(EgyptianFonts.body())
                        .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(EgyptianColors.darkBrown.opacity(0.5))
            )
            
            // Buttons
            VStack(spacing: 16) {
                Button("Play Again") {
                    restartGame()
                }
                .egyptianButton()
                
                Button("Back to Games") {
                    dismiss()
                }
                .egyptianButton(secondary: true)
            }
        }
    }
    
    @ViewBuilder
    private var gameOverView: some View {
        VStack(spacing: 30) {
            Text("💀")
                .font(.system(size: 80))
            
            Text("Game Over")
                .font(EgyptianFonts.title())
                .foregroundColor(EgyptianColors.textLight)
            
            Text("The ancient scribes would be proud of your effort! Keep practicing to master the hieroglyphs.")
                .font(EgyptianFonts.body())
                .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            
            // Final score
            VStack(spacing: 12) {
                Text("Final Score")
                    .font(EgyptianFonts.headline())
                    .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                
                Text("\(score)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(EgyptianColors.hieroglyphGold)
                
                Text("Puzzles Solved: \(currentPuzzleIndex)")
                    .font(EgyptianFonts.body())
                    .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                
                // Achievement
                VStack(spacing: 4) {
                    Text(GameDataProvider.getAchievementTitle(for: .hieroglyphPuzzle, score: score))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(EgyptianColors.golden)
                    
                    Text(GameDataProvider.getAchievementDescription(for: .hieroglyphPuzzle, score: score))
                        .font(EgyptianFonts.body())
                        .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(EgyptianColors.darkBrown.opacity(0.5))
            )
            
            // Buttons
            VStack(spacing: 16) {
                Button("Try Again") {
                    restartGame()
                }
                .egyptianButton()
                
                Button("Back to Games") {
                    dismiss()
                }
                .egyptianButton(secondary: true)
            }
        }
    }
    
    private var puzzleScore: Int {
        max(5, timeRemaining)
    }
    
    private func startGame() {
        puzzles = GameDataProvider.hieroglyphPuzzles.shuffled()
        currentPuzzleIndex = 0
        score = 0
        lives = 3
        gameOver = false
        showGameComplete = false
        loadNextPuzzle()
    }
    
    private func loadNextPuzzle() {
        guard currentPuzzleIndex < min(totalPuzzles, puzzles.count) else {
            completeGame()
            return
        }
        
        currentPuzzle = puzzles[currentPuzzleIndex]
        selectedAnswer = nil
        showResult = false
        timeRemaining = 30
        
        // Start animation
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            animateHieroglyph = true
        }
        
        startTimer()
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                // Time's up - treat as wrong answer
                selectAnswer("", puzzle: currentPuzzle!)
            }
        }
    }
    
    private func selectAnswer(_ answer: String, puzzle: HieroglyphPuzzle) {
        timer?.invalidate()
        selectedAnswer = answer
        isCorrect = answer == puzzle.correctAnswer
        
        if isCorrect {
            score += puzzleScore
        } else {
            lives -= 1
            if lives <= 0 {
                gameOver = true
                saveScore()
                return
            }
        }
        
        withAnimation(.easeInOut(duration: 0.5)) {
            showResult = true
        }
    }
    
    private func nextPuzzle() {
        currentPuzzleIndex += 1
        loadNextPuzzle()
    }
    
    private func completeGame() {
        showGameComplete = true
        saveScore()
    }
    
    private func restartGame() {
        timer?.invalidate()
        startGame()
    }
    
    private func saveScore() {
        timer?.invalidate()
        appState.updateGameScore(game: .hieroglyphPuzzle, score: score)
    }
}

#Preview {
    HieroglyphPuzzleGameView()
        .environmentObject(AppState())
}
