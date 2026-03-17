//
//  Theme.swift
//  Doomstop
//
//  Created by Boris Manoilov on 15/03/2026.
//  Copyright © 2026 Boris Manoilov. All rights reserved.
//

import SwiftUI

// MARK: - Theme Configuration
struct Theme {
    
    // MARK: - Colors
    struct Colors {
        static let background = Color(hex: "#F5F2EA")
        static let background2 = Color(hex: "#FDFAF4")
        static let accent = Color(hex: "#F4A340")
        static let text = Color(hex: "#1C1C1C")
        static let muted = Color(hex: "#7a7060")
        static let red = Color(hex: "#d94f4f")
        static let green = Color(hex: "#4f9e6a")
    }
    
    // MARK: - Fonts
    struct Fonts {
        // Oswald font family for headlines
        static let headlineRegular = "Oswald-Regular"
        static let headlineSemiBold = "Oswald-SemiBold"
        static let headlineBold = "Oswald-Bold"
        
        // DM Sans font family for body text
        static let bodyRegular = "DMSans-Regular"
        static let bodyMedium = "DMSans-Medium"
        
        // Convenience properties
        static var headline: String {
            return headlineSemiBold // Default to semi-bold for headlines
        }
        
        static var body: String {
            return bodyRegular // Default to regular for body text
        }
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 10
        static let medium: CGFloat = 14
        static let large: CGFloat = 18
        static let xl: CGFloat = 26
    }
}

// MARK: - Color Extension
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
