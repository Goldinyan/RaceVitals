//
//  Driver 2.swift
//  F1 Check-Up v3
//
//  Created by Ansgar Seifert on 04.07.25.
//
    

import Foundation

public struct Coach: Codable {
    public let name: String
    public let yearsActive: ClosedRange<Int>
    public let image: String
    public let bio: String
    public let races: Int
    public let podiums: Int
    public let wins: Int
    
    
    
    public init(name: String, yearsActive: ClosedRange<Int>, image: String, bio: String, races: Int, podiums: Int, wins: Int) {
        self.name = name
        self.yearsActive = yearsActive
        self.image = image
        self.bio = bio
        self.races = races
        self.podiums = podiums
        self.wins = wins
    }
}

public struct Liveries: Codable {
    public let year: Int
    public let name: String
    public let image: String
    public let reason: String
    
    public init(year: Int, name: String, image: String, reason: String) {
        self.year = year
        self.name = name
        self.image = image
        self.reason = reason
    }
}
public struct Team: Identifiable, Codable {
    public let id: UUID
    public var name: String
    public var image: String
    public var location: String
    public var currentCoach: Coach
    public var oldCoaches: [Coach]
    public var currentLivery: [Liveries]
    public var oldLiveries: [Liveries]
    public var specialLiveries: [Liveries] = []
    public var totalPoints: Int {
        allDrivers.flatMap { driver in
            driver.seasons.filter { $0.team.contains(self.name) }
        }
        .map { $0.points }
        .reduce(0, +)
    }
    public var totalRaces: Int {
        allDrivers.flatMap { driver in
            driver.seasons.filter { $0.team.contains(self.name) }
        }
        .map { $0.races}
        .reduce(0, +)
    }
    public var totalWins: Int {
        allDrivers.flatMap { driver in
            driver.seasons.filter { $0.team.contains(self.name) }
        }
        .map{ $0.wins}
        .reduce(0, +)
    }
    
    public var totalPodiums: Int {
        allDrivers.flatMap { driver in
            driver.seasons.filter { $0.team.contains(self.name) }
        }
        .map{ $0.podiums}
        .reduce(0, +)
    }
    public var totalPoles: Int {
        allDrivers.flatMap { driver in
            driver.seasons.filter { $0.team.contains(self.name) }
        }
        .map{ $0.poles}
        .reduce(0, +)
    }
    public var currentDrivers: [Driver] {
        allDrivers.filter { $0.currentTeam == self.name }
    }
    public var oldDriver: [Driver] {
        allDrivers.filter { $0.pastTeams.contains(self.name) }
    }
    
    
    func WinsSeasonTeam(for year: Int?) -> Int {
        let filteredSeasons = allDrivers.flatMap { $0.seasons }
            .filter { $0.team.contains(self.name) && (year == nil || $0.year == year!) }
        return filteredSeasons.map { $0.wins }.reduce(0, +)
    }
    func RacesSeasonTeam(for year: Int?) -> Int {
        let filteredSeasons = allDrivers.flatMap { $0.seasons }
            .filter { $0.team.contains(self.name) && (year == nil || $0.year == year!) }
        return filteredSeasons.map { $0.races }.reduce(0, +)
    }

    func PodiumsSeasonTeam(for year: Int?) -> Int {
        let filteredSeasons = allDrivers.flatMap { $0.seasons }
            .filter { $0.team.contains(self.name) && (year == nil || $0.year == year!) }
        return filteredSeasons.map { $0.podiums }.reduce(0, +)
    }
    func PolesSeasonTeam(for year: Int?) -> Int {
        let filteredSeasons = allDrivers.flatMap { $0.seasons }
            .filter { $0.team.contains(self.name) && (year == nil || $0.year == year!) }
        return filteredSeasons.map { $0.poles }.reduce(0, +)
    }
    func FastestLapsSeasonTeam(for year: Int?) -> Int {
        let filteredSeasons = allDrivers.flatMap { $0.seasons }
            .filter { $0.team.contains(self.name) && (year == nil || $0.year == year!) }
        return filteredSeasons.map { $0.fastestLaps }.reduce(0, +)
    }

    

    
    
