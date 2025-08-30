//
//  HistoryQuizGameView.swift
//  DaFoEgypt1
//
//  Created by IGOR on 29/08/2025.
//

import SwiftUI

struct HistoryQuizGameView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentQuestion: QuizQuestion?
    @State private var currentQuestionIndex = 0
    @State private var score = 0
    @State private var selectedAnswer: Int?
    @State private var showResult = false
    @State private var isCorrect = false
    @State private var gameOver = false
    @State private var showGameComplete = false
    @State private var questions: [QuizQuestion] = []
    @State private var timeRemaining = 45
    @State private var timer: Timer?
    @State private var streakCount = 0
    @State private var maxStreak = 0
    
    private let totalQuestions = 15
    
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
                
                Spacer()
            }
            .padding(.horizontal, 20)
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
            
            // Score and streak
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
                    Text("Streak:")
                        .font(EgyptianFonts.caption())
                        .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                    
                    Text("\(streakCount)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(streakCount > 0 ? EgyptianColors.turquoise : EgyptianColors.textLight.opacity(0.5))
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
            
            // Current question
            if let question = currentQuestion {
                questionView(question: question)
            }
            
            // Answer options
            if let question = currentQuestion {
                answerOptionsView(question: question)
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
                Text("Question \(currentQuestionIndex + 1) of \(totalQuestions)")
                    .font(EgyptianFonts.body())
                    .foregroundColor(EgyptianColors.textLight)
                
                Spacer()
                
                // Difficulty indicator
                if let question = currentQuestion {
                    HStack(spacing: 4) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(
                                    index < difficultyLevel(question.difficulty) ? 
                                    EgyptianColors.golden : 
                                    EgyptianColors.textLight.opacity(0.3)
                                )
                                .frame(width: 8, height: 8)
                        }
                        
                        Text(question.difficulty.rawValue)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(EgyptianColors.golden)
                    }
                }
                
                Spacer()
                
                // Timer
                HStack {
                    Image(systemName: "clock")
                        .font(.system(size: 16))
                        .foregroundColor(timeRemaining <= 15 ? EgyptianColors.deepRed : EgyptianColors.textLight)
                    
                    Text("\(timeRemaining)s")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(timeRemaining <= 15 ? EgyptianColors.deepRed : EgyptianColors.textLight)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(EgyptianColors.darkBrown.opacity(0.5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    timeRemaining <= 15 ? EgyptianColors.deepRed : EgyptianColors.golden.opacity(0.5),
                                    lineWidth: 1
                                )
                        )
                )
                .scaleEffect(timeRemaining <= 15 ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: timeRemaining <= 15)
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
                    .frame(width: CGFloat(currentQuestionIndex) / CGFloat(totalQuestions) * UIScreen.main.bounds.width * 0.7, height: 8)
                    .animation(.linear(duration: 0.5), value: currentQuestionIndex)
            }
            .frame(width: UIScreen.main.bounds.width * 0.7)
        }
    }
    
    private func questionView(question: QuizQuestion) -> some View {
        VStack(spacing: 20) {
            // Question icon based on difficulty
            Text(difficultyIcon(question.difficulty))
                .font(.system(size: 40))
            
            Text(question.question)
                .font(EgyptianFonts.headline())
                .foregroundColor(EgyptianColors.textLight)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
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
    
    private func answerOptionsView(question: QuizQuestion) -> some View {
        VStack(spacing: 16) {
            ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                answerButton(option: option, index: index, question: question)
            }
        }
    }
    
    private func answerButton(option: String, index: Int, question: QuizQuestion) -> some View {
        Button(action: {
            selectAnswer(index, question: question)
        }) {
            HStack {
                // Option letter
                Text("\(Character(UnicodeScalar(65 + index)!))")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(
                        selectedAnswer == index ? 
                        EgyptianColors.textLight : 
                        EgyptianColors.golden
                    )
                    .frame(width: 30, height: 30)
                    .background(
                        Circle()
                            .fill(
                                selectedAnswer == index ? 
                                EgyptianColors.golden.opacity(0.3) : 
                                EgyptianColors.golden.opacity(0.1)
                            )
                    )
                
                Text(option)
                    .font(EgyptianFonts.body())
                    .foregroundColor(
                        selectedAnswer == index ? 
                        EgyptianColors.textLight : 
                        EgyptianColors.textDark
                    )
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if selectedAnswer == index && showResult {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(isCorrect ? EgyptianColors.turquoise : EgyptianColors.deepRed)
                } else if showResult && index == question.correctAnswer {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(EgyptianColors.turquoise)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        selectedAnswer == index ? 
                        (showResult ? 
                         (isCorrect ? EgyptianColors.turquoise.opacity(0.8) : EgyptianColors.deepRed.opacity(0.8)) :
                         EgyptianColors.golden.opacity(0.8)) :
                        (showResult && index == question.correctAnswer ? 
                         EgyptianColors.turquoise.opacity(0.3) : 
                         EgyptianColors.papyrus)
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
            
            if let question = currentQuestion {
                Text(question.explanation)
                    .font(EgyptianFonts.body())
                    .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            if isCorrect {
                VStack(spacing: 8) {
                    Text("+\(questionScore) points")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(EgyptianColors.hieroglyphGold)
                    
                    if streakCount > 1 {
                        Text("🔥 \(streakCount) streak!")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(EgyptianColors.turquoise)
                    }
                }
            }
            
            Button("Next Question") {
                nextQuestion()
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
            
            Text("Pharaoh's Advisor!")
                .font(EgyptianFonts.title())
                .foregroundColor(EgyptianColors.textLight)
            
            Text("Congratulations! Your knowledge of ancient Egypt rivals that of the greatest scholars!")
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
                
                HStack(spacing: 30) {
                    VStack(spacing: 4) {
                        Text("Questions")
                            .font(EgyptianFonts.caption())
                            .foregroundColor(EgyptianColors.textLight.opacity(0.6))
                        Text("\(totalQuestions)")
                            .font(EgyptianFonts.body())
                            .foregroundColor(EgyptianColors.textLight)
                    }
                    
                    VStack(spacing: 4) {
                        Text("Max Streak")
                            .font(EgyptianFonts.caption())
                            .foregroundColor(EgyptianColors.textLight.opacity(0.6))
                        Text("\(maxStreak)")
                            .font(EgyptianFonts.body())
                            .foregroundColor(EgyptianColors.turquoise)
                    }
                }
                
                // Achievement
                VStack(spacing: 4) {
                    Text(GameDataProvider.getAchievementTitle(for: .historyQuiz, score: score))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(EgyptianColors.golden)
                    
                    Text(GameDataProvider.getAchievementDescription(for: .historyQuiz, score: score))
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
            Text("📚")
                .font(.system(size: 80))
            
            Text("Quiz Complete!")
                .font(EgyptianFonts.title())
                .foregroundColor(EgyptianColors.textLight)
            
            Text("Well done! You've shown great knowledge of ancient Egyptian history. Keep learning to become a true scholar!")
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
                
                HStack(spacing: 30) {
                    VStack(spacing: 4) {
                        Text("Questions")
                            .font(EgyptianFonts.caption())
                            .foregroundColor(EgyptianColors.textLight.opacity(0.6))
                        Text("\(currentQuestionIndex)")
                            .font(EgyptianFonts.body())
                            .foregroundColor(EgyptianColors.textLight)
                    }
                    
                    VStack(spacing: 4) {
                        Text("Max Streak")
                            .font(EgyptianFonts.caption())
                            .foregroundColor(EgyptianColors.textLight.opacity(0.6))
                        Text("\(maxStreak)")
                            .font(EgyptianFonts.body())
                            .foregroundColor(EgyptianColors.turquoise)
                    }
                }
                
                // Achievement
                VStack(spacing: 4) {
                    Text(GameDataProvider.getAchievementTitle(for: .historyQuiz, score: score))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(EgyptianColors.golden)
                    
                    Text(GameDataProvider.getAchievementDescription(for: .historyQuiz, score: score))
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
    
    private var questionScore: Int {
        guard let question = currentQuestion else { return 0 }
        let baseScore = question.difficulty.points
        let timeBonus = max(0, timeRemaining / 5)
        let streakBonus = streakCount > 1 ? streakCount * 2 : 0
        return baseScore + timeBonus + streakBonus
    }
    
    private func difficultyLevel(_ difficulty: QuizDifficulty) -> Int {
        switch difficulty {
        case .easy: return 1
        case .medium: return 2
        case .hard: return 3
        }
    }
    
    private func difficultyIcon(_ difficulty: QuizDifficulty) -> String {
        switch difficulty {
        case .easy: return "📖"
        case .medium: return "🏛️"
        case .hard: return "👑"
        }
    }
    
    private func startGame() {
        questions = GameDataProvider.quizQuestions.shuffled()
        currentQuestionIndex = 0
        score = 0
        streakCount = 0
        maxStreak = 0
        gameOver = false
        showGameComplete = false
        loadNextQuestion()
    }
    
    private func loadNextQuestion() {
        guard currentQuestionIndex < min(totalQuestions, questions.count) else {
            completeGame()
            return
        }
        
        currentQuestion = questions[currentQuestionIndex]
        selectedAnswer = nil
        showResult = false
        timeRemaining = 45
        
        startTimer()
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                // Time's up - treat as wrong answer
                selectAnswer(-1, question: currentQuestion!)
            }
        }
    }
    
    private func selectAnswer(_ answer: Int, question: QuizQuestion) {
        timer?.invalidate()
        selectedAnswer = answer
        isCorrect = answer == question.correctAnswer
        
        if isCorrect {
            score += questionScore
            streakCount += 1
            maxStreak = max(maxStreak, streakCount)
        } else {
            streakCount = 0
        }
        
        withAnimation(.easeInOut(duration: 0.5)) {
            showResult = true
        }
    }
    
    private func nextQuestion() {
        currentQuestionIndex += 1
        loadNextQuestion()
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
        appState.updateGameScore(game: .historyQuiz, score: score)
    }
}

#Preview {
    HistoryQuizGameView()
        .environmentObject(AppState())
}
