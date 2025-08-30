//
//  GameData.swift
//  DaFoEgypt1
//
//  Created by IGOR on 29/08/2025.
//

import Foundation
import SwiftUI

// MARK: - Game Data Provider
struct GameDataProvider {
    
    // MARK: - Hieroglyph Puzzles
    static let hieroglyphPuzzles: [HieroglyphPuzzle] = [
        HieroglyphPuzzle(
            hieroglyph: "𓂀",
            meaning: "Eye of Horus",
            options: ["Eye of Horus", "Eye of Ra", "Ankh", "Scarab"],
            correctAnswer: "Eye of Horus"
        ),
        HieroglyphPuzzle(
            hieroglyph: "☥",
            meaning: "Ankh",
            options: ["Cross", "Ankh", "Djed", "Tyet"],
            correctAnswer: "Ankh"
        ),
        HieroglyphPuzzle(
            hieroglyph: "𓊪",
            meaning: "Bread",
            options: ["Water", "Bread", "Beer", "Meat"],
            correctAnswer: "Bread"
        ),
        HieroglyphPuzzle(
            hieroglyph: "𓈖",
            meaning: "Water",
            options: ["Sand", "Water", "Fire", "Air"],
            correctAnswer: "Water"
        ),
        HieroglyphPuzzle(
            hieroglyph: "𓃭",
            meaning: "Lion",
            options: ["Cat", "Dog", "Lion", "Jackal"],
            correctAnswer: "Lion"
        ),
        HieroglyphPuzzle(
            hieroglyph: "𓅃",
            meaning: "Ibis",
            options: ["Eagle", "Falcon", "Ibis", "Vulture"],
            correctAnswer: "Ibis"
        ),
        HieroglyphPuzzle(
            hieroglyph: "𓇳",
            meaning: "Sun",
            options: ["Moon", "Star", "Sun", "Sky"],
            correctAnswer: "Sun"
        ),
        HieroglyphPuzzle(
            hieroglyph: "𓊽",
            meaning: "House",
            options: ["Temple", "House", "Palace", "Tomb"],
            correctAnswer: "House"
        ),
        HieroglyphPuzzle(
            hieroglyph: "𓂧",
            meaning: "Hand",
            options: ["Foot", "Hand", "Arm", "Finger"],
            correctAnswer: "Hand"
        ),
        HieroglyphPuzzle(
            hieroglyph: "𓄿",
            meaning: "Vulture",
            options: ["Eagle", "Hawk", "Vulture", "Falcon"],
            correctAnswer: "Vulture"
        ),
        HieroglyphPuzzle(
            hieroglyph: "𓃀",
            meaning: "Bull",
            options: ["Cow", "Bull", "Ox", "Buffalo"],
            correctAnswer: "Bull"
        ),
        HieroglyphPuzzle(
            hieroglyph: "𓈗",
            meaning: "Pool",
            options: ["River", "Lake", "Pool", "Sea"],
            correctAnswer: "Pool"
        ),
        HieroglyphPuzzle(
            hieroglyph: "𓊃",
            meaning: "Door",
            options: ["Window", "Door", "Gate", "Wall"],
            correctAnswer: "Door"
        ),
        HieroglyphPuzzle(
            hieroglyph: "𓌻",
            meaning: "Papyrus",
            options: ["Reed", "Papyrus", "Grass", "Wheat"],
            correctAnswer: "Papyrus"
        ),
        HieroglyphPuzzle(
            hieroglyph: "𓋹",
            meaning: "Gold",
            options: ["Silver", "Gold", "Copper", "Bronze"],
            correctAnswer: "Gold"
        )
    ]
    