    public init(id: UUID = UUID(), name: String, image: String,location: String, currentCoach: Coach, oldCoaches: [Coach] = [], currentLivery: [Liveries], oldLiveries: [Liveries] , specialLiveries: [Liveries]) {
        self.id = id
        self.name = name
        self.image = image
        self.location = location
        self.currentCoach = currentCoach
        self.oldCoaches = oldCoaches
        self.currentLivery = currentLivery
        self.oldLiveries = oldLiveries
        self.specialLiveries = specialLiveries
    }
}



let allTeams: [Team] = [
    Team(
        name: "Mercedes",
        image: "mercedes.team",
        location: "Brackley, England",
        currentCoach:
            Coach(name: "Toto Wolff", yearsActive: 2013...2025, image: "wolff.img", bio: "CEO und Teamchef seit 2013, Architekt der Hybrid-Ära", races: 250, podiums: 180, wins: 115)
        ,
        oldCoaches: [
            Coach(name: "Ross Brawn", yearsActive: 2010...2012, image: "brawn.img", bio: "Technikgenie und Gründer von Brawn GP", races: 58, podiums: 23, wins: 12),
            Coach(name: "Norbert Haug", yearsActive: 1998...2008, image: "haug.img", bio: "Langjähriger Motorsportchef bei Mercedes", races: 162, podiums: 45, wins: 18)
        ],
        currentLivery: [
            Liveries(year: 2025, name: "Black-Silver with Teal Accents", image: "mercedes.2025", reason: "Modernisierte Optik für neue Fahrerpaarung")
        ],
        oldLiveries: [
            Liveries(year: 2010, name: "Silver Arrow", image: "mercedes.2010", reason: "Traditionelles Mercedes-Design"),
            Liveries(year: 2020, name: "Black Panther", image: "mercedes.2020", reason: "Diversity-Initiative"),
            Liveries(year: 2022, name: "Silver-Black Hybrid", image: "mercedes.2022", reason: "Rückkehr zur silbernen Basis mit modernen Akzenten")
        ],
        specialLiveries: [
            Liveries(year: 2020, name: "End Racism", image: "mercedes.endracism", reason: "Solidarität mit Vielfalt und Inklusion"),
            Liveries(year: 2025, name: "F1 75 Live Edition", image: "mercedes.f175live", reason: "Feier des 75-jährigen F1-Jubiläums")
        ]
    ),
    Team(
        name: "Red Bull Racing",
        image: "redbull.team",
        location: "Milton Keynes, England",
        currentCoach:
            Coach(name: "Laurent Mekies", yearsActive: 2025...2025, image: "mekies.img", bio: "Nachfolger von Horner, zuvor bei Ferrari und FIA", races: 12, podiums: 6, wins: 2)
        ,
        oldCoaches: [
            Coach(name: "Christian Horner", yearsActive: 2005...2025, image: "horner.img", bio: "Langjähriger Teamchef mit 6 Konstrukteurs- und 8 Fahrertiteln", races: 405, podiums: 196, wins: 124)
        ],
        currentLivery: [
            Liveries(year: 2025, name: "Dark Blue with Red and Yellow Bull", image: "redbull.2025", reason: "Klassisches Red-Bull-Design mit modernem Touch")
        ],
        oldLiveries: [
            Liveries(year: 2005, name: "Classic Bull", image: "redbull.2005", reason: "Erstes Red-Bull-F1-Design"),
            Liveries(year: 2015, name: "Camo Bull", image: "redbull.2015", reason: "Test-Livery zur Tarnung technischer Details"),
            Liveries(year: 2023, name: "Championship Edition", image: "redbull.2023", reason: "Feier der Titel mit Verstappen")
        ],
        specialLiveries: [
            Liveries(year: 2023, name: "Las Vegas Fan Design", image: "redbull.vegas2023", reason: "Fan-Design für das Las Vegas GP"),
            Liveries(year: 2025, name: "Honda Tribute", image: "redbull.honda2025", reason: "Ehrung der Honda-Partnerschaft beim Japan GP")
        ]
    ),
    Team(
        name: "Ferrari",
        image: "ferrari.team",
        location: "Maranello, Italien",
        currentCoach:
            Coach(name: "Frédéric Vasseur", yearsActive: 2023...2025, image: "vasseur.img", bio: "Erfahrener Teamchef, zuvor bei Alfa Romeo und Renault", races: 65, podiums: 22, wins: 5)
        ,
        oldCoaches: [
            Coach(name: "Mattia Binotto", yearsActive: 2019...2022, image: "binotto.img", bio: "Technischer Leiter und später Teamchef", races: 80, podiums: 45, wins: 7),
            Coach(name: "Maurizio Arrivabene", yearsActive: 2015...2018, image: "arrivabene.img", bio: "Marketing-Experte mit Fokus auf Stabilität", races: 81, podiums: 55, wins: 11),
            Coach(name: "Stefano Domenicali", yearsActive: 2008...2014, image: "domenicali.img", bio: "Letzter Ferrari-Teamchef mit Konstrukteurstitel", races: 132, podiums: 78, wins: 20)
        ],
        currentLivery: [
            Liveries(year: 2025, name: "Deep Rosso Corsa with White Accents", image: "ferrari.2025", reason: "Neues Design für Hamiltons Einstieg")
        ],
        oldLiveries: [
            Liveries(year: 2000, name: "Classic Red", image: "ferrari.2000", reason: "Schumacher-Ära"),
            Liveries(year: 2018, name: "Matte Red", image: "ferrari.2018", reason: "Modernisierung der Lackierung"),
            Liveries(year: 2023, name: "HP Edition", image: "ferrari.2023", reason: "Partnerschaft mit HP")
        ],
        specialLiveries: [
            Liveries(year: 2022, name: "Monza Yellow Tribute", image: "ferrari.monza2022", reason: "75 Jahre Ferrari"),
            Liveries(year: 2025, name: "SF-25 Reveal", image: "ferrari.sf25", reason: "Präsentation des neuen Autos mit Hamilton")
        ]
    )
]



