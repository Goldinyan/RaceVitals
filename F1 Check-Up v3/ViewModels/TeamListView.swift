import SwiftUI



struct TeamListView: View {
    let team: Team
    @State private var drivers = allDrivers
    let selectedYear: Int?
    @EnvironmentObject var AppState: AppState
    
    
    
    
    var body: some View {
        ZStack (alignment: .leading){
            
            
            
            
            
            
            
            
            
            
            
            VStack(alignment: .leading){
                
                VStack(spacing: 0){
                    
                        
                    ZStack{
                        Image(team.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.25)
                            .opacity(0.2)
                        
                        
                        Image(team.currentLivery[0].image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.35)
                           
                    }
                    
                    
                    
                    
                    
                    HStack {

                        
                        Text(team.name)
                            .font(.system(size: 30, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.leading, 24)

                        Spacer()
                    }
                    .padding(.top, 22)
                    .background(Color( hex: "#1F2937"))
                    //.padding(.top, 10)
                    
                    
                    
                    HStack {
                     //   Text(team.currentDrivers)
                     //       .font(.system(size: 20, weight: .regular, design: .serif))
                       //     .foregroundStyle(Color( hex: "#D1D5DA"))
                         //   .padding(.leading, 24)
                        Spacer()
                    }
                    .padding(.top, 10)
                    .background(Color( hex: "#1F2937"))
                    
                    
                    
                    HStack {
                        Text(team.location)
                            .font(.system(size: 20, weight: .regular, design: .serif))
                            .foregroundStyle(Color( hex: "#9BA3AF"))
                            .padding(.leading, 24)
                        
                        Spacer()
                    }
                    .padding(.top, 10)
                    .background(Color( hex: "#1F2937"))
                    
                    HStack{
                        Text("Points: ")
                            .font(.system(size: 20, weight: .regular, design: .serif))
                            .foregroundStyle(Color( hex: "#98A0AC"))
                            .bold()
                        
                        Spacer()
                        Text("\(team.totalPoints(language: AppState.selectedLanguage.rawValue))")
                            .font(.system(size:20, design: .serif))
                            .foregroundStyle(.red)
                            .bold()
                    }
                    .padding(10)
                    .background(Color( hex: "#161D27"))
                    .cornerRadius(10)
                    .padding(16)
                    .padding(.horizontal, 4)
                    
                    
                    .background(Color( hex: "#1F2937"))
                    
                }
                
                
                
                
                
                
                HStack {
                    VStack {
                        Text("\(team.WinsSeasonTeam(for: selectedYear, language: AppState.selectedLanguage.rawValue))")
                            .font(.system(size: 20, weight: .bold, design: .serif))
                            .foregroundStyle(Color.white)
                            .padding(.bottom, 0.1)
                        Text("Wins")
                            .font(.system(size: 15, weight: .regular, design: .serif))
                            .foregroundStyle(Color(hex: "#7B818C"))
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("\(team.PodiumsSeasonTeam(for: selectedYear, language: AppState.selectedLanguage.rawValue))")
                            .font(.system(size: 20, weight: .bold, design: .serif))
                            .foregroundStyle(Color.white)
                            .padding(.bottom, 0.1)
                        Text("Podiums")
                            .font(.system(size: 15, weight: .regular, design: .serif))
                            .foregroundStyle(Color(hex: "#7B818C"))
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("\(team.PolesSeasonTeam(for: selectedYear, language: AppState.selectedLanguage.rawValue))")
                            .font(.system(size: 20, weight: .bold, design: .serif))
                            .foregroundStyle(Color.white)
                            .padding(.bottom, 0.1)
                        Text("Poles")
                            .font(.system(size: 15, weight: .regular, design: .serif))
                            .foregroundStyle(Color(hex: "#7B818C"))
                    }
                    .frame(maxWidth: .infinity)
                    
                    
                    
                    VStack {
                        Text("\(team.FastestLapsSeasonTeam(for: selectedYear, language: AppState.selectedLanguage.rawValue,))")
                            .font(.system(size: 20, weight: .bold, design: .serif))
                            .foregroundStyle(Color.white)
                            .padding(.bottom, 0.1)
                        Text("Fast Laps")
                            .font(.system(size: 15, weight: .regular, design: .serif))
                            .foregroundStyle(Color(hex: "#7B818C"))
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("\(team.RacesSeasonTeam(for: selectedYear, language: AppState.selectedLanguage.rawValue))")
                            .font(.system(size: 20, weight: .bold, design: .serif))
                            .foregroundStyle(Color.white)
                            .padding(.bottom, 0.1)
                        Text("Races")
                            .font(.system(size: 15, weight: .regular, design: .serif))
                            .foregroundStyle(Color(hex: "#7B818C"))
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 10)
                .padding(.trailing, 4)
                .background(Color(hex: "#161D27"))
                .cornerRadius(8)
                
                
                HStack {
                    Spacer()
                }
                .padding(20)
                .background(Color( hex: "#0F1624"))
                
                
                
            }
            
            
            
            
            
            
        }
        .padding(.top , -14)
        
        .frame(maxWidth: .infinity)
        
    }
}



struct TeamDetailView: View {
    let team: Team
    @Binding var searchText: String


    var body: some View {
        Text(team.name)
            .font(.system(size: 36, weight: .bold, design: .serif))

    }
}




#Preview("Standart Preview"){
    ContentView()
        .environmentObject(AppState())
}