    // MARK: - Quiz Questions
    static let quizQuestions: [QuizQuestion] = [
        // Easy Questions
        QuizQuestion(
            question: "What was the primary writing material used by ancient Egyptians?",
            options: ["Stone", "Clay", "Papyrus", "Wood"],
            correctAnswer: 2,
            explanation: "Papyrus was made from the papyrus plant that grew along the Nile River and became the primary writing material in ancient Egypt.",
            difficulty: .easy
        ),
        QuizQuestion(
            question: "Which river was essential to ancient Egyptian civilization?",
            options: ["Euphrates", "Tigris", "Nile", "Amazon"],
            correctAnswer: 2,
            explanation: "The Nile River provided water, fertile soil, and transportation, making it the lifeline of ancient Egyptian civilization.",
            difficulty: .easy
        ),
        QuizQuestion(
            question: "What is the name of the famous boy king of Egypt?",
            options: ["Ramesses", "Tutankhamun", "Akhenaten", "Khufu"],
            correctAnswer: 1,
            explanation: "Tutankhamun, also known as King Tut, became pharaoh at age 9 and is famous for his intact tomb discovered in 1922.",
            difficulty: .easy
        ),
        QuizQuestion(
            question: "What symbol represents eternal life in ancient Egypt?",
            options: ["Scarab", "Ankh", "Eye of Horus", "Djed"],
            correctAnswer: 1,
            explanation: "The Ankh symbol represented eternal life and was often carried by gods and pharaohs in Egyptian art.",
            difficulty: .easy
        ),
        QuizQuestion(
            question: "Which animal was considered sacred to the goddess Bastet?",
            options: ["Dog", "Cat", "Bird", "Snake"],
            correctAnswer: 1,
            explanation: "Cats were sacred to Bastet, the goddess of protection, fertility, and motherhood. Killing a cat was punishable by death.",
            difficulty: .easy
        ),
        
        // Medium Questions
        QuizQuestion(
            question: "Who was the last active pharaoh of ancient Egypt?",
            options: ["Nefertiti", "Hatshepsut", "Cleopatra VII", "Ankhesenamun"],
            correctAnswer: 2,
            explanation: "Cleopatra VII was the last active pharaoh of Egypt, ruling until her death in 30 BCE when Egypt became a Roman province.",
            difficulty: .medium
        ),
        QuizQuestion(
            question: "What was the primary purpose of mummification?",
            options: ["Religious ceremony", "Preserve body for afterlife", "Show wealth", "Honor the gods"],
            correctAnswer: 1,
            explanation: "Mummification preserved the body for the afterlife, as Egyptians believed the soul needed an intact body to live eternally.",
            difficulty: .medium
        ),
        QuizQuestion(
            question: "Which pharaoh built the Great Pyramid of Giza?",
            options: ["Khafre", "Khufu", "Menkaure", "Djoser"],
            correctAnswer: 1,
            explanation: "Khufu (also known as Cheops) built the Great Pyramid of Giza around 2580-2560 BCE during the Fourth Dynasty.",
            difficulty: .medium
        ),
        QuizQuestion(
            question: "What does the word 'pharaoh' originally mean?",
            options: ["King", "God", "Great House", "Ruler"],
            correctAnswer: 2,
            explanation: "The word 'pharaoh' comes from the Egyptian 'per-aa' meaning 'Great House,' originally referring to the royal palace.",
            difficulty: .medium
        ),
        QuizQuestion(
            question: "Which god was considered the king of the Egyptian gods?",
            options: ["Osiris", "Horus", "Ra", "Anubis"],
            correctAnswer: 2,
            explanation: "Ra, the sun god, was considered the king of the gods and was often combined with other deities like Amun to form Amun-Ra.",
            difficulty: .medium
        ),
        
        // Hard Questions
        QuizQuestion(
            question: "What was the name of Akhenaten's new capital city?",
            options: ["Memphis", "Thebes", "Amarna", "Alexandria"],
            correctAnswer: 2,
            explanation: "Akhenaten built a new capital called Amarna (ancient Akhetaten) dedicated to the sun god Aten during his religious revolution.",
            difficulty: .hard
        ),
        QuizQuestion(
            question: "Which Egyptian queen ruled as pharaoh for about 22 years?",
            options: ["Nefertiti", "Hatshepsut", "Cleopatra", "Nefertari"],
            correctAnswer: 1,
            explanation: "Hatshepsut was one of the most successful female pharaohs, ruling for about 22 years during the 18th Dynasty.",
            difficulty: .hard
        ),
        QuizQuestion(
            question: "What was the Egyptian name for the afterlife?",
            options: ["Duat", "Aaru", "Amenti", "Sekhet-Aaru"],
            correctAnswer: 0,
            explanation: "The Duat was the Egyptian underworld, the realm of the dead where souls journeyed after death to reach the afterlife.",
            difficulty: .hard
        ),
        QuizQuestion(
            question: "Which pharaoh signed the world's first known peace treaty?",
            options: ["Thutmose III", "Ramesses II", "Seti I", "Amenhotep III"],
            correctAnswer: 1,
            explanation: "Ramesses II signed the Egyptian-Hittite peace treaty around 1259 BCE, the first known peace treaty in history.",
            difficulty: .hard
        ),
        QuizQuestion(
            question: "What was the Egyptian calendar based on?",
            options: ["Moon phases", "Nile flood cycle", "Star positions", "Solar year"],
            correctAnswer: 1,
            explanation: "The Egyptian calendar was based on the annual flooding of the Nile River, which divided the year into three seasons.",
            difficulty: .hard
        )
    ]
    
