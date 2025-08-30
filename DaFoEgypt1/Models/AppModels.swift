//
//  AppModels.swift
//  DaFoEgypt1
//
//  Created by IGOR on 29/08/2025.
//

import Foundation
import SwiftUI

// MARK: - App State Management
class AppState: ObservableObject {
    @Published var hasSeenOnboarding = false
    @Published var currentTab: MainTab = .selfDevelopment
    @Published var meditationProgress: [MeditationSession] = []
    @Published var journalEntries: [JournalEntry] = []
    @Published var gameScores: GameScores = GameScores()
    
    init() {
        loadData()
    }
    
    private func loadData() {
        // Load from UserDefaults
        hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        
        // Load meditation progress
        if let data = UserDefaults.standard.data(forKey: "meditationProgress"),
           let sessions = try? JSONDecoder().decode([MeditationSession].self, from: data) {
            meditationProgress = sessions
        }
        
        // Load journal entries
        if let data = UserDefaults.standard.data(forKey: "journalEntries"),
           let entries = try? JSONDecoder().decode([JournalEntry].self, from: data) {
            journalEntries = entries
        }
        
        // Load game scores
        if let data = UserDefaults.standard.data(forKey: "gameScores"),
           let scores = try? JSONDecoder().decode(GameScores.self, from: data) {
            gameScores = scores
        }
    }
    
    func saveData() {
        UserDefaults.standard.set(hasSeenOnboarding, forKey: "hasSeenOnboarding")
        
        // Save meditation progress
        if let data = try? JSONEncoder().encode(meditationProgress) {
            UserDefaults.standard.set(data, forKey: "meditationProgress")
        }
        
        // Save journal entries
        if let data = try? JSONEncoder().encode(journalEntries) {
            UserDefaults.standard.set(data, forKey: "journalEntries")
        }
        
        // Save game scores
        if let data = try? JSONEncoder().encode(gameScores) {
            UserDefaults.standard.set(data, forKey: "gameScores")
        }
    }
    
    func completeOnboarding() {
        hasSeenOnboarding = true
        saveData()
    }
    
    func addMeditationSession(_ session: MeditationSession) {
        meditationProgress.append(session)
        saveData()
    }
    
    func addJournalEntry(_ entry: JournalEntry) {
        journalEntries.append(entry)
        saveData()
    }
    
    func updateGameScore(game: GameType, score: Int) {
        switch game {
        case .hieroglyphPuzzle:
            gameScores.hieroglyphPuzzleHighScore = max(gameScores.hieroglyphPuzzleHighScore, score)
        case .historyQuiz:
            gameScores.historyQuizHighScore = max(gameScores.historyQuizHighScore, score)
        case .pyramidBuilder:
            gameScores.pyramidBuilderHighScore = max(gameScores.pyramidBuilderHighScore, score)
        }
        saveData()
    }
}

// MARK: - Navigation
enum MainTab: String, CaseIterable {
    case selfDevelopment = "Self-Development"
    case history = "History"
    case games = "Games"
    
    var icon: String {
        switch self {
        case .selfDevelopment: return EgyptianSymbols.meditation
        case .history: return EgyptianSymbols.history
        case .games: return EgyptianSymbols.games
        }
    }
    
    var egyptianIcon: String {
        switch self {
        case .selfDevelopment: return EgyptianSymbols.ankh
        case .history: return EgyptianSymbols.papyrus
        case .games: return EgyptianSymbols.pyramid
        }
    }
}

// MARK: - Self-Development Models
struct MeditationSession: Codable, Identifiable {
    let id: UUID
    let type: MeditationType
    let duration: TimeInterval
    let date: Date
    let completed: Bool
    
    init(type: MeditationType, duration: TimeInterval, date: Date, completed: Bool) {
        self.id = UUID()
        self.type = type
        self.duration = duration
        self.date = date
        self.completed = completed
    }
}

