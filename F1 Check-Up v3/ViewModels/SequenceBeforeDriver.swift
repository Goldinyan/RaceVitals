

import SwiftUI

struct SequenceBeforeDriver: View {
    
    
    @State private var opacity: Double = 1.0
    @EnvironmentObject var AppState: AppState

    var body: some View {
        ZStack {
            VStack(spacing: 0){
                DriverListView()
                Navbar()
            }
            Rectangle()
                .fill(Color.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .opacity(opacity)
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.easeOut(duration: 10.0)) {
                        opacity = 0.0
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                        AppState.SequenceBeforeDriver = false
                        AppState.isLoggedIn = true
                        AppState.selectedTab = .roster
                        print("Sequence finished")
                    }
                }
        }
    }

}
