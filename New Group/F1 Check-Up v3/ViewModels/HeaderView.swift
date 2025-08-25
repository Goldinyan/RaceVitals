//
//  HeaderView.swift
//  F1 Check-Up v3
//
//  Created by Ansgar Seifert on 20.08.25.
//


import SwiftUI


struct HeaderViewStats: View {
    
@EnvironmentObject var AppState: AppState
    var body: some View {
        GeometryReader{ geometry in
                HStack{
                    Text("Race Vitals")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 30, weight: .bold, design: .default))
                    Spacer()
                        .frame(width: geometry.size.width * 0.4)
                }
                .padding(.bottom, geometry.size.height * 0.12)
                .frame(maxWidth: .infinity)
                .background(AppState.PrimaryColor.color)
        }
    }
}



#Preview {
    ContentView()
        .environmentObject(AppState())

}