enum MeditationType: String, CaseIterable, Codable, Identifiable {
    var id: String { rawValue }
    case pyramidVisualization = "Pyramid Visualization"
    case nileMeditation = "Nile River Flow"
    case sunRaMeditation = "Sun God Ra"
    case ancientWisdom = "Ancient Wisdom"
    
    var description: String {
        switch self {
        case .pyramidVisualization:
            return "Visualize yourself inside the Great Pyramid, connecting with ancient energy and finding inner peace."
        case .nileMeditation:
            return "Flow like the Nile River, letting thoughts pass gently while finding your center."
        case .sunRaMeditation:
            return "Channel the power of Ra, the sun god, to energize your spirit and illuminate your path."
        case .ancientWisdom:
            return "Connect with the wisdom of ancient Egyptian sages and pharaohs for guidance."
        }
    }
    
    var duration: TimeInterval {
        switch self {
        case .pyramidVisualization: return 600 // 10 minutes
        case .nileMeditation: return 480 // 8 minutes
        case .sunRaMeditation: return 720 // 12 minutes
        case .ancientWisdom: return 900 // 15 minutes
        }
    }
    
    var icon: String {
        switch self {
        case .pyramidVisualization: return EgyptianSymbols.pyramid
        case .nileMeditation: return "🌊"
        case .sunRaMeditation: return EgyptianSymbols.sun
        case .ancientWisdom: return EgyptianSymbols.eye
        }
    }
}

struct JournalEntry: Codable, Identifiable {
    let id: UUID
    let date: Date
    let prompt: String
    let response: String
    let mood: MoodType
    
    init(date: Date, prompt: String, response: String, mood: MoodType) {
        self.id = UUID()
        self.date = date
        self.prompt = prompt
        self.response = response
        self.mood = mood
    }
}

enum MoodType: String, CaseIterable, Codable {
    case pharaohPower = "Pharaoh Power"
    case nileCalm = "Nile Calm"
    case desertStorm = "Desert Storm"
    case goldenSun = "Golden Sun"
    case mysticalMoon = "Mystical Moon"
    
    var emoji: String {
        switch self {
        case .pharaohPower: return "👑"
        case .nileCalm: return "🌊"
        case .desertStorm: return "🌪️"
        case .goldenSun: return "☀️"
        case .mysticalMoon: return "🌙"
        }
    }
    
    var color: Color {
        switch self {
        case .pharaohPower: return EgyptianColors.golden
        case .nileCalm: return EgyptianColors.azure
        case .desertStorm: return EgyptianColors.deepRed
        case .goldenSun: return EgyptianColors.hieroglyphGold
        case .mysticalMoon: return EgyptianColors.nightSky
        }
    }
}

struct MindTrainingCard: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let task: String
    let icon: String
    let category: MindTrainingCategory
}

enum MindTrainingCategory: String, CaseIterable {
    case wisdom = "Ancient Wisdom"
    case focus = "Pharaoh Focus"
    case creativity = "Scribe Creativity"
    case resilience = "Desert Resilience"
    
    var color: Color {
        switch self {
        case .wisdom: return EgyptianColors.golden
        case .focus: return EgyptianColors.turquoise
        case .creativity: return EgyptianColors.azure
        case .resilience: return EgyptianColors.deepRed
        }
    }
}

// MARK: - History Models
struct HistoryArticle: Identifiable {
    let id = UUID()
    let title: String
    let summary: String
    let content: String
    let imageIcon: String
    let category: HistoryCategory
    let readingTime: Int // minutes
}

enum HistoryCategory: String, CaseIterable {
    case pharaohs = "Pharaohs"
    case pyramids = "Pyramids"
    case gods = "Gods & Goddesses"
    case dailyLife = "Daily Life"
    case mysteries = "Mysteries"
    
    var icon: String {
        switch self {
        case .pharaohs: return "👑"
        case .pyramids: return EgyptianSymbols.pyramid
        case .gods: return EgyptianSymbols.eye
        case .dailyLife: return "🏺"
        case .mysteries: return "🔮"
        }
    }
    
