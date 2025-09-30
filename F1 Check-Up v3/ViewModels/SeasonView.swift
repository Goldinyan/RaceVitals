//
//  SeasonView.swift
//  F1 Check-Up v3
//
//  Created by Ansgar Seifert on 07.08.25.
//

import SwiftUI

struct SeasonViewAll: View {
    @EnvironmentObject var AppState: AppState
    
    
    @State private var drivers: [Driver] = []
    @State private var teams: [Team] = []
    @State private var allYears: [Int] = []
    @State private var Races: [Circuit] = []
    @State private var RacesNames: [String] = []
    @State private var circuits: [Circuit] = []
    @State private var selectedYear: Int = 2024
    @State private var allSeason: Bool = false
    @State private var seasonDrivers: [Driver] = []
    @State private var RacesView: Bool = false
    
    func loadInfo() {
        let languageKey = AppState.selectedLanguage.rawValue
        drivers = allDrivers.localized[languageKey] ?? []
        teams = allTeams.localized[languageKey] ?? []
        
        allYears = Array(Set(drivers.flatMap { driver in
            driver.seasons.compactMap { Int($0.year) }
        })).sorted()
        
        circuits = allCircuits.localized[languageKey] ?? []
        
        seasonDrivers = drivers
                .filter { driver in
                    driver.seasons.contains(where: { $0.year == selectedYear })
                }
                .sorted { a, b in
                    let posA = a.seasons.first(where: { $0.year == selectedYear })?.position ?? Int.max
                    let posB = b.seasons.first(where: { $0.year == selectedYear })?.position ?? Int.max
                    return posA < posB
                }
        
        RacesNames = Array(Set(
            drivers.flatMap { driver in
                driver.seasons.flatMap { season in
                    season.raceStats.compactMap { race in
                        race.location
                    }
                }
            }
        ))

        
        
        Races = RacesNames.compactMap { raceName in
            circuits.first(where: { $0.country == raceName })
        }

    }
  
    var body: some View {
        NavigationStack{
            GeometryReader{ geometry in
                ZStack{
                    
                    AppState.PrimaryColor.color
                        .ignoresSafeArea()
                    
                    
                    ScrollView(showsIndicators: false){
                            if allSeason {
                                    VStack{
                                    ForEach(allYears, id: \.self) { year in
                                        Button("\(String(format: "%d", year))") {
                                            selectedYear = year
                                            withAnimation{
                                                allSeason = false
                                                print(allYears)
                                            }
                                        }
                                    }
                                    .onChange(of: selectedYear) {
                                        loadInfo()
                                    }
                                }
                                .position(x: geometry.size.width * 0.5)
                                
                            } else {
                                VStack(spacing: 0){
                                    Button{
                                        allSeason = true
                                    } label:{
                                        Text("\(String(format: "%d", selectedYear))")
                                            .font(.system(size: 30, weight: .bold, design: .default))
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.07)
                                    .background(AppState.PrimaryColor.color)
                                    
                                    Text("Standings")
                                        .foregroundStyle(Color.white)
                                    
                                    ForEach(seasonDrivers) { driver in
                                        
                                        NavigationLink(destination: DriverDetailView(driver: driver)) {
                                            
                                            SeasonDetailView( allSeason: $allSeason, selectedYear: selectedYear, drivers: drivers, teams: teams, seasonDrivers: seasonDrivers, driver: driver )
                                            
                                            
                                        }
                                    }
                                    
                                    HStack{
                                        Button{
                                            withAnimation{
                                                RacesView.toggle()
                                            }
                                            
                                        }label:{
                                            Text("Races")
                                        }
                                    }
                                    
                                        if RacesView {
                                            ForEach(Races) { race in
                                                RaceRacesStatsView(race: race, selectedYear: selectedYear, drivers: drivers)
                                                    .transition(.opacity)
                                            }
                                            
                                            
                                        }
                                    
                                }
                                .frame(maxWidth: .infinity, maxHeight:  .infinity)
                                .background(Color(hex:"#101625"))

                                
                            }
                        }
                    

                    
                    
                }
                .onAppear(perform: loadInfo)
                .onChange(of: AppState.selectedLanguage) {
                    loadInfo()
                }
            }
        }

    }
}

struct RaceRacesStatsView: View {
    let race: Circuit
    let selectedYear: Int
    
    let drivers : [Driver]
    @State private var filteredDrivers: [Driver] = []
    
    
    func loadfilteredDriversRacesStats()  {
        
        
        filteredDrivers = drivers.filter { driver in
            driver.seasons.contains { season in
                season.year == selectedYear &&
                season.raceStats.contains { raceStat in
                    raceStat.location == race.country
                }
            }
        }
        .sorted { a, b in
            
        let posA = a.seasons
                        .filter { $0.year == selectedYear }
                        .flatMap { $0.raceStats }
                        .first(where: { $0.location == race.country })?.position ?? Int.max

            let posB = b.seasons
                        .filter { $0.year == selectedYear }
                        .flatMap { $0.raceStats }
                        .first(where: { $0.location == race.country })?.position ?? Int.max

                    return posA < posB
            
            

        }
        
   

        
       
    }
    
