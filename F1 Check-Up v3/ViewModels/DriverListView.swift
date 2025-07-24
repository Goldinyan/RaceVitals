//
//  DriverListView.swift
//  F1 Check-Up v3
//
//  Created by Ansgar Seifert on 04.07.25.
//

import SwiftUI









struct DriverListView: View {
    @AppStorage("english") private var englisch: Bool = false
    @State private var searchText = ""
    @State private var selectedSortIndex = 0
    @State private var drivers = allDrivers
    @State private var teams = allTeams
    @State private var driverview = false
    @State private var teamview = true
    @State private var searchbar = ["Search drivers...", "Search teams..."]
    @State private var selectedYear: Int? = nil // nil = Alle Jahre

    // Alle Jahre aus allen Fahrern sammeln (einmalig beim Start)
    let allYears: [Int] = Array(Set(allDrivers.flatMap { driver in
        driver.seasons.map { Int($0.year) }
    })).sorted()

   
    
    func idk () {
        print(allYears)
    }
    
    
    var filteredTeams: [Team] {
        let filteredBySearch = searchText.isEmpty ? teams : teams.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
        
        if let year = selectedYear {
            return filteredBySearch.filter { team in
                (team.currentDrivers + team.oldDriver).contains { driver in
                    driver.seasons.contains { $0.year == year && $0.team == team.name }
                }

            }
        } else {
            return filteredBySearch.sorted { $0.name < $1.name }
        }
    }

    
    var filteredDrivers: [Driver] {
        let filteredBySearch = searchText.isEmpty ? drivers : drivers.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
        
        if let year = selectedYear {
            return filteredBySearch.filter { driver in
                driver.seasons.contains { $0.year == year }
            }.sorted {
                if $0.currentTeam == $1.currentTeam {
                    return $0.name < $1.name
                } else {
                    return $0.currentTeam < $1.currentTeam
                }
            }
        } else {
            return filteredBySearch.sorted {
                if $0.currentTeam == $1.currentTeam {
                    return $0.name < $1.name
                } else {
                    return $0.currentTeam < $1.currentTeam
                }
            }
        }
    }

        
    