    var color: Color {
        switch self {
        case .pharaohs: return EgyptianColors.golden
        case .pyramids: return EgyptianColors.pyramidStone
        case .gods: return EgyptianColors.turquoise
        case .dailyLife: return EgyptianColors.desertSand
        case .mysteries: return EgyptianColors.nightSky
        }
    }
}

struct PharaoTimeline: Identifiable {
    let id = UUID()
    let name: String
    let dynasty: String
    let reignStart: Int // BCE
    let reignEnd: Int // BCE
    let achievements: [String]
    let funFact: String
}

struct Artifact: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let period: String
    let significance: String
    let imageIcon: String
    let discoveryYear: Int
}

// MARK: - Game Models
struct GameScores: Codable {
    var hieroglyphPuzzleHighScore: Int = 0
    var historyQuizHighScore: Int = 0
    var pyramidBuilderHighScore: Int = 0
}

enum GameType: String, CaseIterable, Identifiable {
    case hieroglyphPuzzle = "hieroglyphPuzzle"
    case historyQuiz = "historyQuiz"
    case pyramidBuilder = "pyramidBuilder"
    
    var id: String { rawValue }
}

struct HieroglyphPuzzle {
    let hieroglyph: String
    let meaning: String
    let options: [String]
    let correctAnswer: String
}

struct QuizQuestion {
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
    let difficulty: QuizDifficulty
}

enum QuizDifficulty: String, CaseIterable {
    case easy = "Novice Scribe"
    case medium = "Temple Scholar"
    case hard = "High Priest"
    
    var points: Int {
        switch self {
        case .easy: return 10
        case .medium: return 20
        case .hard: return 30
        }
    }
}

struct PyramidBlock: Identifiable, Codable {
    let id: UUID
    var position: CGPoint
    let size: CGSize
    var isPlaced: Bool
    let level: Int
    
    // Custom Codable implementation for CGPoint and CGSize
    enum CodingKeys: String, CodingKey {
        case id, positionX, positionY, sizeWidth, sizeHeight, isPlaced, level
    }
    
    init(id: UUID = UUID(), position: CGPoint, size: CGSize, isPlaced: Bool = false, level: Int) {
        self.id = id
        self.position = position
        self.size = size
        self.isPlaced = isPlaced
        self.level = level
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        let positionX = try container.decode(CGFloat.self, forKey: .positionX)
        let positionY = try container.decode(CGFloat.self, forKey: .positionY)
        position = CGPoint(x: positionX, y: positionY)
        let sizeWidth = try container.decode(CGFloat.self, forKey: .sizeWidth)
        let sizeHeight = try container.decode(CGFloat.self, forKey: .sizeHeight)
        size = CGSize(width: sizeWidth, height: sizeHeight)
        isPlaced = try container.decode(Bool.self, forKey: .isPlaced)
        level = try container.decode(Int.self, forKey: .level)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(position.x, forKey: .positionX)
        try container.encode(position.y, forKey: .positionY)
        try container.encode(size.width, forKey: .sizeWidth)
        try container.encode(size.height, forKey: .sizeHeight)
        try container.encode(isPlaced, forKey: .isPlaced)
        try container.encode(level, forKey: .level)
    }
}

// MARK: - Animation States
enum OnboardingStep: Int, CaseIterable {
    case welcome = 0
    case features = 1
    case ready = 2
    
    var title: String {
        switch self {
        case .welcome: return "Welcome to Eterna Egypt"
        case .features: return "Discover Ancient Wisdom"
        case .ready: return "Begin Your Journey"
        }
    }
    
    var description: String {
        switch self {
        case .welcome: return "Embark on a journey through ancient Egypt, where wisdom, history, and games await you."
        case .features: return "Meditate like pharaohs, learn forgotten history, and play games inspired by ancient Egypt."
        case .ready: return "Your path to enlightenment begins now. May the gods guide your journey."
        }
    }
}