    // MARK: - Pyramid Building Levels
    static func generatePyramidLevel(_ level: Int) -> [PyramidBlock] {
        var blocks: [PyramidBlock] = []
        let baseWidth: CGFloat = 300
        let blockHeight: CGFloat = 40
        let blocksInLevel = max(1, 8 - level) // Decreasing number of blocks per level
        let blockWidth = baseWidth / CGFloat(blocksInLevel)
        
        for i in 0..<blocksInLevel {
            let xPosition = CGFloat(i) * blockWidth + blockWidth / 2 - baseWidth / 2
            let yPosition = CGFloat(level) * blockHeight
            
            let block = PyramidBlock(
                position: CGPoint(x: xPosition, y: yPosition),
                size: CGSize(width: blockWidth - 2, height: blockHeight - 2),
                level: level
            )
            blocks.append(block)
        }
        
        return blocks
    }
    
    // MARK: - Game Achievements
    static func getAchievementTitle(for game: GameType, score: Int) -> String {
        switch game {
        case .hieroglyphPuzzle:
            if score >= 150 { return "Master Scribe" }
            else if score >= 100 { return "Temple Scholar" }
            else if score >= 50 { return "Novice Reader" }
            else { return "Student of Hieroglyphs" }
            
        case .historyQuiz:
            if score >= 300 { return "Pharaoh's Advisor" }
            else if score >= 200 { return "High Priest" }
            else if score >= 100 { return "Temple Scholar" }
            else { return "Novice Scribe" }
            
        case .pyramidBuilder:
            if score >= 7 { return "Master Builder" }
            else if score >= 5 { return "Royal Architect" }
            else if score >= 3 { return "Stone Mason" }
            else { return "Apprentice Builder" }
        }
    }
    
    static func getAchievementDescription(for game: GameType, score: Int) -> String {
        switch game {
        case .hieroglyphPuzzle:
            if score >= 150 { return "You have mastered the ancient art of hieroglyphic reading!" }
            else if score >= 100 { return "Your knowledge of hieroglyphs grows like the wisdom of scribes." }
            else if score >= 50 { return "You're beginning to understand the sacred symbols." }
            else { return "Every great scribe started with their first symbol." }
            
        case .historyQuiz:
            if score >= 300 { return "Your knowledge rivals that of the greatest pharaohs!" }
            else if score >= 200 { return "You possess the wisdom of the high priests." }
            else if score >= 100 { return "Your understanding of Egypt's history is growing strong." }
            else { return "You're on the path to ancient wisdom." }
            
        case .pyramidBuilder:
            if score >= 7 { return "You've built a pyramid worthy of the greatest pharaohs!" }
            else if score >= 5 { return "Your architectural skills honor the ancient builders." }
            else if score >= 3 { return "You're learning the sacred art of pyramid construction." }
            else { return "Every master builder started with a single stone." }
        }
    }
    
    // MARK: - Game Tips
    static let hieroglyphTips = [
        "Many hieroglyphs represent the actual object they depict!",
        "Some symbols can represent sounds, ideas, or both.",
        "The direction figures face shows the reading direction.",
        "Cartouches (oval shapes) contain royal names.",
        "Practice makes perfect - ancient scribes studied for years!"
    ]
    
    static let quizTips = [
        "Read each question carefully before selecting an answer.",
        "Think about what you've learned in the History section.",
        "Harder questions give more points but require more knowledge.",
        "Don't rush - take time to consider all options.",
        "Learn from explanations to improve your score!"
    ]
    
    static let pyramidTips = [
        "Start with a strong foundation - place bottom blocks first.",
        "Each level should be smaller than the one below.",
        "Drag blocks carefully to their correct positions.",
        "The pyramid should be symmetrical and stable.",
        "Ancient builders worked with precision - so should you!"
    ]
}

