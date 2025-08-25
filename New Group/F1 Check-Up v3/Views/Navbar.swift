import SwiftUI

struct Navbar: View {
    
    @EnvironmentObject var AppState: AppState

    var body: some View {
        VStack(spacing: 0) {
            HStack{
               
                Spacer()
                    tabButton(Text: "chart.bar", tab: .stats)
                
                Spacer()

                    tabButton(Text: "person.2", tab: .roster)
                
                Spacer()
                    tabButton(Text: "house.fill", tab: .house)

                Spacer()
                    tabButton(Text:"calendar", tab: .races)
                
                Spacer()

                    tabButton(Text: "gearshape", tab: .settings)
                
                Spacer()

            }
            .frame(maxWidth: .infinity)
            .padding(.top, 20)
            .background(Color.black)
            .padding(.top, 0.4)
            .background(Color.gray)
        }
       
    }


    func tabButton(Text: String, tab: Tab) -> some View {
        Button(action: {
            AppState.selectedTab = tab
        }) {
            Image(systemName: Text)
                .foregroundColor(AppState.selectedTab == tab ?                     AppState.PrimaryColor.color
                                 : .gray)
                .font(.system(size: 25, design: .serif))
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())

}
