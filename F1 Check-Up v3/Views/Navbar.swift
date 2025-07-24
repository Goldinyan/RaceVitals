import SwiftUI

struct Navbar: View {
    
    @EnvironmentObject var TabManager: AppState

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 50) {
               

                VStack {
                    tabIcon(systemName: "chart.bar", tab: .stats)
                    tabButton("Stats", tab: .stats)
                }
                VStack {
                    tabIcon(systemName: "person.2", tab: .roster)
                    tabButton("Roster", tab: .roster)
                }

                VStack {
                    tabIcon(systemName: "calendar", tab: .races)
                    tabButton("Races", tab: .races)
                }

                VStack {
                    tabIcon(systemName: "gearshape", tab: .settings)
                    tabButton("Settings", tab: .settings)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 20)
            .background(Color.black)
            .padding(.top, 0.4)
            .background(Color.gray)
        }
        .padding(.bottom, -20)
    }

    func tabIcon(systemName: String, tab: Tab) -> some View {
        Image(systemName: systemName)
           // .resizable()
            .font(.system(size: 25))

            .frame(width: 30, height: 30)
            .foregroundColor(TabManager.selectedTab == tab ? .red : .gray)
            .onTapGesture {
                TabManager.selectedTab = tab
            }
    }

    func tabButton(_ title: String, tab: Tab) -> some View {
        Button(action: {
            TabManager.selectedTab = tab
        }) {
            Text(title)
                .foregroundColor(TabManager.selectedTab == tab ? .red : .gray)
                .font(.system(size: 16, design: .serif))
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())

}