public struct Driver: Identifiable, Codable {
    public let id: UUID
    public var name: String
    public var number: Int
    public var country: String
    public var image: String
    public var birthdateTimestamp: Double
    public var birthPlace: String
    public var nickname: String?
    public var quote: String
    // Persönliches
    public var bestRaces: [String]
    public var curiosities: [String]
    public var family: [String]
    
    // Karriere & Leistungen
    public var summary: String
    public var careerHighlights: [String]
    public var technicalStrengths: [String]
    public var weaknesses: [String]
    public var teamRoles: [String]
    
    // Statistiken & Technik
    public var drivingStyle: String
    public var specialAwards: [String]
    public var favoriteCars: [String]
    public var sponsors: [String]
    
    // Persönlichkeit
    public var hobbies: [String]
    public var characterTraits: [String]
    public var mediaPresence: [String]

    public var currentTeam: String
    public var pastTeams: [String]
    public var seasons: [DriverSeasonStats]
    public var careerstats: [DriverCareerStats]

    public var birthdate: Date {
        get { Date(timeIntervalSince1970: birthdateTimestamp) }
        set { birthdateTimestamp = newValue.timeIntervalSince1970 }
    }

    public var age: Int {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year], from: birthdate, to: now)
        return components.year ?? 0
    }

    // Berechnete Eigenschaften aus seasons
    public var totalPoints: Int {
        seasons.reduce(0) { $0 + $1.points }
    }
    public var totalPodiums: Int {
        seasons.reduce(0) { $0 + $1.podiums }
    }
    public var totalWins: Int {
        seasons.reduce(0) { $0 + $1.wins }
    }
    public var totalPenaltyPoints: Int {
        seasons.reduce(0) { $0 + $1.penaltyPoints }
    }
    public var totalPoles: Int {
        seasons.reduce(0) { $0 + $1.poles }
    }
    public var totalFastestLaps: Int {
        seasons.reduce(0) { $0 + $1.poles }
    }
    public var totalRaces: Int {
        seasons.reduce(0) { $0 + $1.races }
    }

    public var teamLogoName: String {
        switch currentTeam {
        case "Mercedes": return "mercedes_logo"
        case "Ferrari": return "ferrari_logo"
        case "Red Bull Racing": return "redbull_logo"
        case "McLaren": return "mclaren_logo"
        case "Alpine": return "alpine_logo"
        case "Aston Martin": return "astonmartin_logo"
        case "AlphaTauri": return "alphatauri_logo"
        case "Alfa Romeo": return "alfaromeo_logo"
        case "Haas": return "haas_logo"
        case "Williams": return "williams_logo"
        default: return "default_logo"
        }
    }

    public init(
        id: UUID = UUID(),
        name: String,
        number: Int,
        country: String,
        image: String,
        birthdate: Date,
        birthPlace: String,
        nickname: String? = nil,
        qoute: String,
        bestRaces: [String] = [],
        curiosities: [String] = [],
        family: [String] = [],
        summary: String = "",
        careerHighlights: [String] = [],
        technicalStrengths: [String] = [],
        weaknesses: [String] = [],
        teamRoles: [String] = [],
        drivingStyle: String = "",
        specialAwards: [String] = [],
        favoriteCars: [String] = [],
        sponsors: [String] = [],
        hobbies: [String] = [],
        characterTraits: [String] = [],
        mediaPresence: [String] = [],
        currentTeam: String,
        pastTeams: [String],
        seasons: [DriverSeasonStats],
        careerstats: [DriverCareerStats]
    ) {
        self.id = id
        self.name = name
        self.number = number
        self.country = country
        self.image = image
        self.birthdateTimestamp = birthdate.timeIntervalSince1970
        self.birthPlace = birthPlace
        self.nickname = nickname
        self.quote = qoute
        self.bestRaces = bestRaces
        self.curiosities = curiosities
        self.family = family
        self.summary = summary
        self.careerHighlights = careerHighlights
        self.technicalStrengths = technicalStrengths
        self.weaknesses = weaknesses
        self.teamRoles = teamRoles
        self.drivingStyle = drivingStyle
        self.specialAwards = specialAwards
        self.favoriteCars = favoriteCars
        self.sponsors = sponsors
        self.hobbies = hobbies
        self.characterTraits = characterTraits
        self.mediaPresence = mediaPresence
        self.currentTeam = currentTeam
        self.pastTeams = pastTeams
        self.seasons = seasons
        self.careerstats = careerstats
    }
}

