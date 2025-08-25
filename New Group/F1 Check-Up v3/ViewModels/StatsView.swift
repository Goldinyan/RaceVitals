//
//  StatsView.swift
//  F1 Check-Up v3
//
//  Created by Ansgar Seifert on 18.08.25.
//



import SwiftUI

enum DriverSortType: String, CaseIterable {
    case points, wins, podiums, fastestLaps, polePositions, winRate
}



enum TeamSortType: String, CaseIterable {
    case points, wins, podiums, races
}

enum AllSortingTypes: Hashable {
    case drivers(DriverSortType)
    case teams(TeamSortType)
}

enum CircuitSortType: String, CaseIterable {
    case oldest, newest, length, turns, laps, level
}


struct StatsView: View {
    
    @EnvironmentObject var AppState: AppState
    @State private var allYears: [Int] = []
    @State private var expandedViews: [AllSortingTypes:  Bool] = [:]
    @State private var expandedTopics: [String: Bool] = [:]
    
    
    
    //MARK: DRIVERS
   
    
    @State private var baseDrivers: [Driver] = []
    @State private var sortedDrivers: [DriverSortType: [Driver]] = [:]
    
    //MARK: TEAMS
    
   
    
    @State private var teams: [Team] = []
    @State private var sortedTeams: [TeamSortType: [Team]] = [:]
    
    //MARK: CIRCUITS
    
    @State private var circuits: [Circuit] = []
    @State private var sortedCircuits: [CircuitSortType: [Circuit]] = [:]

    
    
    
   
    
    func loadInfo() {
        let languageKey = AppState.selectedLanguage.rawValue
        
        
        allYears = Array(Set(baseDrivers.flatMap { driver in
            driver.seasons.map { Int($0.year) }
        })).sorted()
            
        expandedTopics = [
            "Featured" : false ,
            "Driver" : false ,
            "Team" : false ,
            "Circuit" : false
        ]
            
        //MARK: DRIVERS
        
        baseDrivers = allDrivers.localized[languageKey] ?? []
        sortedDrivers = [
                .points: baseDrivers.sorted { $0.totalPoints > $1.totalPoints },
                .wins: baseDrivers.sorted { $0.totalWins > $1.totalWins },
                .podiums: baseDrivers.sorted { $0.totalPodiums > $1.totalPodiums },
                .fastestLaps: baseDrivers.sorted { $0.totalFastestLaps > $1.totalFastestLaps },
               
            ]
        
        //MARK: TEAMS
        
        teams = allTeams.localized[languageKey] ?? []
        sortedTeams = [
            .points: teams.sorted { $0.totalPoints(language: languageKey) > $1.totalPoints(language: languageKey) },
            .wins: teams.sorted { $0.totalWins(language: languageKey) > $1.totalWins(language: languageKey) },
            .podiums: teams.sorted { $0.totalPodiums(language: languageKey) > $1.totalPodiums(language: languageKey) },
            .races: teams.sorted { $0.totalRaces(language: languageKey) > $1.totalRaces(language: languageKey) },
            
            
            
            
        ]
        
        
        //MARK: CIRCUITS
        
        circuits = allCircuits.localized[languageKey] ?? []
        
        
        
        

    }
    
    var body: some View {
        GeometryReader{ geo in
        ZStack{
            Color(hex:"#101625")
                .ignoresSafeArea()
            
            
            
            VStack{
                HeaderViewStats()
                    .frame(maxHeight: geo.size.height * 0.046)
                    ScrollView(showsIndicators: false){
                        VStack{
                            
                            TopperViews(topic: "Featured", expandedTopics: $expandedTopics)
                                    .padding(.bottom, geo.size.height * 0.05)
                            TopperViews(topic: "Driver", expandedTopics: $expandedTopics)
                                    .padding(.bottom, geo.size.height * 0.05)
                            if let DriverShow = expandedTopics["Driver"] {
                                if DriverShow {
                                    AllDriverStatsView(sortedDrivers: sortedDrivers, allYears: allYears, expandedTopics: $expandedTopics)
                                }
                            }
                            
                        }
                        .frame(maxWidth: .infinity)
                    }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                loadInfo()
            }
            .onChange(of: AppState.selectedLanguage) {
                loadInfo()
                }
            }
        }
    }
}

struct AllDriverStatsView: View {
    
    let sortedDrivers: [DriverSortType: [Driver]]
    let allYears: [Int]
    @Binding var expandedTopics: [String : Bool]
    
    @State private var ExpandedView: [DriverSortType: Bool] = [:]
    
    func initializeExpandedViews() {
        ExpandedView.removeAll()
        for type in DriverSortType.allCases {
            ExpandedView[type] = false
        }
    }
    
    var body: some View {
        GeometryReader{ geo in
            VStack(spacing: geo.size.height * 0.4){
                if let podiumDrivers = sortedDrivers[.podiums] {
                    DriverPodiumView(driver: podiumDrivers, allYears: allYears, expandedTopics: $expandedTopics)
                        .padding(.bottom, (ExpandedView[.podiums] ?? false) ? UIScreen.main.bounds.height * 0.9 : UIScreen.main.bounds.height * 0.35)

                }
               
                if let winDrivers = sortedDrivers[.wins] {
                    DriverWinsView(driver: winDrivers, allYears: allYears, expandedTopics: $expandedTopics)
                    
                }
                
            }
           // .frame(maxHeight: .infinity)
            .onAppear(){
                initializeExpandedViews()
            }
        }
        
    }
}
struct DriverWinsSingleView: View {
    let driver: Driver
    @EnvironmentObject var AppState: AppState

    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        let dynamicPadding = screenWidth * 0.05

