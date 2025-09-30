//
//  F1_Check_Up_v3App.swift
//  F1 Check-Up v3
//
//  Created by Ansgar Seifert on 02.07.25.
//

import SwiftUI
import Firebase




@main
struct F1_Check_Up_v3App: App {
    init() {
            FirebaseApp.configure()
        }
    var body: some Scene {
        WindowGroup {
            
            ContentView()
                .environmentObject(AppState())
        }
    }
}