public struct DriverSeasonStats: Codable {
    public let year: Int
    public let team: String
    public let position: Int
    public let points: Int
    public let podiums: Int
    public let wins: Int
    public let poles: Int
    public let fastestLaps: Int
    public let penaltyPoints: Int
    public let races: Int

    public init(year: Int, team: String, position: Int, points: Int, podiums: Int, wins: Int, poles: Int,fastestLaps: Int, penaltyPoints: Int, races: Int) {
        self.year = year
        self.team = team
        self.position = position
        self.points = points
        self.podiums = podiums
        self.wins = wins
        self.poles = poles
        self.fastestLaps = fastestLaps
        self.penaltyPoints = penaltyPoints
        self.races = races
    }
}


public struct DriverCareerStats: Codable {
    public var gpentered: Int
    public var carrerpoints: Int
    public var highestracefinish: String
    public var podiums: Int
    public var poles: Int
    public var wcs: Int
    public var dnfs: Int
    
    
    public init(gpentered: Int, carrerpoints: Int, highestracefinish: String, podiums: Int,poles: Int, wcs: Int, dnfs: Int) {
        self.gpentered = gpentered
        self.carrerpoints = carrerpoints
        self.highestracefinish = highestracefinish
        self.podiums = podiums
        self.poles = poles
        self.wcs = wcs
        self.dnfs = dnfs
    }
    
    
    
}

    
    
   


