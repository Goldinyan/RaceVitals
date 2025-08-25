//
//  Calender.swift
//  F1 Check-Up v3
//
//  Created by Ansgar Seifert on 23.08.25.
//

import SwiftUI

struct CalenderView: View {
    
    @EnvironmentObject var AppState: AppState
    
    
    var body: some View {
        ZStack{
            AppState.PrimaryColor.color
                        .ignoresSafeArea()
            VStack{
                
            }
            
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(AppState())
}
