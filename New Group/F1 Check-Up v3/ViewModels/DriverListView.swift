//
//  DriverListView.swift
//  F1 Check-Up v3
//
//  Created by Ansgar Seifert on 04.07.25.
//






import SwiftUI



public struct TopCornersRounded: Shape {
    var radius: CGFloat = 20

    public func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addQuadCurve(to: CGPoint(x: rect.minX + radius, y: rect.minY),
                          control: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + radius),
                          control: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()

        return path
    }
}


struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}



struct DriverListView: View {
    @AppStorage("english") private var englisch: Bool = false
    @State private var selectedSortIndex = 0
    @State private var drivers: [Driver] = []
    @State private var teams: [Team] = []
    @State private var driverview = false
    @State private var teamview = true
    @State private var searchbar = ["Search drivers...", "Search teams..."]
    @State private var selectedYear: Int? = nil // nil = Alle Jahre
    @State private var scrollOffset: CGFloat = 0
    @State private var showHeader: Bool = true
    @State private var lastScrollOffset: CGFloat = 0
    @State private var searchText = ""
    @EnvironmentObject var AppState : AppState
    @State private var allYears: [Int] = []
    @State private var allIndices: [Int] = []
    @State private var SearchBar: Bool = false
   
    
  
    func loadInfo() {
        let languageKey = AppState.selectedLanguage.rawValue
        drivers = allDrivers.localized[languageKey] ?? []
        teams = allTeams.localized[languageKey] ?? []
        
        allYears = Array(Set(drivers.flatMap { driver in
            driver.seasons.map { Int($0.year) }
        })).sorted()
        
        allIndices = AppState.FavIndicies.sorted() +
            (0..<Options.count).filter { !AppState.FavIndicies.contains($0) }

       
    }
  
    
 
    
   
    func updateLocalizedData()
    {
        let LanguageKey = AppState.selectedLanguage.rawValue
        drivers = allDrivers.localized[LanguageKey] ?? []
        teams = allTeams.localized[LanguageKey] ?? []
        
        allIndices = AppState.FavIndicies.sorted() +
            (0..<Options.count).filter { !AppState.FavIndicies.contains($0) }
    }
    
        var body: some View {
            NavigationStack {
                ZStack {
                    AppState.PrimaryColor.color
                                .ignoresSafeArea()



                    VStack(spacing: 0) {
                        
                        if showHeader {
                            
                              
                            HeaderView(SearchBar: $SearchBar, searchText: $searchText, allIndices: $allIndices, selectedYear: $selectedYear)
                             .transition(.move(edge: .top).combined(with: .opacity))
                            .animation(.easeInOut(duration: 0.01), value: showHeader)
                            .frame(maxHeight: SearchBar && AppState.SelectedOption == .Search
                                ? UIScreen.main.bounds.height * 0.22
                                   : SearchBar && AppState.SelectedOption == .Favorites
                                    ? UIScreen.main.bounds.height * 0.4
                                   : SearchBar && AppState.SelectedOption == .History ? UIScreen.main.bounds.height * 0.4 :
                                    nil)

                        }
                        
                        ScrollView(showsIndicators: false) {
                            GeometryReader { geo in
                                Color.clear
                                    .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .global).minY)
                            }
                            .frame(height: 0)
                            .onPreferenceChange(ScrollOffsetKey.self) { value in
                                let offset = value
                                   let delta = offset - lastScrollOffset

                                   if offset < 0 {
                                       if delta < -10 {
                                           // Hoch scrollen → Header ausblenden
                                           withAnimation { showHeader = false }
                                       } else if delta > 10 {
                                           // 🔽 Runter scrollen → Header wieder anzeigen
                                           withAnimation {
                                               showHeader = true
                                           }
                                           SearchBar = false


                                       }
                                   } else {
                                       //  Noch nicht gescrollt → Header sichtbar
                                       withAnimation { showHeader = true }
                                   }

                                   lastScrollOffset = offset
                               }
                            
                            ScrollView(showsIndicators: false) {
                                RowView(searchText: $searchText,selectedYear: $selectedYear, drivers: drivers, teams: teams)
                                .padding(.top, UIScreen.main.bounds.height * 0.02)
                                .background(Color(hex:"#101625"))
                                .clipShape(TopCornersRounded(radius: 20))
                            }
                            
                        }
                    }
                }
                .onAppear {
                    loadInfo()
                }
                .onChange(of: AppState.selectedLanguage) {
                    updateLocalizedData()
                }
                .onChange(of: AppState.FavIndicies) {
                    updateLocalizedData()
                }

               


            }
        }
    
}
    
