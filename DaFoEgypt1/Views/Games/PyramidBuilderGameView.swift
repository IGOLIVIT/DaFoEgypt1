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
    @State private var pyramidLevels: [[PyramidBlock]] = []
    @State private var availableBlocks: [PyramidBlock] = []
    @State private var selectedBlock: PyramidBlock?
    @State private var gameOver = false
    @State private var showLevelComplete = false
    @State private var showGameComplete = false
    @State private var timeRemaining = 60
    @State private var timer: Timer?
    @State private var blockAnimation = false
    
    private let maxLevels = 5
    private let pyramidWidth: CGFloat = 280
    private let blockHeight: CGFloat = 35
    
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
                    
                    // Game area
                    if !gameOver && !showGameComplete {
                        gameAreaView
                    } else if showGameComplete {
                        gameCompleteView
                    } else {
                        gameOverView
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
            VStack(spacing: 8) {
                Text("Build level \(currentLevel + 1) of the pyramid")
                    .font(EgyptianFonts.body())
                    .foregroundColor(EgyptianColors.textLight.opacity(0.9))
                    .multilineTextAlignment(.center)
                
                HStack {
                    if selectedBlock != nil {
                        Image(systemName: "hand.tap.fill")
                            .foregroundColor(EgyptianColors.golden)
                        Text("Tap a golden zone with ⊕ to place the block")
                    } else {
                        Image(systemName: "hand.point.up.left.fill")
                            .foregroundColor(EgyptianColors.hieroglyphGold)
                        Text("First, tap a block below to select it")
                    }
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(selectedBlock != nil ? EgyptianColors.golden : EgyptianColors.hieroglyphGold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(EgyptianColors.darkBrown.opacity(0.3))
                )
                .animation(.easeInOut(duration: 0.3), value: selectedBlock != nil)
            }
        }
    }
    
    @ViewBuilder
    private var pyramidAreaView: some View {
        VStack(spacing: 0) {
            // Pyramid levels from top to bottom
            ForEach((0..<maxLevels).reversed(), id: \.self) { levelIndex in
                pyramidLevelView(levelIndex: levelIndex)
            }
            
            // Foundation
            pyramidFoundation
        }
        .frame(height: 250)
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
    private func pyramidLevelView(levelIndex: Int) -> some View {
        let blocksInLevel = maxLevels - levelIndex
        let blockWidth = pyramidWidth / CGFloat(maxLevels) // Base block width
        let levelWidth = blockWidth * CGFloat(blocksInLevel)
        
        HStack(spacing: 2) {
            ForEach(0..<blocksInLevel, id: \.self) { blockIndex in
                if let block = getPlacedBlock(levelIndex: levelIndex, blockIndex: blockIndex) {
                    // Placed block
                    pyramidBlockView(block: block, isPlaced: true)
                } else if levelIndex == currentLevel {
                    // Drop zone for current level
                    dropZoneView(levelIndex: levelIndex, blockIndex: blockIndex)
                } else {
                    // Empty space for future levels
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: blockWidth - 2, height: blockHeight)
                }
            }
        }
        .frame(width: levelWidth)
    }
    
    @ViewBuilder
    private var pyramidFoundation: some View {
        // Desert sand base
        RoundedRectangle(cornerRadius: 8)
            .fill(EgyptianColors.desertSand)
            .frame(width: pyramidWidth + 20, height: 20)
    }
    
    @ViewBuilder
    private func dropZoneView(levelIndex: Int, blockIndex: Int) -> some View {
        let blockWidth = pyramidWidth / CGFloat(maxLevels)
        
        Button(action: {
            if let selected = selectedBlock {
                placeBlock(selected, at: levelIndex, blockIndex: blockIndex)
            }
        }) {
            RoundedRectangle(cornerRadius: 6)
                .fill(
                    selectedBlock != nil ? 
                    EgyptianColors.golden.opacity(0.2) : 
                    Color.clear
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(
                            selectedBlock != nil ? EgyptianColors.golden : EgyptianColors.golden.opacity(0.4), 
                            style: StrokeStyle(lineWidth: selectedBlock != nil ? 3 : 2, dash: [8, 4])
                        )
                )
                .overlay(
                    // Plus icon when block is selected
                    selectedBlock != nil ? 
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(EgyptianColors.golden)
                    : nil
                )
                .frame(width: blockWidth + 4, height: blockHeight + 8) // Увеличиваем зону нажатия
                .scaleEffect(selectedBlock != nil ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: selectedBlock != nil)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(selectedBlock == nil)
    }
    
    private func getPlacedBlock(levelIndex: Int, blockIndex: Int) -> PyramidBlock? {
        guard levelIndex < pyramidLevels.count else { return nil }
        guard blockIndex < pyramidLevels[levelIndex].count else { return nil }
        let block = pyramidLevels[levelIndex][blockIndex]
        return block.isPlaced ? block : nil
    }
    
    @ViewBuilder
    private var availableBlocksView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Available Blocks")
                    .font(EgyptianFonts.headline())
                    .foregroundColor(EgyptianColors.textLight)
                    .minimumScaleFactor(0.8)
                
                Spacer()
                
                Text("Need: \(blocksNeededForCurrentLevel)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(EgyptianColors.hieroglyphGold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(EgyptianColors.golden.opacity(0.2))
                    )
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(availableBlocks, id: \.id) { block in
                        draggableBlockView(block: block)
                    }
                }
                .padding(.horizontal, 20)
            }
            .frame(height: 70)
        }
    }
    
    private var blocksNeededForCurrentLevel: Int {
        maxLevels - currentLevel
    }
    
    private func draggableBlockView(block: PyramidBlock) -> some View {
        Button(action: {
            selectBlock(block)
        }) {
            pyramidBlockView(block: block, isPlaced: false)
                .scaleEffect(blockAnimation ? 1.05 : 1.0)
                .animation(
                    .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                    value: blockAnimation
                )
                .overlay(
                    selectedBlock?.id == block.id ?
                    AnyView(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(EgyptianColors.golden, lineWidth: 4)
                            .shadow(color: EgyptianColors.golden.opacity(0.6), radius: 8)
                    )
                    : AnyView(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(EgyptianColors.golden.opacity(0.3), lineWidth: 2)
                    )
                )
                .scaleEffect(selectedBlock?.id == block.id ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: selectedBlock?.id == block.id)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func pyramidBlockView(block: PyramidBlock, isPlaced: Bool) -> some View {
        let blockWidth = isPlaced ? (pyramidWidth / CGFloat(maxLevels)) : 50
        let blockHeight = isPlaced ? self.blockHeight : 40
        
        return RoundedRectangle(cornerRadius: 4)
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
                Text(block.hieroglyph)
                    .font(.system(size: isPlaced ? 14 : 16))
                    .foregroundColor(EgyptianColors.darkBrown.opacity(0.7))
            )
            .frame(width: blockWidth - 2, height: blockHeight)
            .shadow(
                color: EgyptianColors.darkBrown.opacity(0.3),
                radius: isPlaced ? 4 : 2,
                x: 0,
                y: isPlaced ? 2 : 1
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
        pyramidLevels = []
        availableBlocks = []
        gameOver = false
        showGameComplete = false
        initializePyramid()
        loadLevel()
    }
    
    private func initializePyramid() {
        pyramidLevels = []
        for levelIndex in 0..<maxLevels {
            let blocksInLevel = maxLevels - levelIndex
            var levelBlocks: [PyramidBlock] = []
            
            for _ in 0..<blocksInLevel {
                let block = PyramidBlock(
                    position: CGPoint.zero,
                    size: CGSize(width: 50, height: 35),
                    isPlaced: false,
                    level: levelIndex,
                    hieroglyph: ["𓂀", "𓈖", "𓊪", "𓃭", "𓇳", "𓅃", "𓊽", "𓂧"].randomElement() ?? "𓂀"
                )
                levelBlocks.append(block)
            }
            pyramidLevels.append(levelBlocks)
        }
    }
    
    private func loadLevel() {
        // Generate available blocks for current level
        let blocksNeeded = maxLevels - currentLevel
        availableBlocks = []
        
        let hieroglyphs = ["𓂀", "𓈖", "𓊪", "𓃭", "𓇳", "𓅃", "𓊽", "𓂧", "𓄿", "𓃀"]
        
        for _ in 0..<blocksNeeded {
            let block = PyramidBlock(
                position: CGPoint.zero,
                size: CGSize(width: 60, height: 50),
                isPlaced: false,
                level: currentLevel,
                hieroglyph: hieroglyphs.randomElement() ?? "𓂀"
            )
            availableBlocks.append(block)
        }
        
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
    
    private func placeBlock(_ block: PyramidBlock, at levelIndex: Int, blockIndex: Int) {
        // Make sure we're placing on the current level
        guard levelIndex == currentLevel else { return }
        
        // Place the block in the pyramid
        pyramidLevels[levelIndex][blockIndex] = PyramidBlock(
            id: block.id,
            position: block.position,
            size: block.size,
            isPlaced: true,
            level: levelIndex,
            hieroglyph: block.hieroglyph
        )
        
        // Remove from available blocks
        availableBlocks.removeAll { $0.id == block.id }
        selectedBlock = nil
        
        checkLevelComplete()
    }
    
    private func checkLevelComplete() {
        // Check if current level is complete
        let currentLevelBlocks = pyramidLevels[currentLevel]
        let allPlaced = currentLevelBlocks.allSatisfy { $0.isPlaced }
        
        if allPlaced {
            timer?.invalidate()
            score += levelScore
            showLevelComplete = true
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
        
        loadLevel()
    }
}

#Preview {
    PyramidBuilderGameView()
        .environmentObject(AppState())
}
