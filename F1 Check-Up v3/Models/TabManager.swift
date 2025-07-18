//
//  TabManager.swift
//  F1 Check-Up v3
//
//  Created by Ansgar Seifert on 18.07.25.
//

import SwiftUI

class LanguageManager: ObservableObject {
    @Published var selectedLanguage: Language = .English
}

enum Language: String, CaseIterable {
    case English, German, Spanish, French
}



class TabManager: ObservableObject {
    @Published var selectedTab: Tab = .roster
}

enum Tab {
    case roster, stats , races, settings
}