struct RowView: View {
    @EnvironmentObject var AppState: AppState
    @Binding var searchText: String
    @Binding var selectedYear: Int?
    let drivers: [Driver]
    let teams: [Team]
    
    var filteredTeams: [Team] {
        let languagekey = AppState.selectedLanguage.rawValue

        let filteredBySearch = searchText.isEmpty ? teams : teams.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
        
        if let year = selectedYear {
            return filteredBySearch.filter { team in
                (team.currentDrivers(language: languagekey) + team.oldDriver(language: languagekey)).contains { driver in
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
        VStack(spacing: 0) {
            
            
            switch AppState.SelectedView {
                
                case "Team" :
                
                LazyVStack(spacing: 0) {
                    ForEach(filteredTeams) { team in
                        NavigationLink(destination: TeamDetailView(team: team, searchText: $searchText)) {
                            TeamListView(team: team, selectedYear: selectedYear)
                        }
                    }
                }
                .padding()
                
                if filteredTeams.isEmpty {
                    NothingHereView()
                }
                
                case "Driver" :
                
                LazyVStack(spacing: 0) {
                    ForEach(filteredDrivers) { driver in
                        NavigationLink(destination: DriverDetailView(driver: driver)) {
                            DriverRowView(driver: driver, selectedYear: selectedYear)
                                .onAppear {
                                    if !searchText.isEmpty {
                                        AppState.addHistory(value: driver.name, topic: AppState.SelectedView)
                                        print("added")
                                    }
                                }
                        }
                    }
                }
                .padding()
                
                if filteredDrivers.isEmpty {
                    NothingHereView()
                }
                
                
            case "Rules" :
                Text("Ups... Nothing here yet...")
                    .frame(maxWidth: .infinity)
            case "Strategies":
                Text("Ups... Nothing here yet...")
                    .frame(maxWidth: .infinity)

            case "Circuits":
                Text("Ups... Nothing here yet...")
                    .frame(maxWidth: .infinity)

            case "Records":
                Text("Ups... Nothing here yet...")
                    .frame(maxWidth: .infinity)

            case "Trivia":
                Text("Ups... Nothing here yet...")
                    .frame(maxWidth: .infinity)

                
            case "Fan Voting":
                Text("Ups... Nothing here yet...")
                    .frame(maxWidth: .infinity)

            case "Tech":
                Text("Ups... Nothing here yet...")
                    .frame(maxWidth: .infinity)

            case "Radio Moments":
                Text("Ups... Nothing here yet...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            
                
                default :
                
                
                    Text("Please select a view")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                
                
                
                
                
            }
           
           
        }
    }
}
struct HeaderTopView: View {
    @Binding var ShowOptions: Bool
    @Binding var SearchBar: Bool
    @Binding var expandedIndices: Set<Int>
    @Binding var toggleFavView: Bool
    @EnvironmentObject var AppState: AppState
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                HStack{
                    Spacer()
                    Button(action: {
                        ShowOptions.toggle()
                        expandedIndices = []
                        SearchBar = false
                    }) {
                        Text(ShowOptions ? "Vitals" : AppState.SelectedView)
                        
                            .font(.system(size: 26, weight: .bold, design: .default))
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 15, weight: .bold, design: .default))
                        
                        
                    }
                    .padding(.top, ShowOptions ? geometry.size.height * 0.015 : geometry.size.height * 0.15)
                        
                    
                    
                    Spacer()
                   
                    
                }
                HStack{
                    Button(action: {
                        if !ShowOptions {
                            SearchBar.toggle()
                        } else {
                            toggleFavView.toggle()
                        }
                    }) {
                        Image(systemName: ShowOptions ? "pencil" : (SearchBar ? "xmark" : "magnifyingglass"))
                            .font(.title2)
                    }
                }
                .padding(.top, ShowOptions ? geometry.size.height * 0.015 : geometry.size.height * 0.2)
                .padding(.leading, geometry.size.width * 0.8)
            }
        }
    }
}
struct HeaderView: View {
    @Binding var SearchBar: Bool
    @State private var ShowOptions: Bool = false
    @State private var ShowOptionsDetails = false
    @Binding var searchText: String
    @State private var toggleFavView: Bool = false
    @Binding var allIndices: [Int]
    @State private var expandedIndices: Set<Int> = []
    @Binding var selectedYear: Int?
    @EnvironmentObject var AppState : AppState
    
   
    
