import Foundation
import SwiftUI

public func backgroundColor(for team: String) -> Color {
    switch team {
    case "Mercedes": return Color(hex: "#00D2BE")
    case "Ferrari": return Color(hex: "#DC0000")
    case "Alpine": return Color(hex: "#2293D1")
    case "AlphaTauri": return Color(hex: "#2B4562")
    case "Red Bull Racing": return Color(hex: "#1E41FF")
    case "McLaren": return Color(hex: "#FF8700")
    case "Aston Martin": return Color(hex: "#004225")
    case "Alfa Romeo": return Color(hex: "#9B0000")
    case "Haas": return Color(hex: "#BD9E57")
    case "Williams": return Color(hex: "#005AFF")
    default: return Color.gray
    }
}