let allDrivers: [Driver] = [
       Driver(
            name: "Lewis Hamilton",
            number: 44,
            country: "United Kingdom",
            image: "lewis-hamilton",
            birthdate: DateComponents(calendar: .current, year: 1985, month: 1, day: 7).date!,
            birthPlace: "Stevenage, Hertfordshire, England",
            nickname: "The Hammer",
            qoute: "DRIVING A SCUDERIA FERRARI HP CAR FOR THE FIRST TIME WAS ONE OF THE BEST FEELINGS OF MY LIFE.",
            bestRaces: [
                "Monaco GP 2019",
                "Silverstone GP 2021",
                "Abu Dhabi GP 2020"
            ],
            curiosities: [
                "Drinks green tea before every race",
                "Active in environmental and social causes",
                "Has a dog named Roscoe"
            ],
            family: [
                "Mother: Carmen Lockhart",
                "Father: Anthony Hamilton",
                "Sibling: Nicolas Hamilton"
            ],
            summary: """
            Lewis Hamilton is a seven-time Formula 1 World Champion and one of the most successful drivers in history. 
            Known for his aggressive driving style, consistency, and ability to perform under pressure. 
            Off the track, he’s committed to social and environmental issues.
            """,
            careerHighlights: [
                "First win: 2007 Canadian GP",
                "First World Championship: 2008",
                "Record holder for most pole positions"
            ],
            technicalStrengths: [
                "Exceptional qualifying pace",
                "Masterful tire management",
                "Strategic racecraft"
            ],
            weaknesses: [
                "Sometimes overly aggressive in duels",
                "Occasional struggles in tricky weather"
            ],
            teamRoles: [
                "Team leader since 2014",
                "Mentor for younger teammates"
            ],
            drivingStyle: "Aggressive and tactically savvy",
            specialAwards: [
                "Rookie of the Year 2007",
                "BBC Sports Personality of the Year 2014, 2020"
            ],
            favoriteCars: [
                "Mercedes W11",
                "McLaren MP4-23"
            ],
            sponsors: [
                "Petronas",
                "Tommy Hilfiger",
                "Monster Energy"
            ],
            hobbies: [
                "Music production",
                "Fitness",
                "Animal welfare activism"
            ],
            characterTraits: [
                "Ambitious",
                "Team-oriented",
                "Communicative"
            ],
            mediaPresence: [
                "@lewishamilton (Instagram)",
                "@LewisHamilton (Twitter)",
                "Regular interviews and documentaries"
            ],
            currentTeam:"Ferrari",
            pastTeams: ["McLaren", "Mercedes"],
            seasons: [
                  DriverSeasonStats(year: 2007, team: "McLaren", position: 2, points: 109, podiums: 12, wins: 4, poles: 6, fastestLaps: 2, penaltyPoints: 1, races: 17),
                  DriverSeasonStats(year: 2008, team: "McLaren", position: 1, points: 98, podiums: 10, wins: 5, poles: 7, fastestLaps: 1, penaltyPoints: 0, races: 18),
                  DriverSeasonStats(year: 2009, team: "McLaren", position: 5, points: 49, podiums: 5, wins: 2, poles: 4, fastestLaps: 0, penaltyPoints: 0, races: 17),
                  DriverSeasonStats(year: 2010, team: "McLaren", position: 4, points: 240, podiums: 9, wins: 3, poles: 1, fastestLaps: 5, penaltyPoints: 0, races: 19),
                  DriverSeasonStats(year: 2011, team: "McLaren", position: 5, points: 227, podiums: 6, wins: 3, poles: 1, fastestLaps: 3, penaltyPoints: 0, races: 19),
                  DriverSeasonStats(year: 2012, team: "McLaren", position: 4, points: 190, podiums: 7, wins: 4, poles: 7, fastestLaps: 1, penaltyPoints: 5, races: 20),
                  DriverSeasonStats(year: 2013, team: "Mercedes", position: 4, points: 189, podiums: 5, wins: 1, poles: 5, fastestLaps: 1, penaltyPoints: 1, races: 19),
                  DriverSeasonStats(year: 2014, team: "Mercedes", position: 1, points: 384, podiums: 16, wins: 11, poles: 7, fastestLaps: 7, penaltyPoints: 3, races: 19),
                  DriverSeasonStats(year: 2015, team: "Mercedes", position: 1, points: 381, podiums: 17, wins: 10, poles: 11, fastestLaps: 8, penaltyPoints: 1, races: 19),
                  DriverSeasonStats(year: 2016, team: "Mercedes", position: 2, points: 380, podiums: 17, wins: 10, poles: 12, fastestLaps: 3, penaltyPoints: 2, races: 21),
                  DriverSeasonStats(year: 2017, team: "Mercedes", position: 1, points: 363, podiums: 13, wins: 9, poles: 11, fastestLaps: 7, penaltyPoints: 0, races: 20),
                  DriverSeasonStats(year: 2018, team: "Mercedes", position: 1, points: 408, podiums: 17, wins: 11, poles: 11, fastestLaps: 3, penaltyPoints: 1, races: 21),
                  DriverSeasonStats(year: 2019, team: "Mercedes", position: 1, points: 413, podiums: 17, wins: 11, poles: 5, fastestLaps: 6, penaltyPoints: 0, races: 21),
                  DriverSeasonStats(year: 2020, team: "Mercedes", position: 1, points: 347, podiums: 14, wins: 11, poles: 10, fastestLaps: 6, penaltyPoints: 0, races: 17),
                  DriverSeasonStats(year: 2021, team: "Mercedes", position: 2, points: 387, podiums: 17, wins: 8, poles: 5, fastestLaps: 6, penaltyPoints: 2, races: 22),
                  DriverSeasonStats(year: 2022, team: "Mercedes", position: 6, points: 240, podiums: 9, wins: 0, poles: 0, fastestLaps: 2, penaltyPoints: 1, races: 22),
                  DriverSeasonStats(year: 2023, team: "Mercedes", position: 3, points: 234, podiums: 6, wins: 0, poles: 1, fastestLaps: 4, penaltyPoints: 1, races: 22),
                  DriverSeasonStats(year: 2024, team: "Mercedes", position: 7, points: 223, podiums: 5, wins: 2, poles: 0, fastestLaps: 1, penaltyPoints: 0, races: 24)
                ],




            careerstats: [
                DriverCareerStats(gpentered: 368, carrerpoints: 4965, highestracefinish: "1 (x105)", podiums: 202, poles: 104, wcs: 7, dnfs: 32)
            ]
            
        ),
        Driver(
          name: "Max Verstappen",
          number: 1,
          country: "Netherlands",
          image: "max-verstappen",
          birthdate: DateComponents(calendar: .current, year: 1997, month: 9, day: 30).date!,
          birthPlace: "Hasselt, Belgium",
          nickname: "The Dutch Lion",
          qoute: "I HATE LOSING!",
          bestRaces: [
            "São Paulo GP 2023",
            "Monaco GP 2021",
            "Austrian GP 2024"
          ],
          curiosities: [
            "Youngest ever F1 race winner (18 y 228 d)",
            "Also active in sim-racing (iRacing champion)"
          ],
          family: [
            "Father: Jos Verstappen (former F1 driver)",
            "Mother: Sophie Kumpen",
            "Sister: Victoria Verstappen"
          ],
          summary: """
        He’s Max by name, and max by nature.

        Arriving as Formula 1’s youngest ever competitor at just 17 years old, Verstappen pushed his car, his rivals and the sport’s record books to the limit. The baby-faced Dutchman with the heart of a lion took the Toro Rosso – and then the Red Bull – by the horns with his instinctive racing style.

        F1’s youngest points scorer soon became its youngest race winner – at the age of 18 years and 228 days – with an opportunistic but controlled drive on debut for Red Bull in Barcelona 2016. A true wheel-to-wheel racer, another stunning drive in Brazil from the back of the pack to the podium on a treacherous wet track kept the plaudits coming.

        Verstappen’s no-holds-barred attitude and hard defending have sometimes landed him in hot water with his peers and paymasters. But the mistakes that initially marred his potential have given way to maturity, while the bravado and energy that make him a blockbuster talent have remained – and the victories have kept on coming.

        They led to his first F1 drivers’ crown after that now legendary, final-round showdown with Lewis Hamilton in 2021 and he followed that up with a powerhouse title defence in 2022. An epic third successive championship triumph featured a record 19 wins from 23 Grands Prix, and he held on for a fourth in 2024, despite Red Bull falling off the pace towards the end of the campaign.

        The son of former F1 driver Jos Verstappen and super-quick karting Mum Sophie Kumpen, racing runs through his genes. Despite moving out of Dad’s house to live in Monaco, Verstappen remains close to his family, and though he’s not afraid to speak his mind, he can still be surprisingly shy.

        Having become the Netherlands' first world champion aged just 24, the expectations for the new generation’s leading light are sky high – but with Verstappen there’s a feeling that the sky’s the limit.
        """,
          careerHighlights: [
            "First win: 2016 Spanish GP (Red Bull debut)",
            "Championship wins: 2021, 2022, 2023, 2024",
            "Most wins in a season (19 in 2022)"
          ],
          technicalStrengths: [
            "Fearless wet-weather driving",
            "Impeccable race pace management",
            "Perfect qualifying performance"
          ],
          weaknesses: [
            "Occasionally overaggressive under pressure",
            "Shares tense rivalry with Russell/Hamilton"
          ],
          teamRoles: [
            "Team leader since 2021",
            "Mentor within Red Bull junior programme"
          ],
          drivingStyle: "Aggressive, calculated, confident in duels",
          specialAwards: [
            "Time 100 Most Influential (2024)",
            "Officer of the Order of Orange‑Nassau (2022)"
          ],
          favoriteCars: [
            "Red Bull RB20",
            "Verstappen.com Racing GT3 Aston Martin"
          ],
          sponsors: [
            "Red Bull",
            "Mobil 1",
            "TAG Heuer"
          ],
          hobbies: [
            "Sim‑racing",
            "GT endurance racing",
            "Fitness training"
          ],
          characterTraits: [
            "Driven",
            "Focused",
            "Private off-track"
          ],
          mediaPresence: [
            "@Max33Verstappen (Twitter)",
            "@maxverstappen1 (Instagram)",
            "Regular astute race insights in interviews"
          ],
          currentTeam: "Red Bull Racing",
          pastTeams: ["Toro Rosso"],
          seasons: [
            DriverSeasonStats(year: 2015, team: "Toro Rosso", position: 12, points: 49, podiums: 0, wins: 0, poles: 0, fastestLaps: 0, penaltyPoints: 1, races: 19),
            DriverSeasonStats(year: 2016, team: "Toro Rosso / Red Bull", position: 5, points: 204, podiums: 7, wins: 1, poles: 0, fastestLaps: 1, penaltyPoints: 2, races: 21),
            DriverSeasonStats(year: 2017, team: "Red Bull Racing", position: 6, points: 168, podiums: 4, wins: 2, poles: 0, fastestLaps: 1, penaltyPoints: 3, races: 20),
            DriverSeasonStats(year: 2018, team: "Red Bull Racing", position: 4, points: 249, podiums: 11, wins: 2, poles: 0, fastestLaps: 2, penaltyPoints: 1, races: 21),
            DriverSeasonStats(year: 2019, team: "Red Bull Racing", position: 3, points: 278, podiums: 9, wins: 3, poles: 2, fastestLaps: 3, penaltyPoints: 2, races: 21),
            DriverSeasonStats(year: 2020, team: "Red Bull Racing", position: 3, points: 214, podiums: 11, wins: 2, poles: 1, fastestLaps: 3, penaltyPoints: 0, races: 17),
            DriverSeasonStats(year: 2021, team: "Red Bull Racing", position: 1, points: 396, podiums: 18, wins: 10, poles: 10, fastestLaps: 6, penaltyPoints: 2, races: 22),
            DriverSeasonStats(year: 2022, team: "Red Bull Racing", position: 1, points: 454, podiums: 17, wins: 15, poles: 7, fastestLaps: 5, penaltyPoints: 3, races: 22),
            DriverSeasonStats(year: 2023, team: "Red Bull Racing", position: 1, points: 575, podiums: 21, wins: 19, poles: 12, fastestLaps: 9, penaltyPoints: 2, races: 22),
            DriverSeasonStats(year: 2024, team: "Red Bull Racing", position: 1, points: 437, podiums: 14, wins: 9, poles: 8, fastestLaps: 3, penaltyPoints: 1, races: 24)
          ],



          careerstats: [
            DriverCareerStats(gpentered: 221, carrerpoints: 3318, highestracefinish: "1 (x65)", podiums: 117, poles: 44, wcs: 4, dnfs: 33)
          ]
        ),
        Driver(
          name: "Charles Leclerc",
          number: 16,
          country: "Monaco",
          image: "charles-leclerc",
          birthdate: DateComponents(calendar: .current, year: 1997, month: 10, day: 16).date!,
          birthPlace: "Monte Carlo, Monaco",
          nickname: "Il Predestinato",
          qoute: "WHATEVER THE POSITION IS AT STAKE, YOU'VE GOT TO DO YOUR ABSOLUTE BEST AS A DRIVER WHETHER YOU'RE FIGHTING FOR THE FIFTH, FOURTH OR FIRST POSITION.",
          bestRaces: [
            "Monaco GP 2024",
            "Italian GP 2024",
            "United States GP 2024"
          ],
          curiosities: [
            "First Monegasque to win Monaco GP since 1931",
            "Sworn in press after Mexico GP, fined €10 k"
          ],
          family: [
            "Father: Hervé Leclerc",
            "Mother: Pascale Leclerc",
            "Brother: Arthur Leclerc (F2 driver)"
          ],
          summary: """
        Charles Leclerc is a multi‑race winner and Ferrari’s lead driver, known for his pure speed and flair under pressure. His 2024 season saw career‑best consistency and his first home win at Monaco. He’s widely respected for on‑track bravery and off‑track charm.
        """,
          careerHighlights: [
            "Monaco GP 2024 – home victory from pole",
            "Italian GP 2024 – strategic one‑stop win",
            "Multiple podiums and poles in 2024"
          ],
          technicalStrengths: [
            "Pole‑to‑win performance in qualifying",
            "Expert tyre and strategy execution"
          ],
          weaknesses: [
            "Occasional technical issues (e.g. battery swap)",
            "Grid penalties due to component changes"
          ],
          teamRoles: [
            "Ferrari’s lead driver since 2019",
            "Mentor for junior Ferrari talent"
          ],
          drivingStyle: "Calculated aggression with street‑circuit prowess",
          specialAwards: [
            "Pole‑to‑win in Monaco (2024)",
            "Multiple Pole Positions in 2024"
          ],
          favoriteCars: [
            "Ferrari SF‑24",
            "Ferrari F1‑75"
          ],
          sponsors: [
            "Richard Mille",
            "Puma",
            "Shell"
          ],
          hobbies: [
            "Go‑kart racing",
            "Sim‑racing"
          ],
          characterTraits: [
            "Focused",
            "Resilient",
            "Media‑savvy"
          ],
          mediaPresence: [
            "@Charles_Leclerc (Instagram)",
            "@Charles_Leclerc (Twitter)",
            "Often featured in F1 press conferences"
          ],
          currentTeam: "Ferrari",
          pastTeams: ["Sauber"],
          seasons: [
            DriverSeasonStats(year: 2018, team: "Sauber", position: 13, points: 39, podiums: 0, wins: 0, poles: 0, fastestLaps: 0, penaltyPoints: 0, races: 21),
            DriverSeasonStats(year: 2019, team: "Ferrari", position: 4, points: 264, podiums: 10, wins: 2, poles: 7, fastestLaps: 4, penaltyPoints: 0, races: 21),
            DriverSeasonStats(year: 2020, team: "Ferrari", position: 8, points: 98, podiums: 2, wins: 0, poles: 0, fastestLaps: 0, penaltyPoints: 3, races: 17),
            DriverSeasonStats(year: 2021, team: "Ferrari", position: 7, points: 159, podiums: 1, wins: 0, poles: 2, fastestLaps: 1, penaltyPoints: 3, races: 22),
            DriverSeasonStats(year: 2022, team: "Ferrari", position: 2, points: 308, podiums: 11, wins: 3, poles: 9, fastestLaps: 5, penaltyPoints: 2, races: 22),
            DriverSeasonStats(year: 2023, team: "Ferrari", position: 5, points: 206, podiums: 6, wins: 0, poles: 5, fastestLaps: 3, penaltyPoints: 1, races: 22),
            DriverSeasonStats(year: 2024, team: "Ferrari", position: 3, points: 356, podiums: 13, wins: 3, poles: 4, fastestLaps: 4, penaltyPoints: 0, races: 24)
],


          careerstats: [
            DriverCareerStats(gpentered: 159, carrerpoints: 1549, highestracefinish: "1 (x8)", podiums: 47, poles: 26, wcs: 0, dnfs: 21,)
          ]
        ),
]






func checkAllDriversSeason() {
    for driver in allDrivers {
      
            print(driver.name)
        
    }
}



func test() {
    checkAllDriversSeason()
}
