//
//  EgyptianTheme.swift
//  DaFoEgypt1
//
//  Created by IGOR on 29/08/2025.
//

import SwiftUI

// MARK: - Egyptian Color Palette
struct EgyptianColors {
    // Background colors
    static let desertSand = Color(hex: "#E6D5A8")
    static let darkBrown = Color(hex: "#3B2E2A")
    
    // Button colors
    static let golden = Color(hex: "#C89B3C")
    static let goldenLight = Color(hex: "#D4A847")
    static let goldenDark = Color(hex: "#B8892F")
    
    // Accent colors
    static let turquoise = Color(hex: "#1E7A77")
    static let azure = Color(hex: "#007BA7")
    static let deepRed = Color(hex: "#A23E48")
    
    // Text colors
    static let textDark = Color(hex: "#1B1B1B")
    static let textLight = Color(hex: "#F8F5E1")
    
    // Additional Egyptian colors
    static let papyrus = Color(hex: "#F4E4BC")
    static let hieroglyphGold = Color(hex: "#FFD700")
    static let pyramidStone = Color(hex: "#D2B48C")
    static let nightSky = Color(hex: "#191970")
}

// MARK: - Color Extension for Hex Support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Egyptian Button Style
struct EgyptianButtonStyle: ButtonStyle {
    var isSecondary: Bool = false
    var geometry: GeometryProxy? = nil
    
    func makeBody(configuration: Configuration) -> some View {
        let fontSize: CGFloat = {
            guard let geo = geometry else { return 18 }
            return geo.size.width < 400 ? 16 : 18
        }()
        
        let horizontalPadding: CGFloat = {
            guard let geo = geometry else { return 24 }
            return geo.size.width < 400 ? 20 : 24
        }()
        
        let verticalPadding: CGFloat = {
            guard let geo = geometry else { return 16 }
            return geo.size.width < 400 ? 14 : 16
        }()
        
        configuration.label
            .font(.system(size: fontSize, weight: .semibold, design: .rounded))
            .foregroundColor(isSecondary ? EgyptianColors.textDark : EgyptianColors.textLight)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: isSecondary ? 
                                [EgyptianColors.papyrus, EgyptianColors.desertSand] :
                                [EgyptianColors.goldenLight, EgyptianColors.golden, EgyptianColors.goldenDark],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(
                        color: EgyptianColors.darkBrown.opacity(0.3),
                        radius: configuration.isPressed ? 2 : 6,
                        x: 0,
                        y: configuration.isPressed ? 1 : 3
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Egyptian Card Style
struct EgyptianCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(EgyptianColors.papyrus)
                    .shadow(
                        color: EgyptianColors.darkBrown.opacity(0.2),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [EgyptianColors.golden.opacity(0.3), EgyptianColors.golden.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}

// MARK: - Egyptian Typography
struct EgyptianFonts {
    static func title(for geometry: GeometryProxy? = nil) -> Font {
        let baseSize: CGFloat = 28
        let scaleFactor = geometry?.size.width ?? 400
        let adjustedSize = scaleFactor < 400 ? baseSize * 0.85 : baseSize
        return .system(size: adjustedSize, weight: .bold, design: .serif)
    }
    
    static func headline(for geometry: GeometryProxy? = nil) -> Font {
        let baseSize: CGFloat = 22
        let scaleFactor = geometry?.size.width ?? 400
        let adjustedSize = scaleFactor < 400 ? baseSize * 0.9 : baseSize
        return .system(size: adjustedSize, weight: .semibold, design: .serif)
    }
    
    static func body(for geometry: GeometryProxy? = nil) -> Font {
        let baseSize: CGFloat = 16
        let scaleFactor = geometry?.size.width ?? 400
        let adjustedSize = scaleFactor < 400 ? baseSize * 0.9 : baseSize
        return .system(size: adjustedSize, weight: .regular, design: .rounded)
    }
    
    static func caption(for geometry: GeometryProxy? = nil) -> Font {
        let baseSize: CGFloat = 14
        let scaleFactor = geometry?.size.width ?? 400
        let adjustedSize = scaleFactor < 400 ? baseSize * 0.9 : baseSize
        return .system(size: adjustedSize, weight: .medium, design: .rounded)
    }
    
    static func hieroglyph(for geometry: GeometryProxy? = nil) -> Font {
        let baseSize: CGFloat = 24
        let scaleFactor = geometry?.size.width ?? 400
        let adjustedSize = scaleFactor < 400 ? baseSize * 0.85 : baseSize
        return .system(size: adjustedSize, weight: .bold, design: .monospaced)
    }
    
    // Backward compatibility methods
    static func title() -> Font { title(for: nil) }
    static func headline() -> Font { headline(for: nil) }
    static func body() -> Font { body(for: nil) }
    static func caption() -> Font { caption(for: nil) }
    static func hieroglyph() -> Font { hieroglyph(for: nil) }
}

// MARK: - View Extensions
extension View {
    func egyptianCard() -> some View {
        self.modifier(EgyptianCardStyle())
    }
    
    func egyptianButton(secondary: Bool = false, geometry: GeometryProxy? = nil) -> some View {
        self.buttonStyle(EgyptianButtonStyle(isSecondary: secondary, geometry: geometry))
    }
}

// MARK: - Egyptian Symbols
struct EgyptianSymbols {
    static let ankh = "☥"
    static let eye = "𓂀"
    static let pyramid = "⏃"
    static let scarab = "🪲"
    static let papyrus = "📜"
    static let sun = "☀️"
    static let moon = "🌙"
    static let star = "⭐"
    static let lotus = "🪷"
    static let cat = "🐱"
    
    // SF Symbols for navigation
    static let meditation = "figure.mind.and.body"
    static let history = "book.closed"
    static let games = "gamecontroller"
    static let journal = "book"
    static let timeline = "timeline.selection"
    static let artifact = "crown"
}