    var body: some View {
        
        VStack(spacing: 0) {
            GeometryReader { geometry in
                ScrollView(showsIndicators: false){
                    
                    HeaderTopView(ShowOptions: $ShowOptions, SearchBar: $SearchBar, expandedIndices: $expandedIndices, toggleFavView: $toggleFavView)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, geometry.size.height * 0.05)
                    
                    
                    
                    
                    
                    if ShowOptions {
                        VStack {
                            ForEach(allIndices, id: \.self) { i in
                                VStack(spacing: 10) {
                                    
                                    
                                    
                               /*    if Options[i].name == AppState.SelectedView {
                                        Spacer()
                                            .frame(height:  geometry.size.height * 0.01)
                                    }
                                    if Options[i].name != AppState.SelectedView { */
                                        
                                        VStack{
                                            HStack{
                                            
                                                Spacer()
                                                
                                                Button{
                                                    AppState.SelectedView = Options[i].name
                                                    ShowOptions = false
                                                } label: {
                                                    Text(Options[i].name)
                                                        .font(.system(size: 22, weight: .bold, design: .default))

                                                    
                                                }
                                                
                                                Spacer()
                                                
                                                if !Options[i].details.isEmpty {
                                                    Button {
                                                        if toggleFavView {
                                                            if AppState.FavIndicies.contains(i) {
                                                                AppState.FavIndicies.remove(i)
                                                            } else {
                                                                AppState.FavIndicies.insert(i)
                                                            }
                                                        } else {
                                                            
                                                       
                                                        
                                                        if expandedIndices.contains(i) {
                                                            expandedIndices.remove(i)
                                                        } else {
                                                            expandedIndices.insert(i)
                                                        }
                                                        }
                                                    } label: {
                                                        Image(systemName: AppState.FavIndicies.contains(i) && toggleFavView ? "star.fill" :
                                                            (toggleFavView ? "star" :
                                                                    
                                                            (expandedIndices.contains(i) ?
                                                             "chevron.up" : "chevron.down")))
                                                        
                                                            .foregroundColor(AppState.FavIndicies.contains(i) ? .yellow : .white)

                                                       
                                                    }
                                                    
                                                }
                                            }
                                            .padding(10)
                                            .padding(.vertical, geometry.size.height * 0.005)
                                            .padding(.horizontal, geometry.size.width * 0.03)
                                            .frame(maxWidth: geometry.size.width * 0.9)
                                            .background(Color.white.opacity(0.08))
                                           
                                            
                                       
                                        
                                        if expandedIndices.contains(i) {
                                            ForEach(Options[i].details.indices, id: \.self) { j in
                                                if Options[i].details == driverYears {
                                                    Button{
                                                       // selectedYear = Options[i].details[j].map { String($0) }

                                                    }label:{  Text(Options[i].details[j])
                                                            .padding(.top, geometry.size.height * 0.02)
                                                            .foregroundStyle(Color.white)
                                                            .font(.system(size: 22, weight: .bold, design: .default))

                                                            .frame(maxWidth: geometry.size.width * 0.8)}
                                                } else {
                                                    Text(Options[i].details[j])
                                                        .padding(.top, geometry.size.height * 0.02)
                                                        .foregroundStyle(Color.white)
                                                        .font(.system(size: 22, weight: .bold, design: .default))

                                                        .frame(maxWidth: geometry.size.width * 0.8)
                                                }
                                                Divider()
                                                    .background(Color.white)
                                                    .frame(height: 10)
                                                    .frame(maxWidth: geometry.size.width * 0.9 )
                                            }
                                            }
                                        }
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(10)


                                    

                                }
                            }

                            

                        }
                       .padding(.top, geometry.size.height * 0.02)
                    
                    }
                    
                }
                
            }
            .frame(minHeight: ShowOptions ? UIScreen.main.bounds.height * 0.8 : UIScreen.main.bounds.height * 0.06)
            .fixedSize(horizontal: false, vertical: true)

            if SearchBar {
                SearchBarView(searchText: $searchText)
            }


            
            
        }
        
        
    }
}

