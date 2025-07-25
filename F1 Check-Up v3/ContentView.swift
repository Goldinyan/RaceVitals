import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var AppState: AppState
    @State private var didRunInitialCheck = false
    
    
    
    var body: some View {
        ZStack{
            
            VStack(spacing: 0) {
                
                // Header()
                
                
                if AppState.isLoggedIn && !AppState.SequenceBeforeDriver {
                    switch AppState.selectedTab {
                    case .settings: SettingsView()
                    case .roster: DriverListView()
                    case .races: Text("Races")
                    case .stats: Text("Stats")
                    }
                    Navbar()
                } else if  AppState.SequenceBeforeDriver && !AppState.isLoggedIn {
                    SequenceBeforeDriver()
                } else if  !AppState.isLoggedIn  {
                    StartView()
                }
                
                
                
                
                
                
                
                
                
                
            }
            .zIndex(2)
            .onAppear {
                if !didRunInitialCheck {
                    didRunInitialCheck = true
                    if AppState.loadToken() != nil {
                        AppState.isLoggedIn = true
                        print("Token is here")
                    } else {
                        print("Token is not here")
                    }
                }
            }
            
            
            if AppState.ShowSplash {
                SplashScreenView()
                    .transition(.opacity)
                    .zIndex(3)
            }
        }
        .onAppear {
            AppState.ShowSplash = true
        }
        }

    }


#Preview {
    ContentView()
        .environmentObject(AppState())

}



