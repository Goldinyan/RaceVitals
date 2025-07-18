import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var tabManager: TabManager

    
    
    var body: some View {
        VStack(spacing: 0) {
            
           // Header()
            
            switch tabManager.selectedTab {
                
                
                case .settings:
                SettingsView()
                
                case .roster:
                DriverListView()
                
                case .races:
                Text("Races")
                
                case .stats:
                Text("Stats")
                
            
            }
            
            
            Navbar()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TabManager())
        .environmentObject(LanguageManager())

}