struct SearchBarView: View {
    @Binding var searchText: String
    @EnvironmentObject var AppState: AppState
   
    
    
    var body: some View {
        GeometryReader{   geometry in
            VStack{
                ZStack{
                    HStack {
                        
                        Spacer()
                            .frame(maxWidth: geometry.size.width * 0.17)
                        Text(searchText.isEmpty ? "Search \(AppState.SelectedView)..." : "")
                            .foregroundColor(.white.opacity(0.8))
                            .opacity(searchText.isEmpty ? 1 : 0)
                        
                        
                        Spacer()
                        
                        
                        
                    }
                    .padding(.bottom, UIScreen.main.bounds.height * 0.017)
                
                    HStack {
                        /*  Menu {
                         Button("All-Time") { selectedYear = nil }
                         ForEach(allYears, id: \.self) { year in
                         Button("\(year)") { selectedYear = year }
                         }
                         } label: {
                         Text(selectedYear != nil ? "\(selectedYear!)" : "All-Time")
                         .foregroundColor(.white)
                         .font(.system(size: 16, weight: .medium, design: .serif))
                         .padding(8)
                         .background(Color.gray.opacity(0.2))
                         .cornerRadius(8)
                         } */
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.8))
                        
                        TextField( " ", text: $searchText)
                            .foregroundColor(.white)
                        
                        Button(action: {
                            searchText = ""
                            AppState.SelectedOption = .Search
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .onChange(of: searchText) {
                            AppState.SelectedOption = .Search
                        }
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.05)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(10)
                    
                    .padding(.bottom)
                }
                .padding(.bottom)
                ZStack(alignment: .bottom){
                    
                    HStack(spacing: 0) {
                        
                        HStack{
                            Spacer()
                            Button {
                                withAnimation{
                                    AppState.SelectedOption = .Favorites
                                }
                            } label: {
                                Text("Favourites")
                                    .font(.system(size: 16, weight: .bold, design: .default))
                                    .foregroundColor(AppState.SelectedOption == .Favorites ? .white : .white.opacity(0.7))
                                
                            }
                            Spacer()
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        Divider()
                            .frame(width: 1, height: UIScreen.main.bounds.height * 0.03)
                            .background(Color.white.opacity(0.3))
                        HStack{
                            Button {
                                withAnimation{
                                    AppState.SelectedOption = .Search
                                }
                            } label: {
                                Text("Search")
                                    .font(.system(size: 16, weight: .bold, design: .default))
                                    .foregroundColor(AppState.SelectedOption == .Search ? .white : .white.opacity(0.7))
                                
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        Divider()
                            .frame(width: 1, height: UIScreen.main.bounds.height * 0.03)
                            .background(Color.white.opacity(0.3))
                        HStack {
                            Spacer()
                            
                            Button {
                                withAnimation {
                                    AppState.SelectedOption = .History
                                }
                            } label: {
                                Text("Verlauf")
                                    .font(.system(size: 16, weight: .bold, design: .default))
                                    .foregroundColor(AppState.SelectedOption == .History ? .white : .white.opacity(0.7))
                                
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        
                        
                    }
                    .frame(width: geometry.size.width * 0.9, height: UIScreen.main.bounds.height * 0.06)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                    
                    
                    
                    Rectangle()
                        .frame(width: geometry.size.width * 0.26, height: UIScreen.main.bounds.height * 0.045)
                        .foregroundStyle(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.bottom, UIScreen.main.bounds.height * 0.008)
                        .offset(x: (AppState.SelectedOption == .Favorites) ? -geometry.size.width * 0.3 :
                                    (AppState.SelectedOption == .Search) ? 0.3 :
                                    (AppState.SelectedOption == .History) ? geometry.size.width * 0.3 : 0)
                        .animation(.easeInOut, value: AppState.SelectedOption)
                    
                    
                    
                    
                
                    
                }
                VStack{
                    if AppState.SelectedOption == .Favorites {
                        ForEach(AppState.ShowFavorite(topic: AppState.SelectedView), id: \.self) { i in
                            HStack{
                                Spacer()
                                    .frame(width: geometry.size.width * 0.06)
                                Button{
                                    searchText = i
                                    AppState.SelectedOption = .Search
                                }label:{
                                    Text(i)
                                        .foregroundStyle(Color.white)
                                        .font(.system(size: 20, weight: .medium, design: .default))
                                }
                               
                                Spacer()
                                Button{
                                    
                                    if AppState.ShowFavorite(topic: AppState.SelectedView).contains(i) {
                                        AppState.removeFavorite(value: i, topic: AppState.SelectedView)
                                    } else {
                                        AppState.addFavorite(value: i, topic: AppState.SelectedView)
                                    }
                                }
                            label:
                                {
                                    Image(systemName:
                                            AppState.ShowFavorite(topic: AppState.SelectedView).contains(i)
                                          ? "star.fill"
                                          : "star"
                                    )
                                    .foregroundColor(
                                        AppState.ShowFavorite(topic: AppState.SelectedView).contains(i)
                                        ? .yellow
                                        : .white.opacity(0.8)
                                    )
                                }
                                Spacer()
                                    .frame(width: geometry.size.width * 0.06)
                            }
                        }
                    } else if AppState.SelectedOption == .Search{
                        Spacer().frame(height: geometry.size.height * 0.5)
                        Text("")
                            .onAppear(){
                                print("dsdsds")
                            }
                    } else {
                        ForEach(AppState.ShowHistory(topic: AppState.SelectedView), id: \.self) { i in
                            HStack{
                                Spacer()
                                    .frame(width: geometry.size.width * 0.06)
                                Button{
                                    searchText = i
                                    AppState.SelectedOption = .Search

                                }label:{
                                    Text(i)
                                        .foregroundStyle(Color.white)
                                        .font(.system(size: 20, weight: .medium, design: .default))
                                }

                                Spacer()
                                Button{
                                    
                                    if AppState.ShowFavorite(topic: AppState.SelectedView).contains(i) {
                                        AppState.removeFavorite(value: i, topic: AppState.SelectedView)
                                    } else {
                                        AppState.addFavorite(value: i, topic: AppState.SelectedView)
                                    }
                                }
                            label:
                                {
                                    Image(systemName:
                                        AppState.ShowFavorite(topic: AppState.SelectedView).contains(i)
                                            ? "star.fill"
                                            : "star"
                                    )
                                        .foregroundColor(
                                        AppState.ShowFavorite(topic: AppState.SelectedView).contains(i)
                                            ? .yellow
                                            : .white.opacity(0.8)
                                    )

                                }
                                Spacer()
                                    .frame(width: geometry.size.width * 0.05)

                                Button{ AppState.removeHistory(value: i, topic: AppState.SelectedView)}
                            label:
                                {
                                    Image(systemName:"trash")
                                        .foregroundColor(.white.opacity(0.8))
                                    
                                }
                                Spacer()
                                    .frame(width: geometry.size.width * 0.06)
                            }
                        }
                    }
                }
                .padding(.top, geometry.size.height * 0.1)
                
            }
            .onAppear() {
                AppState.SelectedOption = .Search
            }
        }

    }
}


    struct DriverRowView: View {
        
        let driver: Driver
        let selectedYear: Int?
        @EnvironmentObject var AppState: AppState
      
        

        
        func idk(){
            print("idk")
        }
        
        
        
        
        var body: some View {
            ZStack (alignment: .leading){
                    VStack(alignment: .leading){
                        VStack(spacing: 0){
                            ZStack{
                                Image(driver.teamimage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.25)
                                    .opacity(0.2)
                                HStack{
                                    Image(driver.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.25)
                                }
                            }
                            

                            
                            
                            HStack {
                                Text("#\(driver.number)")
                                    .font(.system(size: 20, weight: .bold, design: .serif))
                                    .foregroundStyle(.white)
                                    .padding(3)
                                    .foregroundStyle(.white)
                                    .background(AppState.PrimaryColor.color)
                                    .cornerRadius(10)
                                    .padding(.leading, 24)
                                    .padding(.trailing, 5)
                                
                                Text(driver.name)
                                    .font(.system(size: 26, weight: .bold, design: .serif))
                                    .foregroundStyle(.white)
                                Spacer()
                            }
                            .padding(.top, 22)
                            .background(Color( hex: "#1F2937"))
                            //.padding(.top, 10)
                            
                            
                            
                            HStack {
                                Text(driver.currentTeam)
                                    .font(.system(size: 24, weight: .bold, design: .serif))


                                    .foregroundStyle(Color( hex: "#D1D5DA"))
                                    .padding(.leading, 24)
                                Spacer()
                            }
                            .padding(.top, 10)
                            .background(Color( hex: "#1F2937"))
                            
                            
                            
                            HStack {
                                Text(driver.country)
                                    .font(.system(size: 20, weight: .bold, design: .serif))

                                    .foregroundStyle(Color( hex: "#9BA3AF"))
                                    .padding(.leading, 24)
                                
                                Spacer()
                            }
                            .padding(.top, 10)
                            .background(Color( hex: "#1F2937"))
                            
                            HStack{
                                Text("Points: ")
                                    .font(.system(size: 20, weight: .bold, design: .serif))

                                    .foregroundStyle(Color( hex: "#98A0AC"))
                                    .bold()
                                
                                Spacer()
                                Text("\(driver.totalPoints)")
                                    .font(.system(size: 20, weight: .bold, design: .serif))

                                    .foregroundStyle(AppState.PrimaryColor.color)
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
                            // 🏆 Wins
                            VStack {
                                Text(
                                    "\( selectedYear != nil ? (driver.seasons.first(where: { $0.year == selectedYear! })?.wins ?? 0) : driver.totalWins )"
                                )
                                .font(.system(size: 22, weight: .bold, design: .serif))


                                .foregroundStyle(Color.white)
                                .padding(.bottom, 0.1)
                                Text("Wins")
                                    .font(.system(size: 14, weight: .bold, design: .serif))


                                    .foregroundStyle(Color(hex: "#7B818C"))
                            }
                            .frame(maxWidth: .infinity)

                            // 🥈 Podiums
                            VStack {
                                Text(
                                    "\( selectedYear != nil ? (driver.seasons.first(where: { $0.year == selectedYear! })?.podiums ?? 0): driver.totalPodiums )"
                                )
                                .font(.system(size: 22, weight: .bold, design: .serif))

                                .foregroundStyle(Color.white)
                                .padding(.bottom, 0.1)
                                Text("Podiums")
                                    .font(.system(size: 14, weight: .bold, design: .serif))

                                    .foregroundStyle(Color(hex: "#7B818C"))
                            }
                            .frame(maxWidth: .infinity)

                            // 🏁 Poles
                            VStack {
                                Text(
                                    "\(selectedYear != nil ? (driver.seasons.first(where: { $0.year == selectedYear! })?.poles ?? 0) : driver.totalPoles )"
                                )
                                .font(.system(size: 22, weight: .bold, design: .serif))

                                .foregroundStyle(Color.white)
                                .padding(.bottom, 0.1)
                                Text("Poles")
                                    .font(.system(size: 14, weight: .bold, design: .serif))


                                    .foregroundStyle(Color(hex: "#7B818C"))
                            }
                            .frame(maxWidth: .infinity)

                            // ⚡ Fast Laps
                            VStack {
                                Text(
                                    "\(selectedYear != nil ? (driver.seasons.first(where: { $0.year == selectedYear! })?.fastestLaps ?? 0) : driver.totalFastestLaps)"
                                )
                                .font(.system(size: 22, weight: .bold, design: .serif))

                                .foregroundStyle(Color.white)
                                .padding(.bottom, 0.1)
                                Text("Fast Laps")
                                    .font(.system(size: 14, weight: .bold, design: .serif))

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
                                    .font(.system(size: 14, weight: .bold, design: .serif))

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
    




struct DriverDetailView: View {
    let driver: Driver

    @EnvironmentObject private var AppState: AppState

    @State private var selectedSeasonIndex = 0

    var seasonOptions: [String] {
        ["All-Time"] + driver.seasons.map { String($0.year) }
    }

    var body: some View {
        ZStack{
            Color(hex: "#101625")
                .ignoresSafeArea()

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
}





struct NothingHereView: View {
    var body: some View {
        VStack(spacing: 0) {
                    Image("totemSpirit")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.3)
                      

                    Text("Ups. Nothing Here.")
                        .font(.headline)
                        .foregroundColor(.gray)

            
            
                    Spacer()
                        .frame(height: UIScreen.main.bounds.height * 0.3)
                        .background(Color.red)

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
             
        }
    
}

#Preview {
    ContentView()
        .environmentObject(AppState())
        
}