    @State private var CircuitsExpanded: Bool = false
    var body: some View {
        VStack{
            HStack{
                
                
                Text(race.name.isEmpty ? "No name" : race.name)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.black)
                    .padding()
                
                Button{
                    CircuitsExpanded.toggle()
                }label: {
                    Image(systemName: CircuitsExpanded ? "arrow.up" : "arrow.down")
                }
            }
            if CircuitsExpanded {
                CircuitsExpandedView(selectedYear: selectedYear, race : race, filteredDrivers: filteredDrivers)
                .onAppear(perform: loadfilteredDriversRacesStats)
                .onChange(of: CircuitsExpanded){
                    loadfilteredDriversRacesStats()
                }

            }
        }
        
    }
}

struct CircuitsExpandedView: View {
    let selectedYear : Int
    let race: Circuit
    let filteredDrivers: [Driver]
    @State private var expandedView: Bool = false
    
    func RaceStats(driver: Driver, topic: String) -> Any {
        
        switch topic {
        case "Position":
            if let season = driver.seasons.first(where: { $0.year == selectedYear }),
                let raceStat = season.raceStats.first(where: { $0.location == race.country }) {
                 
                 return raceStat.position ?? 000
             }
             return "DNF"
        case "Points":
            if let season = driver.seasons.first(where: { $0.year == selectedYear }) {
                if let raceStat = season.raceStats.first(where: { $0.location == race.country }) {
                    return raceStat.points
                }
            }
            return 000
        case "FastestLap":
            if let season = driver.seasons.first(where: { $0.year == selectedYear }) {
                if let raceStat = season.raceStats.first(where: { $0.location == race.country }) {
                    return raceStat.fastestLap
                }
            }
            return false
        case "FastestLapTime":
            if let season = driver.seasons.first(where: { $0.year == selectedYear }) {
                if let raceStat = season.raceStats.first(where: { $0.location == race.country }) {
                    return raceStat.fastestLapTime ?? 000
                }
            }
            return 000
        
        case "Penalty":
            if let season = driver.seasons.first(where: { $0.year == selectedYear }) {
                if let raceStat = season.raceStats.first(where: { $0.location == race.country }) {
                    return raceStat.penalties
                }
            }
            return 000
        case "PenaltyReason":
            if let season = driver.seasons.first(where: { $0.year == selectedYear }) {
                if let raceStat = season.raceStats.first(where: { $0.location == race.country }) {
                    return raceStat.reasonPenalty ?? ""
                }
            }
            return ""
        
        case "ReasonDNF":
            if let season = driver.seasons.first(where: { $0.year == selectedYear }) {
                if let raceStat = season.raceStats.first(where: { $0.location == race.country }) {
                    return raceStat.reasonDnf ?? ""
                }
            }
            return ""
        default:
            return("Wrong topic")
        }
        
        
        
    }
    
    var body: some View {
        Text(race.country)
        ForEach(filteredDrivers){ driver in
            VStack{
                HStack{
                    if (RaceStats(driver: driver, topic: "Position") as? String) == "DNF"
                    {
                        Text("DNF")
                            .foregroundStyle(Color.white)
                    } else {
                        Text(String(describing: RaceStats(driver: driver, topic: "Position")))
                            .foregroundStyle(Color.white)

                    }

                    Button{
                        expandedView.toggle()
                    }    label: {
                        Image(systemName: expandedView ? "arrow.up" : "arrow.down")
                            .foregroundStyle(Color.white)

                    }
                    Text(driver.name)
                        .foregroundStyle(Color.white)

                    Spacer()
                    Text(String(describing: RaceStats(driver: driver, topic: "Points")))
                        .foregroundStyle(Color.white)

                }
                .frame(maxWidth: .infinity)
                if expandedView {
                    HStack{
                        
                        
                    }
                }
            }
                
        }
        
    }
}
struct SeasonDetailView: View {
    @EnvironmentObject var AppState: AppState
    @Binding var allSeason: Bool
    let selectedYear: Int
    let drivers: [Driver]
    let teams : [Team]
    let seasonDrivers: [Driver]
    let driver: Driver
   


    func colorForDriver(_ driver: Driver) -> String {
        guard let season = driver.seasons.first(where: { $0.year == selectedYear }) else {
            return "Gray" // Fallback, wenn keine Saison gefunden
        }
        
        let team = season.team
        
        return AppState.TeamColors(team: team)
    }


    var body: some View {
       // GeometryReader{ geometry in
            ZStack{
                VStack{
                    
                    
                    HStack{
                        VStack(alignment: .leading){
                            Text(driver.name)
                                .foregroundStyle(.white)
                                .font(.system(size: 20))
                            Text(driver.country)
                                .foregroundStyle(.white.opacity(0.7))
                                .font(.system(size: 12))
                            
                        }
                        Spacer()
                        
                        Text("\(driver.seasons.first(where: { $0.year == selectedYear })?.position ?? 0)")
                            .foregroundStyle(.white)
                            .font(.system(size: 30))
                        
                    }
                    .padding()
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Color(hex: colorForDriver(driver))
                )

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)


        // }
            
    }
}
#Preview {
    ContentView()
        .environmentObject(AppState())
}
