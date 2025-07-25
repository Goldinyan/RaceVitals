//
//  SpalshScreen.swift
//  F1 Check-Up v3
//
//  Created by Ansgar Seifert on 24.07.25.
//


import SwiftUI

struct SplashScreenView: View {
    
    
    let darkRed = Color(red: 0.5, green: 0.0, blue: 0.0)
    let brightRed = Color(red: 0.8, green: 0.2, blue: 0.2)
    @EnvironmentObject var AppState: AppState
    @State private var rotation = 0.0
    @State private var progress = 0.0
    
    
    func progressadder () {
        progress += Double.random(in: 0...0.005)
    }
    @State private var animate = false
    
    
    
    var body: some View {
        
        
        ZStack{
            
            
            
            
            
            
            LinearGradient(
                gradient: Gradient(colors: [darkRed, brightRed]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .edgesIgnoringSafeArea(.all)
            Image("carbonImage")
                .resizable()
                .frame(width: UIScreen.main.bounds.width)
                .opacity(0.35)
                .blendMode(.overlay)
            
            
            VStack {
                
                Spacer()
                    .frame(minHeight: UIScreen.main.bounds.height * 0.2)
                
                
                
                Image("loadingScreenTires")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.width * 0.4)
                    .rotationEffect(.degrees(rotation))
                    .onAppear {
                        withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                            rotation = 360
                        }
                    }
                    .padding(.top, UIScreen.main.bounds.height * 0.2)
                
                
                
                
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.2)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                            progressadder()
                            if progress >= 1.0 {
                                AppState.ShowSplash = false
                                timer.invalidate()
                            }
                        }
                    }
                    .padding(.top, UIScreen.main.bounds.height * 0.05)
                
                
                Spacer()
                    .frame(minHeight: UIScreen.main.bounds.height * 0.3)
                
                
                Text("© 2025 Created by Goldinyan")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.05)
                
                
                
                
                
            }
            
        }
        
        
        
        
        
    }
    
    
    
    
}


#Preview {
    ContentView()
        .environmentObject(AppState())

}
