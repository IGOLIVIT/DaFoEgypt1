//
//  MeditationPlayerView.swift
//  DaFoEgypt1
//
//  Created by IGOR on 29/08/2025.
//

import SwiftUI
import AVFoundation
import AudioToolbox

struct MeditationPlayerView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    let meditation: MeditationType
    
    @State private var isPlaying = false
    @State private var currentTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var showCompletion = false
    @State private var breatheScale: CGFloat = 1.0
    @State private var glowIntensity: Double = 0.3
    @State private var audioPlayer: AVAudioPlayer?
    @State private var viewAppeared = false
    @State private var backgroundReady = true // Фон всегда готов
    
    init(meditation: MeditationType) {
        self.meditation = meditation
        // Принудительная инициализация анимации
        self._breatheScale = State(initialValue: 1.0)
        self._glowIntensity = State(initialValue: 0.3)
        self._backgroundReady = State(initialValue: true)
    }
    
    private var progress: Double {
        meditation.duration > 0 ? currentTime / meditation.duration : 0
    }
    
    private var remainingTime: TimeInterval {
        max(0, meditation.duration - currentTime)
    }
    
    var body: some View {
        ZStack {
            // Принудительно устанавливаем фон сразу
            Color.blue
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header
                headerView
                
                Spacer()
                
                // Main meditation visual
                meditationVisual
                
                Spacer()
                
                // Progress and time
                progressView
                
                // Controls
                controlsView
                
                Spacer()
            }
            .padding(.horizontal, 32)
        }
        .onAppear {
            if !viewAppeared {
                viewAppeared = true
                // Запускаем анимацию сразу
                DispatchQueue.main.async {
                    setupMeditation()
                }
            }
        }
        .onDisappear {
            stopMeditation()
        }
        .sheet(isPresented: $showCompletion) {
            MeditationCompletionView(meditation: meditation)
                .environmentObject(appState)
        }
    }
    
    // Простой цветной фон с системными цветами
    private var backgroundColor: Color {
        switch meditation {
        case .pyramidVisualization:
            return Color.indigo
        case .nileMeditation:
            return Color.blue
        case .sunRaMeditation:
            return Color.orange
        case .ancientWisdom:
            return Color.brown
        }
    }
    

    

    
    @ViewBuilder
    private var headerView: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(EgyptianColors.textLight.opacity(0.8))
            }
            
            Spacer()
            
            VStack {
                Text(meditation.rawValue)
                    .font(EgyptianFonts.headline())
                    .foregroundColor(EgyptianColors.textLight)
                
                Text(meditation.description)
                    .font(EgyptianFonts.caption())
                    .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Placeholder for symmetry
            Color.clear
                .frame(width: 24, height: 24)
        }
    }
    
    @ViewBuilder
    private var meditationVisual: some View {
        ZStack {
            // Breathing circle
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            EgyptianColors.hieroglyphGold.opacity(0.3),
                            EgyptianColors.golden.opacity(0.1),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 20,
                        endRadius: 120
                    )
                )
                .frame(width: 200, height: 200)
                .scaleEffect(breatheScale)
                .shadow(
                    color: EgyptianColors.hieroglyphGold.opacity(glowIntensity),
                    radius: 20
                )
                .animation(
                    .easeInOut(duration: 4.0).repeatForever(autoreverses: true),
                    value: breatheScale
                )
            
            // Meditation symbol
            Text(meditation.icon)
                .font(.system(size: 80))
                .foregroundColor(EgyptianColors.textLight)
                .shadow(
                    color: EgyptianColors.hieroglyphGold.opacity(0.5),
                    radius: 10
                )
            
            // Breathing instruction
            if isPlaying {
                VStack {
                    Spacer()
                    
                    Text(breatheScale > 1.0 ? "Breathe In" : "Breathe Out")
                        .font(EgyptianFonts.body())
                        .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                        .padding(.top, 100)
                }
            }
        }
        .onAppear {
            startBreathingAnimation()
        }
    }
    
    @ViewBuilder
    private var progressView: some View {
        VStack(spacing: 16) {
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
                    .frame(width: CGFloat(progress) * UIScreen.main.bounds.width * 0.7, height: 8)
                    .animation(.linear(duration: 0.5), value: progress)
            }
            .frame(width: UIScreen.main.bounds.width * 0.7)
            
            // Time display
            HStack {
                Text(timeString(from: currentTime))
                    .font(EgyptianFonts.body())
                    .foregroundColor(EgyptianColors.textLight)
                
                Spacer()
                
                Text(timeString(from: remainingTime))
                    .font(EgyptianFonts.body())
                    .foregroundColor(EgyptianColors.textLight.opacity(0.8))
            }
            .frame(width: UIScreen.main.bounds.width * 0.7)
        }
    }
    
    @ViewBuilder
    private var controlsView: some View {
        HStack(spacing: 40) {
            // Restart button
            Button(action: {
                restartMeditation()
            }) {
                Image(systemName: "gobackward")
                    .font(.system(size: 24))
                    .foregroundColor(EgyptianColors.textLight.opacity(0.8))
            }
            
            // Play/Pause button
            Button(action: {
                if isPlaying {
                    pauseMeditation()
                } else {
                    startMeditation()
                }
            }) {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(EgyptianColors.hieroglyphGold)
                    .shadow(
                        color: EgyptianColors.hieroglyphGold.opacity(0.5),
                        radius: 10
                    )
            }
            
            // Forward button (skip 30 seconds)
            Button(action: {
                skipForward()
            }) {
                Image(systemName: "goforward.30")
                    .font(.system(size: 24))
                    .foregroundColor(EgyptianColors.textLight.opacity(0.8))
            }
        }
    }
    
    private func setupMeditation() {
        startBreathingAnimation()
        setupAudio()
    }
    
    private func startBreathingAnimation() {
        withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
            breatheScale = 1.3
        }
        
        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
            glowIntensity = 0.8
        }
    }
    
    private func setupAudio() {
        // Настраиваем аудио сессию для медитации
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Ошибка настройки аудио: \(error)")
        }
    }
    
    private func playMeditationSound() {
        // Воспроизводим системный звук для обратной связи
        AudioServicesPlaySystemSound(1103) // Тихий звук уведомления
    }
    
    private func playCompletionSound() {
        // Звук завершения медитации
        AudioServicesPlaySystemSound(1016) // Звук успеха
    }
    
    private func startMeditation() {
        isPlaying = true
        playMeditationSound() // Звук начала медитации
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            currentTime += 1
            
            if currentTime >= meditation.duration {
                completeMeditation()
            }
        }
    }
    
    private func pauseMeditation() {
        isPlaying = false
        timer?.invalidate()
        timer = nil
    }
    
    private func stopMeditation() {
        isPlaying = false
        timer?.invalidate()
        timer = nil
    }
    
    private func restartMeditation() {
        currentTime = 0
        if isPlaying {
            startMeditation()
        }
    }
    
    private func skipForward() {
        currentTime = min(currentTime + 30, meditation.duration)
        if currentTime >= meditation.duration {
            completeMeditation()
        }
    }
    
    private func completeMeditation() {
        stopMeditation()
        playCompletionSound() // Звук завершения медитации
        
        // Save meditation session
        let session = MeditationSession(
            type: meditation,
            duration: meditation.duration,
            date: Date(),
            completed: true
        )
        appState.addMeditationSession(session)
        
        showCompletion = true
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct MeditationCompletionView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    
    let meditation: MeditationType
    
    @State private var showCelebration = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [EgyptianColors.nightSky, EgyptianColors.darkBrown],
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
                
                Text("Meditation Complete!")
                    .font(EgyptianFonts.title())
                    .foregroundColor(EgyptianColors.textLight)
                    .multilineTextAlignment(.center)
                
                Text("You have completed the \(meditation.rawValue) meditation. The ancient wisdom flows through you.")
                    .font(EgyptianFonts.body())
                    .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                
                // Stats
                VStack(spacing: 12) {
                    HStack {
                        Text("Duration:")
                            .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                        Spacer()
                        Text("\(Int(meditation.duration / 60)) minutes")
                            .foregroundColor(EgyptianColors.golden)
                    }
                    
                    HStack {
                        Text("Total Sessions:")
                            .foregroundColor(EgyptianColors.textLight.opacity(0.8))
                        Spacer()
                        Text("\(appState.meditationProgress.count)")
                            .foregroundColor(EgyptianColors.golden)
                    }
                }
                .font(EgyptianFonts.body())
                .padding(20)
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
}

#Preview {
    MeditationPlayerView(meditation: .pyramidVisualization)
        .environmentObject(AppState())
}

