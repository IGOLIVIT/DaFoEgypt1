//
//  PyramidBuilderGameView.swift
//  DaFoEgypt1
//
//  Created by IGOR on 29/08/2025.
//

import SwiftUI

struct PyramidBuilderGameView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentLevel = 0
    @State private var score = 0
    @State private var gameBlocks: [PyramidBlock] = []
    @State private var placedBlocks: [PyramidBlock] = []
    @State private var selectedBlock: PyramidBlock?
    @State private var gameOver = false
    @State private var showLevelComplete = false
    @State private var showGameComplete = false
    @State private var timeRemaining = 60
    @State private var timer: Timer?
    @State private var blockAnimation = false
    
    private let maxLevels = 7
    private let pyramidBaseY: CGFloat = 400
    
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
                
                // Game area
                if !gameOver && !showGameComplete {
                    gameAreaView
                } else if showGameComplete {
                    gameCompleteView
                } else {
                    gameOverView
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
            
            // Score and level
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 8) {
                    Text("Level:")
                        .font(EgyptianFonts.caption())
                        .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                    
                    Text("\(currentLevel + 1)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(EgyptianColors.hieroglyphGold)
                }
                
                HStack(spacing: 8) {
                    Text("Score:")
                        .font(EgyptianFonts.caption())
                        .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                    
                    Text("\(score)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(EgyptianColors.hieroglyphGold)
                }
            }
        }
        .padding(.top, 10)
    }
    
    @ViewBuilder
    private var gameAreaView: some View {
        VStack(spacing: 30) {
            // Timer and instructions
            gameInfoView
            
            // Pyramid building area
            pyramidAreaView
            
            // Available blocks
            availableBlocksView
            
            // Level complete overlay
            if showLevelComplete {
                levelCompleteOverlay
            }
        }
    }
    
    @ViewBuilder
    private var gameInfoView: some View {
        VStack(spacing: 16) {
            // Timer
            HStack {
                Image(systemName: "clock")
                    .font(.system(size: 16))
                    .foregroundColor(timeRemaining <= 15 ? EgyptianColors.deepRed : EgyptianColors.textLight)
                
                Text("\(timeRemaining)s")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(timeRemaining <= 15 ? EgyptianColors.deepRed : EgyptianColors.textLight)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(EgyptianColors.darkBrown.opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                timeRemaining <= 15 ? EgyptianColors.deepRed : EgyptianColors.golden.opacity(0.5),
                                lineWidth: 2
                            )
                    )
            )
            .scaleEffect(timeRemaining <= 15 ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.3), value: timeRemaining <= 15)
            
            // Instructions
            Text("Drag blocks to build level \(currentLevel + 1) of the pyramid")
                .font(EgyptianFonts.body())
                .foregroundColor(EgyptianColors.textLight.opacity(0.9))
                .multilineTextAlignment(.center)
        }
    }
    
    @ViewBuilder
    private var pyramidAreaView: some View {
        ZStack {
            // Pyramid foundation
            pyramidFoundation
            
            // Placed blocks
            ForEach(placedBlocks, id: \.id) { block in
                pyramidBlockView(block: block, isPlaced: true)
            }
            
            // Drop zones for current level
            ForEach(gameBlocks, id: \.id) { block in
                if !block.isPlaced {
                    dropZoneView(for: block)
                }
            }
        }
        .frame(height: 300)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(EgyptianColors.darkBrown.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(EgyptianColors.golden.opacity(0.3), lineWidth: 2)
                )
        )
    }
    
    @ViewBuilder
    private var pyramidFoundation: some View {
        // Desert sand base
        RoundedRectangle(cornerRadius: 8)
            .fill(EgyptianColors.desertSand)
            .frame(width: 320, height: 20)
            .position(x: 160, y: pyramidBaseY + 10)
    }
    
    private func dropZoneView(for block: PyramidBlock) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .stroke(EgyptianColors.golden.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [5]))
            .frame(width: block.size.width, height: block.size.height)
            .position(
                x: 160 + block.position.x,
                y: pyramidBaseY - block.position.y - block.size.height/2
            )
            .onTapGesture {
                if selectedBlock != nil {
                    placeSelectedBlock(at: block)
                }
            }
    }
    
    @ViewBuilder
    private var availableBlocksView: some View {
        VStack(spacing: 16) {
            Text("Available Blocks")
                .font(EgyptianFonts.headline())
                .foregroundColor(EgyptianColors.textLight)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(gameBlocks.filter { !$0.isPlaced }, id: \.id) { block in
                        draggableBlockView(block: block)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private func draggableBlockView(block: PyramidBlock) -> some View {
        pyramidBlockView(block: block, isPlaced: false)
            .scaleEffect(blockAnimation ? 1.05 : 1.0)
            .animation(
                .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                value: blockAnimation
            )
            .onTapGesture {
                selectBlock(block)
            }
            .overlay(
                selectedBlock?.id == block.id ?
                RoundedRectangle(cornerRadius: 4)
                    .stroke(EgyptianColors.golden, lineWidth: 3)
                : nil
            )
    }
    
    private func pyramidBlockView(block: PyramidBlock, isPlaced: Bool) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(
                LinearGradient(
                    colors: [
                        EgyptianColors.pyramidStone,
                        EgyptianColors.pyramidStone.opacity(0.8),
                        EgyptianColors.darkBrown.opacity(0.6)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(EgyptianColors.darkBrown.opacity(0.5), lineWidth: 1)
            )
            .overlay(
                // Hieroglyph decoration
                Text(["𓂀", "𓈖", "𓊪", "𓃭", "𓇳"].randomElement() ?? "𓂀")
                    .font(.system(size: 12))
                    .foregroundColor(EgyptianColors.darkBrown.opacity(0.7))
            )
            .frame(width: block.size.width, height: block.size.height)
            .shadow(
                color: EgyptianColors.darkBrown.opacity(0.3),
                radius: isPlaced ? 4 : 2,
                x: 0,
                y: isPlaced ? 2 : 1
            )
            .position(
                isPlaced ? 
                CGPoint(
                    x: 160 + block.position.x,
                    y: pyramidBaseY - block.position.y - block.size.height/2
                ) : 
                CGPoint(x: block.size.width/2, y: block.size.height/2)
            )
    }
    
    @ViewBuilder
    private var levelCompleteOverlay: some View {
        VStack(spacing: 20) {
            Text("🎉")
                .font(.system(size: 60))
            
            Text("Level \(currentLevel + 1) Complete!")
                .font(EgyptianFonts.title())
                .foregroundColor(EgyptianColors.textLight)
            
            Text("Well done! You've successfully built level \(currentLevel + 1) of the pyramid!")
                .font(EgyptianFonts.body())
                .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            
            Text("+\(levelScore) points")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(EgyptianColors.hieroglyphGold)
            
            Button("Continue Building") {
                nextLevel()
            }
            .egyptianButton()
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(EgyptianColors.darkBrown.opacity(0.9))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(EgyptianColors.golden, lineWidth: 2)
                )
        )
    }
    
    @ViewBuilder
    private var gameCompleteView: some View {
        VStack(spacing: 30) {
            Text("🏛️")
                .font(.system(size: 100))
                .foregroundColor(EgyptianColors.hieroglyphGold)
                .shadow(
                    color: EgyptianColors.hieroglyphGold.opacity(0.8),
                    radius: 20
                )
            
            Text("Master Builder!")
                .font(EgyptianFonts.title())
                .foregroundColor(EgyptianColors.textLight)
            
            Text("Congratulations! You've built a magnificent pyramid worthy of the greatest pharaohs!")
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
                
                Text("Levels Completed: \(maxLevels)")
                    .font(EgyptianFonts.body())
                    .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                
                // Achievement
                VStack(spacing: 4) {
                    Text(GameDataProvider.getAchievementTitle(for: .pyramidBuilder, score: maxLevels))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(EgyptianColors.golden)
                    
                    Text(GameDataProvider.getAchievementDescription(for: .pyramidBuilder, score: maxLevels))
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
                Button("Build Again") {
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
            Text("⏰")
                .font(.system(size: 80))
            
            Text("Time's Up!")
                .font(EgyptianFonts.title())
                .foregroundColor(EgyptianColors.textLight)
            
            Text("The desert sands have run out, but your pyramid building skills are improving!")
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
                
                Text("Levels Completed: \(currentLevel)")
                    .font(EgyptianFonts.body())
                    .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                
                // Achievement
                VStack(spacing: 4) {
                    Text(GameDataProvider.getAchievementTitle(for: .pyramidBuilder, score: currentLevel))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(EgyptianColors.golden)
                    
                    Text(GameDataProvider.getAchievementDescription(for: .pyramidBuilder, score: currentLevel))
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
    
    private var levelScore: Int {
        max(10, timeRemaining * 2)
    }
    
    private func startGame() {
        currentLevel = 0
        score = 0
        placedBlocks.removeAll()
        gameOver = false
        showGameComplete = false
        loadLevel()
    }
    
    private func loadLevel() {
        gameBlocks = GameDataProvider.generatePyramidLevel(currentLevel)
        startTimer()
        
        // Start block animation
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            blockAnimation = true
        }
    }
    
    private func startTimer() {
        timeRemaining = 60
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                // Time's up
                gameOver = true
                saveScore()
            }
        }
    }
    
    private func nextLevel() {
        showLevelComplete = false
        currentLevel += 1
        
        if currentLevel >= maxLevels {
            showGameComplete = true
            saveScore()
            return
        }
        
        // Add completed blocks to placed blocks
        for block in gameBlocks {
            if block.isPlaced {
                placedBlocks.append(block)
            }
        }
        
        loadLevel()
    }
    
    private func checkLevelComplete() {
        let allBlocksPlaced = gameBlocks.allSatisfy { $0.isPlaced }
        if allBlocksPlaced {
            timer?.invalidate()
            score += levelScore
            showLevelComplete = true
        }
    }
    
    private func restartGame() {
        timer?.invalidate()
        startGame()
    }
    
    private func saveScore() {
        timer?.invalidate()
        appState.updateGameScore(game: .pyramidBuilder, score: currentLevel)
    }
}

// MARK: - Block Selection Support
extension PyramidBuilderGameView {
    private func selectBlock(_ block: PyramidBlock) {
        selectedBlock = block
    }
    
    private func placeSelectedBlock(at targetBlock: PyramidBlock) {
        guard let selected = selectedBlock else { return }
        
        // Find the selected block in gameBlocks and mark it as placed
        for (index, gameBlock) in gameBlocks.enumerated() {
            if gameBlock.id == selected.id && !gameBlock.isPlaced {
                gameBlocks[index].isPlaced = true
                selectedBlock = nil
                checkLevelComplete()
                return
            }
        }
    }
}

#Preview {
    PyramidBuilderGameView()
        .environmentObject(AppState())
}