    var body: some View {
        NavigationStack {
        ZStack{
            Color(hex: "#101625") // 👉 Gesamthintergrund
                .ignoresSafeArea()
            
            VStack {
                
                
                HStack {
                    
                    Button(action: {
                        driverview.toggle()
                        teamview.toggle()
                    }) {
                        Text("Drivers")
                            .font(.system(size : 30, weight: .bold, design: .serif))
                            .foregroundColor(driverview ? .red : .white)
                            .cornerRadius(10)
                          
                            .background(
                                Group {
                                    if driverview {
                                        Rectangle()
                                            .fill(driverview ? Color.red : Color.white)
                                            .frame(width: 160, height: 4)
                                            .offset(y: 40)
                                            .frame(maxWidth: .infinity, alignment: .bottom)
                                    }
                                }
                            )
                    }
                   // .border(Color.white, width: 1)
                    .padding(.trailing, 60)
                    
                    Button(action: {
                        driverview.toggle()
                        teamview.toggle()
                    }) {
                        Text("Teams")
                            .font(.system(size : 30, weight: .bold, design: .serif))
                            .foregroundColor(teamview ? .red : .white)
                            .cornerRadius(10)
                            .background(
                                Group {
                                    if teamview {
                                        Rectangle()
                                            .fill(teamview ? Color.red : Color.white)
                                            .frame(width: 160, height: 4)
                                            .offset(y: 40)
                                            .frame(maxWidth: .infinity, alignment: .bottom)
                                    }
                                }
                            )
                    }
                    
                    
                    
                    
                    
                }
                .position(x: 160, y: 30)
                .frame(maxWidth: .infinity, maxHeight: 80)
                .padding(.leading, 35)
                .padding(.bottom, 0)
                
                
                HStack {
                    Menu {
                        Button("All-Time") { selectedYear = nil }
                        ForEach(allYears, id: \.self) { year in
                            Button("\(year)") { selectedYear = year }
                        }
                    } label: {
                        Text(selectedYear != nil ? "\(selectedYear!)" : "All-Time")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium, design: .serif))
                            .padding(EdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5))
                            .cornerRadius(2)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                            .shadow(radius: 4)
                            .padding(.trailing,5)

                        
                    }





                    
                    Image(systemName: "magnifyingglass") // 🔍 Icon
                        .foregroundColor(.init(white: 0.6))          // Farbe des Icons
                    
                    TextField(driverview ? searchbar[0] : searchbar[1], text: $searchText)
                        .foregroundColor(.white)          // Farbe des Icons
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.init(white: 0.6))
                    }
                }
                .padding()
                
                .background(Color(hex: "#1F2937"))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .padding(.horizontal)
                
               
                
              
                
                // 📋 Fahrer Liste
                
                    
                    if driverview {
                    
               
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(filteredDrivers) { driver in
                                NavigationLink(destination: DriverDetailView(driver: driver)) {
                                    DriverRowView(driver: driver, selectedYear: self.selectedYear)

                                }
                            }
                            
                            
                            
                        }
                        .padding()
                        
                    }
                    .listRowInsets(EdgeInsets())
                    .listStyle(PlainListStyle())
                    .listRowBackground(Color.clear)
                    .background(Color(hex:"#101625"))
                    }
                
                
                if teamview {
                    
                    
                    ScrollView {
                       
                        LazyVStack(spacing: 0) {
                            ForEach(filteredTeams) { team in
                                NavigationLink(destination: TeamDetailView(team: team)) {
                                    TeamListView(team: team, selectedYear: self.selectedYear)
                                    
                                }
                            }
                        }
                        .padding()
                        
                        
                        
                        
                    }
                    .listRowInsets(EdgeInsets())
                    .listStyle(PlainListStyle())
                    .listRowBackground(Color.clear)
                    .background(Color(hex:"#101625"))
                    
                    
                    
                    
                    
                }
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                }
                
                
            }
            
            
        }
    }
    

    
    struct DriverRowView: View {
        
        let driver: Driver
        let selectedYear: Int?
      
        

        
        func idk(){
            print("idk")
        }
        
        
        
        
        var body: some View {
            ZStack (alignment: .leading){
                
                
              
                    
                    
                    
                    
                    
                    
                    
                    
                    VStack(alignment: .leading){
                        
                        VStack{
                            
                            HStack{
                                
                                
                                Image(driver.image)
                                  .resizable()
                                  .aspectRatio(contentMode: .fit)
                                  .frame(width: 350, height: 210)
                            }
                            .padding(8)
                            .border(Color( hex: "#1F2937"), width: 5)
                            

                            
                            
                            HStack {
                                Text("#\(driver.number)")
                                    .font(.system(size: 22, weight: .bold, design: .serif))
                                    .foregroundStyle(.white)
                                    .padding(3)
                                    .foregroundStyle(.white)
                                    .background(Color.red)
                                    .cornerRadius(10)
                                    .padding(.leading, 24)
                                    .padding(.trailing, 5)
                                
                                Text(driver.name)
                                    .font(.system(size: 25, weight: .bold, design: .serif))    .foregroundStyle(.white)
                                Spacer()
                            }
                            .padding(.top, 22)
                            .background(Color( hex: "#1F2937"))
                            //.padding(.top, 10)
                            
                            
                            
                            HStack {
                                Text(driver.currentTeam)
                                    .font(.system(size: 20, weight: .regular, design: .serif))
                                    .foregroundStyle(Color( hex: "#D1D5DA"))
                                    .padding(.leading, 24)
                                Spacer()
                            }
                            .padding(.top, 10)
                            .background(Color( hex: "#1F2937"))
                            .padding(.top, -8)
                            
                            
                            
                            HStack {
                                Text(driver.country)
                                    .font(.system(size: 20, weight: .regular, design: .serif))
                                    .foregroundStyle(Color( hex: "#9BA3AF"))
                                    .padding(.leading, 24)
                                
                                Spacer()
                            }
                            .padding(.top, 10)
                            .background(Color( hex: "#1F2937"))
                            .padding(.top, -8)
                            
                            HStack{
                                Text("Points: ")
                                    .font(.system(size: 20, weight: .regular, design: .serif))
                                    .foregroundStyle(Color( hex: "#98A0AC"))
                                    .bold()
                                
                                Spacer()
                                Text("\(driver.totalPoints)")
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
                            .padding(.top, -9)
                            
                        }
                        

                       
                        
                        
                        
                        HStack {
                            // 🏆 Wins
                            VStack {
                                Text(
                                    "\( selectedYear != nil ? (driver.seasons.first(where: { $0.year == selectedYear! })?.wins ?? 0) : driver.totalWins )"
                                )
                                .font(.system(size: 20, weight: .bold, design: .serif))
                                .foregroundStyle(Color.white)
                                .padding(.bottom, 0.1)
                                Text("Wins")
                                    .font(.system(size: 15, weight: .regular, design: .serif))
                                    .foregroundStyle(Color(hex: "#7B818C"))
                            }
                            .frame(maxWidth: .infinity)

                            // 🥈 Podiums
                            VStack {
                                Text(
                                    "\( selectedYear != nil ? (driver.seasons.first(where: { $0.year == selectedYear! })?.podiums ?? 0): driver.totalPodiums )"
                                )
                                .font(.system(size: 20, weight: .bold, design: .serif))
                                .foregroundStyle(Color.white)
                                .padding(.bottom, 0.1)
                                Text("Podiums")
                                    .font(.system(size: 15, weight: .regular, design: .serif))
                                    .foregroundStyle(Color(hex: "#7B818C"))
                            }
                            .frame(maxWidth: .infinity)

                            // 🏁 Poles
                            VStack {
                                Text(
                                    "\(selectedYear != nil ? (driver.seasons.first(where: { $0.year == selectedYear! })?.poles ?? 0) : driver.totalPoles )"
                                )
                                .font(.system(size: 20, weight: .bold, design: .serif))
                                .foregroundStyle(Color.white)
                                .padding(.bottom, 0.1)
                                Text("Poles")
                                    .font(.system(size: 15, weight: .regular, design: .serif))
                                    .foregroundStyle(Color(hex: "#7B818C"))
                            }
                            .frame(maxWidth: .infinity)

                            // ⚡ Fast Laps
                            VStack {
                                Text(
                                    "\(selectedYear != nil ? (driver.seasons.first(where: { $0.year == selectedYear! })?.fastestLaps ?? 0) : driver.totalFastestLaps)"
                                )
                                .font(.system(size: 20, weight: .bold, design: .serif))
                                .foregroundStyle(Color.white)
                                .padding(.bottom, 0.1)
                                Text("Fast Laps")
                                    .font(.system(size: 15, weight: .regular, design: .serif))
                                    .foregroundStyle(Color(hex: "#7B818C"))
                            }
                            .frame(maxWidth: .infinity)

                            // 🚨 Penalties
                            VStack {
                                Text(
                                    "\(selectedYear != nil ? (driver.seasons.first(where: { $0.year == selectedYear! })?.penaltyPoints ?? 0) : driver.totalPenaltyPoints )"
                                )
                                .font(.system(size: 20, weight: .bold, design: .serif))
                                .foregroundStyle(Color.white)
                                .padding(.bottom, 0.1)
                                Text("Penalties")
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
    
}



struct DriverDetailView: View {
    let driver: Driver

    @State private var selectedSeasonIndex = 0

    var seasonOptions: [String] {
        ["All-Time"] + driver.seasons.map { String($0.year) }
    }

    var body: some View {
        VStack(spacing: 20) {
            Picker("Season", selection: $selectedSeasonIndex) {
                ForEach(0..<seasonOptions.count, id: \.self) { index in
                    Text(seasonOptions[index]).tag(index)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            if selectedSeasonIndex == 0 {
                // All-Time: Gesamtdaten
                Text("Total Points: \(driver.totalPoints)")
                Text("Total Wins: \(driver.totalWins)")
                Text("Total Podiums: \(driver.totalPodiums)")
                Text("Total Races: \(driver.totalRaces)")
                Text("Total Penalty Points: \(driver.totalPenaltyPoints)")
            } else {
                // Einzelne Saison anzeigen
                let season = driver.seasons[selectedSeasonIndex - 1]
                Text("Year: \(season.year)")
                    .font(.headline)
                Text("Team: \(season.team)")
                Text("Position: \(season.position)")
                Text("Points: \(season.points)")
                Text("Wins: \(season.wins)")
                Text("Podiums: \(season.podiums)")
                Text("Races: \(season.races)")
                Text("Penalty Points: \(season.penaltyPoints)")
            }

            Spacer()
        }
        .navigationTitle(driver.name)
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}


#Preview {
    ContentView()
        .environmentObject(AppState())
        
}
