import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var AppState: AppState

    
    
    var body: some View {
        VStack(spacing: 0) {
            
           // Header()
            
            
            if AppState.isLoggedIn {
                switch AppState.selectedTab {
                    case .settings: SettingsView()
                    case .roster: DriverListView()
                    case .races: Text("Races")
                    case .stats: Text("Stats")
                }
                Navbar()
            } else {
                StartView()
            }
            
            if AppState.SequenceBeforeDriver{
                SequenceBeforeDriver()
            }
            
            

            
            
            
            
            
        }
        .onAppear {
            if AppState.loadToken() != nil {
                AppState.isLoggedIn = true
            }

            }
        }

    }


#Preview {
    ContentView()
        .environmentObject(AppState())

}



