

import SwiftUI

struct SequenceBeforeDriver: View {
    
    
    @State private var opacity: Double = 1.0
    @EnvironmentObject var AppState: AppState

    var body: some View {
        Rectangle()
            .fill(Color.black)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(opacity)
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeOut(duration: 1.0)) {
                    opacity = 0.0
                }
                
                // Automatisch nach Animation abschalten
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    AppState.SequenceBeforeDriver = false
                }
            }
    }
}