        HStack {
            VStack(alignment: .leading) {
                Text(driver.name)
                    .foregroundStyle(Color.white)
              
                
            }
            .padding(.trailing, dynamicPadding)
            .background(Color( hex: "#1F2937"))

            
            Spacer()
            HStack{
                Text("\(driver.totalWins)")
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .foregroundStyle(Color.white)
            }
                .padding(dynamicPadding * 0.25)
                .padding(.horizontal)
                .background(Color( hex: "#161D27"))
                .cornerRadius(dynamicPadding * 0.5)
        }
        .padding(dynamicPadding * 0.5)
        .background(Color( hex: "#1F2937"))
        .cornerRadius(dynamicPadding * 0.5)
        .padding(.bottom, dynamicPadding * 0.5)
    }
}

struct DriverWinsView: View {
    
    let driver: [Driver]
    let allYears: [Int]
    @Binding var expandedTopics: [String : Bool]
    @State private var selectedYear: Int? = nil // nil = All Time
    @EnvironmentObject var AppState: AppState
    
    var body: some View {
        GeometryReader{ geo in
            VStack(alignment: .leading){
                HStack{
                    Text("Highest Wins")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .foregroundStyle(Color.white)
                        .padding(.leading, geo.size.width * 0.02)
                    Spacer()
                    
                    Menu{
                        Button("All-Time") { selectedYear = nil }
                        ForEach(allYears, id: \.self) { year in
                            Button("\(year)") { selectedYear = year }
                        }
                    } label: {
                        Text(selectedYear != nil ? "\(selectedYear!)" : "All-Time")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .foregroundStyle(Color.white)
                            .padding(.trailing, geo.size.width * 0.03)

                    }
                }
                ForEach(driver) { driver in
                    DriverWinsSingleView(driver: driver)
                    
                }
                
                
            }
            .padding(geo.size.width * 0.05)
            .background(Color( hex: "#161D27"))
            .cornerRadius(geo.size.width * 0.05)
            .padding(geo.size.width * 0.05)

        }
    }
}

struct DriverPodiumView: View   {
    
    let driver: [Driver]
    let allYears: [Int]
    @Binding var expandedTopics: [String : Bool]
    @State private var selectedYear: Int? = nil // nil = All Time
    @EnvironmentObject var AppState: AppState
    
    var body: some View {
        
        GeometryReader{ geo in
            VStack(alignment: .leading){
                HStack{
                    Text("Highest Podiums")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .foregroundStyle(Color.white)
                        .padding(.leading, geo.size.width * 0.02)
                    Spacer()
                    
                    Menu{
                        Button("All-Time") { selectedYear = nil }
                        ForEach(allYears, id: \.self) { year in
                            Button("\(year)") { selectedYear = year }
                        }
                    } label: {
                        Text(selectedYear != nil ? "\(selectedYear!)" : "All-Time")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .foregroundStyle(Color.white)
                            .padding(.trailing, geo.size.width * 0.03)

                    }
                }
                ForEach(driver) { driver in
                    DriverPodiumSingleView(driver: driver)
                    
                }
                
                
            }
            .padding(geo.size.width * 0.05)
            .background(Color( hex: "#161D27"))
            .cornerRadius(geo.size.width * 0.05)
            .padding(geo.size.width * 0.05)

        }
    }
    
}
struct DriverPodiumSingleView: View {
    let driver: Driver
    @EnvironmentObject var AppState: AppState

    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        let dynamicPadding = screenWidth * 0.05

        HStack {
            VStack(alignment: .leading) {
                Text(driver.name)
                    .foregroundStyle(Color.white)
              
                
            }
            .padding(.trailing, dynamicPadding)
            .background(Color( hex: "#1F2937"))

            
            Spacer()
            HStack{
                Text("\(driver.totalPodiums)")
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .foregroundStyle(Color.white)
            }
                .padding(dynamicPadding * 0.25)
                .padding(.horizontal)
                .background(Color( hex: "#161D27"))
                .cornerRadius(dynamicPadding * 0.5)
        }
        .padding(dynamicPadding * 0.5)
        .background(Color( hex: "#1F2937"))
        .cornerRadius(dynamicPadding * 0.5)
        .padding(.bottom, dynamicPadding * 0.5)
    }
}

struct TopperViews: View {
    let topic: String
    @Binding var expandedTopics: [String : Bool]
    
    var body: some View {
        GeometryReader{ geo in
        HStack{
            Text(topic)
                .foregroundStyle(Color.white)
                .font(.system(size: 24, weight: .bold, design: .default))
                .padding(.leading, geo.size.width * 0.1)
            Spacer()
            Button{
                if expandedTopics[topic] == false {
                    expandedTopics[topic] = true
                } else {
                    expandedTopics[topic] = false
                }
            }
            label: {
                Image(systemName: (expandedTopics[topic] ?? false) ? "chevron.up" :"chevron.down")
                    .foregroundStyle(Color.white)
            }
            .padding(.trailing, geo.size.width * 0.1)

        }
        .frame(maxWidth: .infinity)
        .padding(.vertical , geo.size.width * 0.04)
        .background(Color( hex: "#161D27"))
        }

    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())

}
