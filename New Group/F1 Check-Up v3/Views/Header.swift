//
//  Header.swift
//  F1 Check-Up v3
//
//  Created by Ansgar Seifert on 06.07.25.
//



import SwiftUI


struct Header : View {
    
    
    var body: some View {
        
        HStack {
            Text("F1 Check-Up v1")
                .font(.system(size: 28 , weight: .heavy, design: .serif))
                .frame(maxWidth: .infinity)
                .padding()
                
                .foregroundColor(.white)
                .zIndex(1)
                .padding(.trailing,140)
            
            
            
        }
        .frame(height: 60)
        .background(Color.red)
    }
}





#Preview {
    ContentView()
        .environmentObject(AppState())
}
