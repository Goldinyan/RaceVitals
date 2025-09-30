//
//  Driver 2.swift
//  F1 Check-Up v3
//
//  Created by Ansgar Seifert on 04.07.25.
//
    

import Foundation
import SwiftUI

//MARK: OKAY I DONT KNOW BRO (RANDOM)                            -> LOL                        -> NEARLY THERE                         -> LECK EIER

let driverYears: [String] = Array(
    Set(allDrivers.localized["en"]? .flatMap { $0.seasons.map { $0.year } } ?? [] )
)
.sorted(by: >)
.map { String($0) }


public struct OneRaceCalendar: Codable, Identifiable {
    public let id: UUID
    public let circuit: Circuit
    public let isSprintWeekend: Bool
    public let sessions: [RaceSession]
    
    public init(id: UUID = UUID(), circuit: Circuit, isSprintWeekend: Bool, sessions: [RaceSession]) {
        self.id = id
        self.circuit = circuit
        self.isSprintWeekend = isSprintWeekend
        self.sessions = sessions
    }
}

public struct RaceSession: Codable, Identifiable {
    public let id: UUID
    public let type: SessionType
    public let start: Date
    public let end: Date
    
    public init(id: UUID = UUID(), type: SessionType, start: Date, end: Date) {
        self.id = id
        self.type = type
        self.start = start
        self.end = end
    }
}

public enum SessionType: String, Codable, CaseIterable {
    case fp1, fp2, fp3
    case qualifyingQ1, qualifyingQ2, qualifyingQ3
    case sprintShootout, sprintRace
    case race
}

public struct Option: Codable {
    let name : String
    let details : [String]
}

let Options: [Option] = [
    Option(name: "Driver", details: driverYears),
    Option(name: "Team", details: driverYears),
    Option(name: "Rules", details: ["Qualifying", "Race Procedures", "Track Limits", "Penalties", "Safety Protocols", "Technical Rules", "Tyre Regulations", "Points System", "DRS / Overtaking", "Season Limits", "Other"]),
    Option(name: "Strategies", details: ["Tyre Strategy", "Pit Stop Tactics", "Weather Strategy", "Data & Simulation", "Reactive In-Race Strategies", "Team Roles in Strategy"]),
    Option(name: "Circuits", details: ["Europe", "North America", "Asia", "South America", "Africa", "Australia"]),
    Option(name: "Records", details: ["Driver Records", "Race Records", "Team & Constructor Records", "Special Records"]),
    Option(name: "Trivia", details: ["Historic Firsts", "Driver Trivia", "Team & Tech Trivia", "Fun & Quirky Facts"]),
    Option(name: "Fan Voting", details: []),
    Option(name: "Tech", details: ["Aerodynamics", "Power Units & Hybrid Era", "Safety Innovations", "Data & Simulation", "Materials & Construction", "Performance & Handling"]),
    Option(name: "Radio Moments", details: [])
]

public struct Rules: Codable, Identifiable {
        public let id: UUID
        public let name: String
        public let image: String
        public let descriptionSmall: String
        public let description: String
        public let category: String
        public let isActive: Bool
        public let severity: Int
        public let createdAt: Date
        public let tags: [String]
        public let relatedLinks: [URL]
        public let author: String

    public init(
        id: UUID = UUID(),
        name: String,
        image: String,
        descriptionSmall: String,
        description: String,
        category: String,
        isActive: Bool = true,
        severity: Int,
        createdAt: Date = Date(),
        tags: [String] = [],
        relatedLinks: [URL] = [],
        author: String
    ) {
        self.id = id
        self.name = name
        self.image = image
        self.descriptionSmall = descriptionSmall
        self.description = description
        self.category = category
        self.isActive = isActive
        self.severity = severity
        self.createdAt = createdAt
        self.tags = tags
        self.relatedLinks = relatedLinks
        self.author = author
    }
}

public struct Strategy: Codable, Identifiable {
    public let id: UUID
    public let title: String
    public let description: String
    public let effectivenessRating: Int
    public let useCase: String
    public let image: String
    
    public init(id: UUID = UUID(), title: String, description: String, effectivenessRating: Int, useCase: String, image: String) {
        self.id = id
        self.title = title
        self.description = description
        self.effectivenessRating = effectivenessRating
        self.useCase = useCase
        self.image = image
    }
}

public struct Circuit: Codable, Identifiable {
    public let id: UUID
    public let name: String
    public let country: String
    public let lengthKm: Double
    public let turns: Int
    public let image: String
    
    public init(id: UUID = UUID(), name: String, country: String, lengthKm: Double, turns: Int, image: String) {
        self.id = id
        self.name = name
        self.country = country
        self.lengthKm = lengthKm
        self.turns = turns
        self.image = image
    }
}

public struct Record: Codable, Identifiable {
    public let id: UUID
    public let title: String
    public let holder: String
    public let value: String
    public let year: Int
    public let category: String
    
    public init(id: UUID, title: String, holder: String, value: String, year: Int, category: String) {
        self.id = id
        self.title = title
        self.holder = holder
        self.value = value
        self.year = year
        self.category = category
    }
}

public struct Trivia: Codable, Identifiable {
    public let id: UUID
    public let question: String
    public let answer: String
    public let difficulty: Int
    public let category: String
    
    public init(id: UUID, question: String, answer: String, difficulty: Int, category: String) {
        self.id = id
        self.question = question
        self.answer = answer
        self.difficulty = difficulty
        self.category = category
    }
}

public struct FanVoting: Codable, Identifiable {
    public let id: UUID
    public let topic: String
    public let options: [String]
    public let votes: [Int]
    public let isActive: Bool
    
    public init(id: UUID, topic: String, options: [String], votes: [Int], isActive: Bool) {
        self.id = id
        self.topic = topic
        self.options = options
        self.votes = votes
        self.isActive = isActive
    }
}

public struct Tech: Codable, Identifiable {
    public let id: UUID
    public let name: String
    public let description: String
    public let image: String
    public let introducedIn: Int
    public let isAllowed: Bool
    
    public init(id: UUID, name: String, description: String, image: String, introducedIn: Int, isAllowed: Bool) {
        self.id = id
        self.name = name
        self.description = description
        self.image = image
        self.introducedIn = introducedIn
        self.isAllowed = isAllowed
    }
}

public struct RadioMoment: Codable, Identifiable {
    public let id: UUID
    public let author: String
    public let quote: String
    public let year: Int
    public let emotionalLevel: Int
    public let funnyLevel: Int
    
    public init(id: UUID, author: String, quote: String, year: Int, emotionalLevel: Int, funnyLevel: Int) {
        self.id = id
        self.author = author
        self.quote = quote
        self.year = year
        self.emotionalLevel = emotionalLevel
        self.funnyLevel = funnyLevel
    }
}

// MARK: - Team

public struct Team: Identifiable, Codable {
    public let id: UUID
    public var name: String
    public var image: String
    public var location: String
    public var currentCoach: Coach
    public var oldCoaches: [Coach]
    public var currentLivery: [Livery]
    public var oldLiveries: [Livery]
    public var specialLiveries: [Livery] = []
    
    
    func totalPoints(language: String) -> Int {
            let drivers = allDrivers.localized[language] ?? []
            return drivers
                .flatMap { driver in
                    driver.seasons.filter { $0.team.contains(self.name) }
                }
                .map { $0.points }
                .reduce(0, +)
    }
    

    func totalRaces(language: String) -> Int {
            let drivers = allDrivers.localized[language] ?? []
            return drivers
                .flatMap { driver in
                    driver.seasons.filter { $0.team.contains(self.name) }
                }
                .map { $0.races}
                .reduce(0, +)
        
    }
    
    func totalWins(language: String) -> Int {
        let drivers = allDrivers.localized[language] ?? []
        return drivers
            .flatMap { driver in
                driver.seasons.filter { $0.team.contains(self.name) }
            }
            .map { $0.wins}
            .reduce(0, +)
    }
   
    func totalPodiums(language: String) -> Int {
        let drivers = allDrivers.localized[language] ?? []
        return drivers
            .flatMap { driver in
                driver.seasons.filter { $0.team.contains(self.name) }
            }
            .map { $0.podiums}
            .reduce(0, +)
    }
    
   func totalPoles(language: String) -> Int {
        let drivers = allDrivers.localized[language] ?? []
        return drivers
            .flatMap { driver in
                driver.seasons.filter { $0.team.contains(self.name) }
            }
            .map { $0.poles}
            .reduce(0, +)
    }
    
    public func currentDrivers(language: String) -> [Driver] {
        let drivers = allDrivers.localized[language] ?? []
        return drivers.filter { $0.currentTeam == self.name }
    }

    public func oldDriver(language: String) -> [Driver] {
        let drivers = allDrivers.localized[language] ?? []
        return drivers.filter { $0.pastTeams.contains(self.name) }
    }

    func seasonStats(for year: Int?, language: String) -> [DriverSeasonStats] {
        let drivers = allDrivers.localized[language] ?? []
        return drivers
            .flatMap { $0.seasons }
            .filter { $0.team.contains(self.name) && (year == nil || $0.year == year!) }
    }

    
    func WinsSeasonTeam(for year: Int?, language: String) -> Int {
        return seasonStats(for: year, language: language)
                   .map { $0.wins }
                   .reduce(0, +)
    }

    
    func RacesSeasonTeam(for year: Int?, language: String) -> Int {
        return seasonStats(for: year, language: language)
            .map { $0.races }
            .reduce(0, +)
    }
   
    func PodiumsSeasonTeam(for year: Int?, language: String) -> Int {
        return seasonStats(for: year, language: language)
            .map { $0.podiums }
            .reduce(0, +)
    }

    func PolesSeasonTeam(for year: Int?, language: String) -> Int {
        return seasonStats(for: year, language: language)
            .map { $0.poles }
            .reduce(0, +)
    }
   
    func FastestLapsSeasonTeam(for year: Int?, language: String) -> Int {
        return seasonStats(for: year, language: language)
            .map { $0.fastestLaps }
            .reduce(0, +)
    }
    

    

    
    
    public init(id: UUID = UUID(), name: String, image: String,location: String, currentCoach: Coach, oldCoaches: [Coach] = [], currentLivery: [Livery], oldLiveries: [Livery] , specialLiveries: [Livery]) {
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

public struct Livery: Identifiable, Codable {
    public let id: UUID
    public let year: Int
    public let name: String
    public let image: String
    public let reason: String
    
    public init(id: UUID = UUID(), year: Int, name: String, image: String, reason: String) {
        self.id = id
        self.year = year
        self.name = name
        self.image = image
        self.reason = reason
    }
}

// MARK: - Driver

public struct Driver: Identifiable, Codable {
    public let id: UUID
    public var name: String
    public var number: Int
    public var country: String
    public var image: String
    public var teamimage: String
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
        teamimage: String,
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
        self.teamimage = teamimage
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

public struct DriverSeasonStats: Identifiable, Codable {
    public let id: UUID
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
    public let raceStats: [RacesStats]

    public init(id: UUID = UUID(), year: Int, team: String, position: Int, points: Int, podiums: Int, wins: Int, poles: Int,fastestLaps: Int, penaltyPoints: Int, races: Int, raceStats: [RacesStats]) {
        self.id = id
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
        self.raceStats = raceStats
    }
}

public struct RacesStats: Identifiable, Codable {
    public let id: UUID
    public let team: String
    public let race: Int
    public let position: Int?           // nil = DNF
    public let reasonDnf: String?       // falls DNF, warum
    public let points: Int
    public let date: Date               // Kleinschreibung empfohlen
    public let location: String
    public let penalties: Int
    public let reasonPenalty: String?
    public let fastestLap: Bool
    public let fastestLapTime: Double? // optional, nur wenn fastestLap == true
    
    
    
    public init(id: UUID = UUID(), team: String, race: Int, position: Int?, reasonDnf: String?, points: Int, date: Date, location: String, penalties: Int, reasonPenalty: String?, fastestLap: Bool, fastestLapTime: Double?) {
        self.id = id
        self.team = team
        self.race = race
        self.position = position
        self.reasonDnf = reasonDnf
        self.points = points
        self.date = date
        self.location = location
        self.penalties = penalties
        self.reasonPenalty = reasonPenalty
        self.fastestLap = fastestLap
        self.fastestLapTime = fastestLapTime
    }
}

public struct DriverCareerStats: Identifiable, Codable {
    public let id: UUID
    public var gpentered: Int
    public var carrerpoints: Int
    public var highestracefinish: String
    public var podiums: Int
    public var poles: Int
    public var wcs: Int
    public var dnfs: Int
    
    
    public init(id: UUID = UUID(), gpentered: Int, carrerpoints: Int, highestracefinish: String, podiums: Int,poles: Int, wcs: Int, dnfs: Int) {
        self.id = id
        self.gpentered = gpentered
        self.carrerpoints = carrerpoints
        self.highestracefinish = highestracefinish
        self.podiums = podiums
        self.poles = poles
        self.wcs = wcs
        self.dnfs = dnfs
    }
    
    
    
}
    
// MARK: - Infos
public struct CalendarRaces: Codable {
    public var localized: [Int: [OneRaceCalendar]]
}

public struct CalendarAllLaguages: Codable {
    public var localized: [String: [CalendarRaces]]
}

public struct RulesAllLanguages: Codable {
    public var localized: [String: [Rules]]
}

public struct CircuitsAllLanguages: Codable {
    public var localized: [String: [Circuit]]
}

public struct TeamsAllLanguages: Codable {
    public var localized: [String: [Team]]
}

public struct DriverAllLanguages: Codable {
    public var localized: [String: [Driver]]
}

let allCalender = CalendarAllLaguages(localized:
[
    "en": [ CalendarRaces( localized: [ 2024 : [ OneRaceCalendar(circuit: Circuit(name: "Bahrain International Circuit", country: "Bahrain", lengthKm: 5.412, turns: 15, image: "bahrain.jpg"), isSprintWeekend: false, sessions:
         [
            RaceSession(type: .fp1, start: DateComponents(calendar: .current, year: 2024, month: 2, day: 29, hour: 14, minute: 30).date!,
                        end: DateComponents(calendar: .current, year: 2024, month: 2, day: 29, hour: 15, minute: 30).date!),

            RaceSession(type: .fp2, start: DateComponents(calendar: .current, year: 2024, month: 2, day: 29, hour: 18, minute: 00).date!,
                        end: DateComponents(calendar: .current, year: 2024, month: 2, day: 29, hour: 19, minute: 00).date!),

                                                                                RaceSession(type: .fp3, start: DateComponents(calendar: .current, year: 2024, month: 3, day: 1, hour: 15, minute: 30).date!,
                                                                                                  end: DateComponents(calendar: .current, year: 2024, month: 3, day: 1, hour: 16, minute: 30).date!),

                                                                                RaceSession(type: .qualifyingQ1, start: DateComponents(calendar: .current, year: 2024, month: 3, day: 1, hour: 19, minute: 00).date!,
                                                                                                  end: DateComponents(calendar: .current, year: 2024, month: 3, day: 1, hour: 19, minute: 18).date!), // ca. 18 Min

                                                                                RaceSession(type: .qualifyingQ2, start: DateComponents(calendar: .current, year: 2024, month: 3, day: 1, hour: 19, minute: 25).date!,
                                                                                                  end: DateComponents(calendar: .current, year: 2024, month: 3, day: 1, hour: 19, minute: 43).date!), // ca. 18 Min

                                                                                RaceSession(type: .qualifyingQ3, start: DateComponents(calendar: .current, year: 2024, month: 3, day: 1, hour: 19, minute: 50).date!,
                                                                                                  end: DateComponents(calendar: .current, year: 2024, month: 3, day: 1, hour: 20, minute: 00).date!), // ca. 10 Min

                                                                                RaceSession(type: .race, start: DateComponents(calendar: .current, year: 2024, month: 3, day: 2, hour: 18, minute: 00).date!,
                                                                                                  end: DateComponents(calendar: .current, year: 2024, month: 3, day: 2, hour: 20, minute: 00).date!)
                                                                            ]
                                            
                                        ),
                                                 OneRaceCalendar(circuit: Circuit(name: "Bahrain International Circuit", country: "Bahrain", lengthKm: 5.412, turns: 15, image: "bahrain.jpg"),
                                                                                                           isSprintWeekend: false, sessions: [
                                                                                                               RaceSession(type: .fp1, start: DateComponents(calendar: .current, year: 2024, month: 2, day: 29, hour: 14, minute: 30).date!,
                                                                                                                                 end: DateComponents(calendar: .current, year: 2024, month: 2, day: 29, hour: 15, minute: 30).date!),

                                                                                                               RaceSession(type: .fp2, start: DateComponents(calendar: .current, year: 2024, month: 2, day: 29, hour: 18, minute: 00).date!,
                                                                                                                                 end: DateComponents(calendar: .current, year: 2024, month: 2, day: 29, hour: 19, minute: 00).date!),

                                                                                                               RaceSession(type: .fp3, start: DateComponents(calendar: .current, year: 2024, month: 3, day: 1, hour: 15, minute: 30).date!,
                                                                                                                                 end: DateComponents(calendar: .current, year: 2024, month: 3, day: 1, hour: 16, minute: 30).date!),

                                                                                                               RaceSession(type: .qualifyingQ1, start: DateComponents(calendar: .current, year: 2024, month: 3, day: 1, hour: 19, minute: 00).date!,
                                                                                                                                 end: DateComponents(calendar: .current, year: 2024, month: 3, day: 1, hour: 19, minute: 18).date!), // ca. 18 Min

                                                                                                               RaceSession(type: .qualifyingQ2, start: DateComponents(calendar: .current, year: 2024, month: 3, day: 1, hour: 19, minute: 25).date!,
                                                                                                                                 end: DateComponents(calendar: .current, year: 2024, month: 3, day: 1, hour: 19, minute: 43).date!), // ca. 18 Min

                                                                                                               RaceSession(type: .qualifyingQ3, start: DateComponents(calendar: .current, year: 2024, month: 3, day: 1, hour: 19, minute: 50).date!,
                                                                                                                                 end: DateComponents(calendar: .current, year: 2024, month: 3, day: 1, hour: 20, minute: 00).date!), // ca. 10 Min

                                                                                                               RaceSession(type: .race, start: DateComponents(calendar: .current, year: 2024, month: 3, day: 2, hour: 18, minute: 00).date!,
                                                                                                                                 end: DateComponents(calendar: .current, year: 2024, month: 3, day: 2, hour: 20, minute: 00).date!)
                                                                                                           ]
                                                                           
                                                                       ),
                                        
                                        ]]),
            
           ],
    "de": [],
    "it": [],
    "fr": [],
])

let allRules = RulesAllLanguages(localized:
[
    "en": [ Rules( name: "Parc Fermé Restrictions",
                        image: "parc_ferme.png",
                        descriptionSmall: "After qualifying, teams are restricted from making setup changes to the car unless approved by FIA. This ensures fairness going into the race.",
                        description: "N/A",
                        category: "Technical Regulation",
                        isActive: true,
                        severity: 4,
                        createdAt: Date(timeIntervalSince1970: 1251868800), // 2009
                        tags: ["qualifying", "car setup", "FIA"],
                        relatedLinks: [
                            URL(string: "https://www.fia.com/regulation/parc-ferme")!
                        ],
                        author: "FIA")],
    "de": [],
    "it": [],
    "fr": [],
            
            
])
   
let allCircuits = CircuitsAllLanguages(localized:
[
        "en": [
                Circuit(name: "Bahrain International Circuit", country: "Bahrain", lengthKm: 5.412, turns: 15, image: "bahrain.jpg"),
                Circuit(name: "Jeddah Corniche Circuit", country: "Saudi Arabia", lengthKm: 6.175, turns: 27, image: "jeddah.jpg"),
                Circuit(name: "Albert Park Circuit", country: "Australia", lengthKm: 5.278, turns: 14, image: "albertpark.jpg"),
                Circuit(name: "Suzuka International Racing Course", country: "Japan", lengthKm: 5.807, turns: 18, image: "suzuka.jpg"),
                Circuit(name: "Shanghai International Circuit", country: "China", lengthKm: 5.451, turns: 16, image: "shanghai.jpg"),
                Circuit(name: "Miami International Autodrome", country: "USA", lengthKm: 5.412, turns: 19, image: "miami.jpg"),
                Circuit(name: "Autodromo Enzo e Dino Ferrari (Imola)", country: "Italy", lengthKm: 4.909, turns: 19, image: "imola.jpg"),
                Circuit(name: "Circuit de Monaco", country: "Monaco", lengthKm: 3.337, turns: 19, image: "monaco.jpg"),
                Circuit(name: "Circuit Gilles Villeneuve", country: "Canada", lengthKm: 4.361, turns: 14, image: "montreal.jpg"),
                Circuit(name: "Circuit de Barcelona-Catalunya", country: "Spain", lengthKm: 4.675, turns: 16, image: "barcelona.jpg"),
                Circuit(name: "Red Bull Ring", country: "Austria", lengthKm: 4.318, turns: 10, image: "redbullring.jpg"),
                Circuit(name: "Silverstone Circuit", country: "United Kingdom", lengthKm: 5.891, turns: 18, image: "silverstone.jpg"),
                Circuit(name: "Hungaroring", country: "Hungary", lengthKm: 4.381, turns: 14, image: "hungaroring.jpg"),
                Circuit(name: "Circuit de Spa-Francorchamps", country: "Belgium", lengthKm: 7.004, turns: 19, image: "spa.jpg"),
                Circuit(name: "Circuit Zandvoort", country: "Netherlands", lengthKm: 4.259, turns: 14, image: "zandvoort.jpg"),
                Circuit(name: "Autodromo Nazionale Monza", country: "Italy2", lengthKm: 5.793, turns: 11, image: "monza.jpg"),
                Circuit(name: "Baku City Circuit", country: "Azerbaijan", lengthKm: 6.003, turns: 20, image: "baku.jpg"),
                Circuit(name: "Marina Bay Street Circuit", country: "Singapore", lengthKm: 4.940, turns: 19, image: "singapore.jpg"),
                Circuit(name: "Circuit of the Americas", country: "USA", lengthKm: 5.513, turns: 20, image: "cota.jpg"),
                Circuit(name: "Autódromo Hermanos Rodríguez", country: "Mexico", lengthKm: 4.304, turns: 17, image: "mexico.jpg"),
                Circuit(name: "Interlagos (Autódromo José Carlos Pace)", country: "Brazil", lengthKm: 4.309, turns: 15, image: "interlagos.jpg"),
                Circuit(name: "Las Vegas Strip Circuit", country: "USA", lengthKm: 6.201, turns: 17, image: "lasvegas.jpg"),
                Circuit(name: "Losail International Circuit", country: "Qatar", lengthKm: 5.418, turns: 16, image: "losail.jpg"),
                Circuit(name: "Yas Marina Circuit", country: "United Arab Emirates", lengthKm: 5.281, turns: 16, image: "yasmarina.jpg")
],
        "de": [],
        "it": [],
        "fr": [],
    
    ])
  
let allTeams = TeamsAllLanguages(localized:
[
        "en": [
            Team(
            name: "Mercedes",
            image: "mercedes_logo",
            location: "Brackley, England",
            currentCoach:
                Coach(name: "Toto Wolff", yearsActive: 2013...2025, image: "wolff.img", bio: "CEO und Teamchef seit 2013, Architekt der Hybrid-Ära", races: 250, podiums: 180, wins: 115)
            ,
            oldCoaches: [
                Coach(name: "Ross Brawn", yearsActive: 2010...2012, image: "brawn.img", bio: "Technikgenie und Gründer von Brawn GP", races: 58, podiums: 23, wins: 12),
                Coach(name: "Norbert Haug", yearsActive: 1998...2008, image: "haug.img", bio: "Langjähriger Motorsportchef bei Mercedes", races: 162, podiums: 45, wins: 18)
            ],
            currentLivery: [
                Livery(year: 2025, name: "Black-Silver with Teal Accents", image: "mercedes.2025", reason: "Modernisierte Optik für neue Fahrerpaarung")
            ],
            oldLiveries: [
                Livery(year: 2010, name: "Silver Arrow", image: "mercedes.2010", reason: "Traditionelles Mercedes-Design"),
                Livery(year: 2020, name: "Black Panther", image: "mercedes.2020", reason: "Diversity-Initiative"),
                Livery(year: 2022, name: "Silver-Black Hybrid", image: "mercedes.2022", reason: "Rückkehr zur silbernen Basis mit modernen Akzenten")
            ],
            specialLiveries: [
                Livery(year: 2020, name: "End Racism", image: "mercedes.endracism", reason: "Solidarität mit Vielfalt und Inklusion"),
                Livery(year: 2025, name: "F1 75 Live Edition", image: "mercedes.f175live", reason: "Feier des 75-jährigen F1-Jubiläums")
            ]
        ),
            Team(
                name: "Red Bull Racing",
                image: "redbull_logo",
                location: "Milton Keynes, England",
                currentCoach:
                    Coach(name: "Laurent Mekies", yearsActive: 2025...2025, image: "mekies.img", bio: "Nachfolger von Horner, zuvor bei Ferrari und FIA", races: 12, podiums: 6, wins: 2)
                ,
                oldCoaches: [
                    Coach(name: "Christian Horner", yearsActive: 2005...2025, image: "horner.img", bio: "Langjähriger Teamchef mit 6 Konstrukteurs- und 8 Fahrertiteln", races: 405, podiums: 196, wins: 124)
                ],
                currentLivery: [
                    Livery(year: 2025, name: "Dark Blue with Red and Yellow Bull", image: "redbull.2025", reason: "Klassisches Red-Bull-Design mit modernem Touch")
                ],
                oldLiveries: [
                    Livery(year: 2005, name: "Classic Bull", image: "redbull.2005", reason: "Erstes Red-Bull-F1-Design"),
                    Livery(year: 2015, name: "Camo Bull", image: "redbull.2015", reason: "Test-Livery zur Tarnung technischer Details"),
                    Livery(year: 2023, name: "Championship Edition", image: "redbull.2023", reason: "Feier der Titel mit Verstappen")
                ],
                specialLiveries: [
                    Livery(year: 2023, name: "Las Vegas Fan Design", image: "redbull.vegas2023", reason: "Fan-Design für das Las Vegas GP"),
                    Livery(year: 2025, name: "Honda Tribute", image: "redbull.honda2025", reason: "Ehrung der Honda-Partnerschaft beim Japan GP")
                ]
            ),
            Team(
                name: "Ferrari",
                image: "ferrari_logo",
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
                    Livery(year: 2025, name: "Deep Rosso Corsa with White Accents", image: "ferrari.2025", reason: "Neues Design für Hamiltons Einstieg")
                ],
                oldLiveries: [
                    Livery(year: 2000, name: "Classic Red", image: "ferrari.2000", reason: "Schumacher-Ära"),
                    Livery(year: 2018, name: "Matte Red", image: "ferrari.2018", reason: "Modernisierung der Lackierung"),
                    Livery(year: 2023, name: "HP Edition", image: "ferrari.2023", reason: "Partnerschaft mit HP")
                ],
                specialLiveries: [
                    Livery(year: 2022, name: "Monza Yellow Tribute", image: "ferrari.monza2022", reason: "75 Jahre Ferrari"),
                    Livery(year: 2025, name: "SF-25 Reveal", image: "ferrari.sf25", reason: "Präsentation des neuen Autos mit Hamilton")
                ]
            ),
            ],
        "de": [],
        "it": [],
        "fr": [],
        
    ])

let allDrivers = DriverAllLanguages(localized:
[
    "en": [ Driver(
    name: "Lewis Hamilton",
    number: 44,
    country: "United Kingdom",
    image: "lewis-hamilton",
    teamimage: "ferrari_logo",
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
        DriverSeasonStats(
            year: 2023,
            team: "Mercedes",
            position: 3,
            points: 234,
            podiums: 6,
            wins: 0,
            poles: 1,
            fastestLaps: 4,
            penaltyPoints: 1,
            races: 22,
            raceStats: [
                RacesStats(team: "Mercedes", race: 1, position: 5, reasonDnf: nil, points: 10, date: DateComponents(calendar: .current, year: 2023, month: 3, day: 5).date!, location: "Bahrain", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 2, position: 5, reasonDnf: nil, points: 10, date: DateComponents(calendar: .current, year: 2023, month: 3, day: 19).date!, location: "Saudi Arabia", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 3, position: 2, reasonDnf: nil, points: 18, date: DateComponents(calendar: .current, year: 2023, month: 4, day: 2).date!, location: "Australia", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 4, position: 6, reasonDnf: nil, points: 10, date: DateComponents(calendar: .current, year: 2023, month: 4, day: 30).date!, location: "Azerbaijan", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 5, position: 6, reasonDnf: nil, points: 8, date: DateComponents(calendar: .current, year: 2023, month: 5, day: 7).date!, location: "USA", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 6, position: 4, reasonDnf: nil, points: 13, date: DateComponents(calendar: .current, year: 2023, month: 5, day: 28).date!, location: "Monaco", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 7, position: 2, reasonDnf: nil, points: 18, date: DateComponents(calendar: .current, year: 2023, month: 6, day: 4).date!, location: "Spain", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 8, position: 3, reasonDnf: nil, points: 15, date: DateComponents(calendar: .current, year: 2023, month: 6, day: 18).date!, location: "Canada", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 9, position: 8, reasonDnf: nil, points: 4, date: DateComponents(calendar: .current, year: 2023, month: 7, day: 2).date!, location: "Austria", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 10, position: 3, reasonDnf: nil, points: 15, date: DateComponents(calendar: .current, year: 2023, month: 7, day: 9).date!, location: "UK", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 11, position: 4, reasonDnf: nil, points: 12, date: DateComponents(calendar: .current, year: 2023, month: 7, day: 23).date!, location: "Hungary", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 12, position: 4, reasonDnf: nil, points: 15, date: DateComponents(calendar: .current, year: 2023, month: 7, day: 30).date!, location: "Belgium", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 13, position: 6, reasonDnf: nil, points: 8, date: DateComponents(calendar: .current, year: 2023, month: 8, day: 27).date!, location: "Netherlands", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 14, position: 6, reasonDnf: nil, points: 8, date: DateComponents(calendar: .current, year: 2023, month: 9, day: 3).date!, location: "Italy", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 15, position: 3, reasonDnf: nil, points: 16, date: DateComponents(calendar: .current, year: 2023, month: 9, day: 17).date!, location: "Singapore", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 16, position: 5, reasonDnf: nil, points: 10, date: DateComponents(calendar: .current, year: 2023, month: 9, day: 24).date!, location: "Japan", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 17, position: nil, reasonDnf: "Collision", points: 0, date: DateComponents(calendar: .current, year: 2023, month: 10, day: 8).date!, location: "Qatar", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 18, position: nil, reasonDnf: "Disqualified", points: 0, date: DateComponents(calendar: .current, year: 2023, month: 10, day: 22).date!, location: "USA", penalties: 1, reasonPenalty: "Skid block wear", fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 19, position: 2, reasonDnf: nil, points: 19, date: DateComponents(calendar: .current, year: 2023, month: 10, day: 29).date!, location: "Mexico", penalties: 0, reasonPenalty: nil, fastestLap: true, fastestLapTime: 90.7),
                RacesStats(team: "Mercedes", race: 20, position: 8, reasonDnf: nil, points: 6, date: DateComponents(calendar: .current, year: 2023, month: 11, day: 5).date!, location: "Brazil", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 21, position: 7, reasonDnf: nil, points: 6, date: DateComponents(calendar: .current, year: 2023, month: 11, day: 18).date!, location: "USA", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 22, position: 9, reasonDnf: nil, points: 2, date: DateComponents(calendar: .current, year: 2023, month: 11, day: 26).date!, location: "Abu Dhabi", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                
        ]
            ),
        DriverSeasonStats(
            year: 2024,
            team: "Mercedes",
            position: 7,
            points: 223,
            podiums: 5,
            wins: 2,
            poles: 0,
            fastestLaps: 2,
            penaltyPoints: 0,
            races: 24,
            raceStats: [
                RacesStats(team: "Mercedes", race: 1, position: 7, reasonDnf: nil, points: 6, date: DateComponents(calendar: .current, year: 2024, month: 3, day: 2).date!, location: "Bahrain", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 2, position: 9, reasonDnf: nil, points: 2, date: DateComponents(calendar: .current, year: 2024, month: 3, day: 9).date!, location: "Jeddah", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 3, position: nil, reasonDnf: "Power unit failure", points: 0, date: DateComponents(calendar: .current, year: 2024, month: 3, day: 24).date!, location: "Australia", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 4, position: 9, reasonDnf: nil, points: 2, date: DateComponents(calendar: .current, year: 2024, month: 4, day: 7).date!, location: "Japan", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 5, position: 9, reasonDnf: nil, points: 9, date: DateComponents(calendar: .current, year: 2024, month: 4, day: 21).date!, location: "China", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 6, position: 6, reasonDnf: nil, points: 8, date: DateComponents(calendar: .current, year: 2024, month: 5, day: 5).date!, location: "USA", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 7, position: 6, reasonDnf: nil, points: 8, date: DateComponents(calendar: .current, year: 2024, month: 5, day: 19).date!, location: "Italy", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 8, position: 7, reasonDnf: nil, points: 7, date: DateComponents(calendar: .current, year: 2024, month: 5, day: 26).date!, location: "Monaco", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 9, position: 4, reasonDnf: nil, points: 13, date: DateComponents(calendar: .current, year: 2024, month: 6, day: 9).date!, location: "Canada", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 10, position: 3, reasonDnf: nil, points: 15, date: DateComponents(calendar: .current, year: 2024, month: 6, day: 23).date!, location: "Spain", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 11, position: 4, reasonDnf: nil, points: 15, date: DateComponents(calendar: .current, year: 2024, month: 6, day: 30).date!, location: "Austria", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 12, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2024, month: 7, day: 7).date!, location: "UK", penalties: 0, reasonPenalty: nil, fastestLap: true, fastestLapTime: 89.6),
                RacesStats(team: "Mercedes", race: 13, position: 3, reasonDnf: nil, points: 15, date: DateComponents(calendar: .current, year: 2024, month: 7, day: 21).date!, location: "Hungary", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 14, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2024, month: 7, day: 28).date!, location: "Belgium", penalties: 0, reasonPenalty: nil, fastestLap: true, fastestLapTime: 90.2),
                RacesStats(team: "Mercedes", race: 15, position: 8, reasonDnf: nil, points: 4, date: DateComponents(calendar: .current, year: 2024, month: 8, day: 25).date!, location: "Netherlands", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 16, position: 5, reasonDnf: nil, points: 10, date: DateComponents(calendar: .current, year: 2024, month: 9, day: 1).date!, location: "Italy2", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 17, position: 9, reasonDnf: nil, points: 2, date: DateComponents(calendar: .current, year: 2024, month: 9, day: 15).date!, location: "Azerbaijan", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 18, position: 6, reasonDnf: nil, points: 8, date: DateComponents(calendar: .current, year: 2024, month: 9, day: 22).date!, location: "Singapore", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 19, position: nil, reasonDnf: "Spun off", points: 0, date: DateComponents(calendar: .current, year: 2024, month: 10, day: 20).date!, location: "USA", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 20, position: 4, reasonDnf: nil, points: 12, date: DateComponents(calendar: .current, year: 2024, month: 10, day: 27).date!, location: "Mexico", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 21, position: 10, reasonDnf: nil, points: 1, date: DateComponents(calendar: .current, year: 2024, month: 11, day: 3).date!, location: "Brazil", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
                RacesStats(team: "Mercedes", race: 22, position: 2, reasonDnf: nil, points: 18, date: DateComponents(calendar: .current, year: 2024, month: 11, day: 10).date!, location: "Abu Dhabi", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
        ]
            ),
        ],

    


    careerstats: [
        DriverCareerStats(gpentered: 368, carrerpoints: 4965, highestracefinish: "1 (x105)", podiums: 202, poles: 104, wcs: 7, dnfs: 32)
    ],
    
),
    Driver(
        name: "Max Verstappen",
        number: 1,
        country: "Netherlands",
        image: "max-verstappen",
        teamimage: "redbull_logo",
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
        
        DriverSeasonStats(year: 2023, team: "Red Bull Racing", position: 1, points: 575, podiums: 21, wins: 19, poles: 12, fastestLaps: 9, penaltyPoints: 2, races: 22, raceStats: [
            RacesStats(team: "Red Bull Racing", race: 1, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2023, month: 3, day: 5).date!, location: "Bahrain", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 2, position: 1, reasonDnf: nil, points: 26, date: DateComponents(calendar: .current, year: 2023, month: 3, day: 19).date!, location: "Saudi Arabia", penalties: 0, reasonPenalty: nil, fastestLap: true, fastestLapTime: 90.2),
            RacesStats(team: "Red Bull Racing", race: 3, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2023, month: 4, day: 2).date!, location: "Australia", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 4, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2023, month: 4, day: 30).date!, location: "Azerbaijan", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 5, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2023, month: 5, day: 7).date!, location: "USA", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 6, position: 2, reasonDnf: nil, points: 18, date: DateComponents(calendar: .current, year: 2023, month: 5, day: 28).date!, location: "Monaco", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 7, position: 1, reasonDnf: nil, points: 26, date: DateComponents(calendar: .current, year: 2023, month: 6, day: 4).date!, location: "Spain", penalties: 0, reasonPenalty: nil, fastestLap: true, fastestLapTime: 90.1),
            RacesStats(team: "Red Bull Racing", race: 8, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2023, month: 6, day: 18).date!, location: "Canada", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 9, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2023, month: 7, day: 2).date!, location: "Austria", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 10, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2023, month: 7, day: 9).date!, location: "UK", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 11, position: 1, reasonDnf: nil, points: 26, date: DateComponents(calendar: .current, year: 2023, month: 7, day: 23).date!, location: "Hungary", penalties: 0, reasonPenalty: nil, fastestLap: true, fastestLapTime: 90.0),
            RacesStats(team: "Red Bull Racing", race: 12, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2023, month: 7, day: 30).date!, location: "Belgium", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 13, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2023, month: 8, day: 27).date!, location: "Netherlands", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 14, position: 1, reasonDnf: nil, points: 26, date: DateComponents(calendar: .current, year: 2023, month: 9, day: 3).date!, location: "Italy", penalties: 0, reasonPenalty: nil, fastestLap: true, fastestLapTime: 89.8),
            RacesStats(team: "Red Bull Racing", race: 15, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2023, month: 9, day: 17).date!, location: "Singapore", penalties: 1, reasonPenalty: "Unsafe release", fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 16, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2023, month: 9, day: 24).date!, location: "Japan", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 17, position: 1, reasonDnf: nil, points: 26, date: DateComponents(calendar: .current, year: 2023, month: 10, day: 8).date!, location: "Qatar", penalties: 0, reasonPenalty: nil, fastestLap: true, fastestLapTime: 90.3),
            RacesStats(team: "Red Bull Racing", race: 18, position: 2, reasonDnf: nil, points: 18, date: DateComponents(calendar: .current, year: 2023, month: 10, day: 22).date!, location: "USA", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 19, position: 3, reasonDnf: nil, points: 15, date: DateComponents(calendar: .current, year: 2023, month: 10, day: 29).date!, location: "Mexico", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 20, position: 1, reasonDnf: nil, points: 26, date: DateComponents(calendar: .current, year: 2023, month: 11, day: 5).date!, location: "Brazil", penalties: 0, reasonPenalty: nil, fastestLap: true, fastestLapTime: 89.9),
            RacesStats(team: "Red Bull Racing", race: 21, position: 2, reasonDnf: nil, points: 18, date: DateComponents(calendar: .current, year: 2023, month: 11, day: 18).date!, location: "USA", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 22, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2023, month: 11, day: 26).date!, location: "Abu Dhabi", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil)
        ], ),
        DriverSeasonStats(year: 2024, team: "Red Bull Racing", position: 1, points: 437, podiums: 14, wins: 9, poles: 8, fastestLaps: 3, penaltyPoints: 1, races: 24, raceStats: [
            RacesStats(team: "Red Bull Racing", race: 1, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2024, month: 3, day: 2).date!, location: "Bahrain", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 2, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2024, month: 3, day: 9).date!, location: "Saudi Arabia", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 3, position: nil, reasonDnf: "Collision", points: 0, date: DateComponents(calendar: .current, year: 2024, month: 3, day: 24).date!, location: "Australia ", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 4, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2024, month: 4, day: 7).date!, location: "Japan", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 5, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2024, month: 4, day: 21).date!, location: "China", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 6, position: 2, reasonDnf: nil, points: 18, date: DateComponents(calendar: .current, year: 2024, month: 5, day: 5).date!, location: "USA", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 7, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2024, month: 5, day: 19).date!, location: "Emilia-Romagna", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 8, position: 6, reasonDnf: nil, points: 8, date: DateComponents(calendar: .current, year: 2024, month: 5, day: 26).date!, location: "Monaco", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 9, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2024, month: 6, day: 9).date!, location: "Canada", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 10, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2024, month: 6, day: 23).date!, location: "Spain", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 11, position: 5, reasonDnf: nil, points: 10, date: DateComponents(calendar: .current, year: 2024, month: 6, day: 30).date!, location: "Austria", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 12, position: 2, reasonDnf: nil, points: 18, date: DateComponents(calendar: .current, year: 2024, month: 7, day: 7).date!, location: "UK", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 13, position: 5, reasonDnf: nil, points: 10, date: DateComponents(calendar: .current, year: 2024, month: 7, day: 21).date!, location: "Hungary", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 14, position: 4, reasonDnf: nil, points: 12, date: DateComponents(calendar: .current, year: 2024, month: 7, day: 28).date!, location: "Belgium", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 15, position: 2, reasonDnf: nil, points: 18, date: DateComponents(calendar: .current, year: 2024, month: 8, day: 25).date!, location: "Netherlands", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 16, position: 6, reasonDnf: nil, points: 8, date: DateComponents(calendar: .current, year: 2024, month: 9, day: 1).date!, location: "Italy", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 17, position: 5, reasonDnf: nil, points: 10, date: DateComponents(calendar: .current, year: 2024, month: 9, day: 15).date!, location: "Azerbaijan", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 18, position: 2, reasonDnf: nil, points: 18, date: DateComponents(calendar: .current, year: 2024, month: 9, day: 22).date!, location: "Singapore", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 19, position: 3, reasonDnf: nil, points: 15, date: DateComponents(calendar: .current, year: 2024, month: 10, day: 20).date!, location: "USA", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 20, position: 6, reasonDnf: nil, points: 8, date: DateComponents(calendar: .current, year: 2024, month: 10, day: 27).date!, location: "Mexico", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 21, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2024, month: 11, day: 3).date!, location: "Brazil", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 22, position: 5, reasonDnf: nil, points: 10, date: DateComponents(calendar: .current, year: 2024, month: 11, day: 24).date!, location: "USA", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Red Bull Racing", race: 23, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2024, month: 11, day: 30).date!, location: "Abu Dhabi ", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil)
        ], ),
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
        teamimage: "ferrari_logo",
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
        DriverSeasonStats(year: 2023, team: "Ferrari", position: 5, points: 206, podiums: 6, wins: 0, poles: 5, fastestLaps: 3, penaltyPoints: 1, races: 22, raceStats: [
            RacesStats(team: "Ferrari", race: 1, position: nil, reasonDnf: "Engine failure", points: 0, date: DateComponents(calendar: .current, year: 2023, month: 3, day: 5).date!, location: "Bahrain", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 2, position: 7, reasonDnf: nil, points: 6, date: DateComponents(calendar: .current, year: 2023, month: 3, day: 19).date!, location: "Saudi Arabia", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 3, position: nil, reasonDnf: "Collision", points: 0, date: DateComponents(calendar: .current, year: 2023, month: 4, day: 2).date!, location: "Australia", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 4, position: 3, reasonDnf: nil, points: 22, date: DateComponents(calendar: .current, year: 2023, month: 4, day: 30).date!, location: "Azerbaijan", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 5, position: 7, reasonDnf: nil, points: 6, date: DateComponents(calendar: .current, year: 2023, month: 5, day: 7).date!, location: "USA", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 6, position: 6, reasonDnf: nil, points: 8, date: DateComponents(calendar: .current, year: 2023, month: 5, day: 28).date!, location: "Monaco", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 7, position: 11, reasonDnf: nil, points: 0, date: DateComponents(calendar: .current, year: 2023, month: 6, day: 4).date!, location: "Spain", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 8, position: 4, reasonDnf: nil, points: 12, date: DateComponents(calendar: .current, year: 2023, month: 6, day: 18).date!, location: "Canada", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 9, position: 2, reasonDnf: nil, points: 18, date: DateComponents(calendar: .current, year: 2023, month: 7, day: 2).date!, location: "Austria", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 10, position: 9, reasonDnf: nil, points: 2, date: DateComponents(calendar: .current, year: 2023, month: 7, day: 9).date!, location: "UK", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 11, position: 7, reasonDnf: nil, points: 6, date: DateComponents(calendar: .current, year: 2023, month: 7, day: 23).date!, location: "Hungary", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 12, position: 3, reasonDnf: nil, points: 19, date: DateComponents(calendar: .current, year: 2023, month: 7, day: 30).date!, location: "Belgium", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 13, position: nil, reasonDnf: "Undertray damage", points: 0, date: DateComponents(calendar: .current, year: 2023, month: 8, day: 27).date!, location: "Netherlands", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 14, position: 4, reasonDnf: nil, points: 12, date: DateComponents(calendar: .current, year: 2023, month: 9, day: 3).date!, location: "Italy", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 15, position: 4, reasonDnf: nil, points: 12, date: DateComponents(calendar: .current, year: 2023, month: 9, day: 17).date!, location: "Singapore", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 16, position: 4, reasonDnf: nil, points: 12, date: DateComponents(calendar: .current, year: 2023, month: 9, day: 24).date!, location: "Japan", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 17, position: 5, reasonDnf: nil, points: 10, date: DateComponents(calendar: .current, year: 2023, month: 10, day: 8).date!, location: "Qatar", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 18, position: nil, reasonDnf: "Disqualified – skid block wear", points: 0, date: DateComponents(calendar: .current, year: 2023, month: 10, day: 22).date!, location: "USA", penalties: 0, reasonPenalty: "Technical infringement", fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 19, position: 3, reasonDnf: nil, points: 15, date: DateComponents(calendar: .current, year: 2023, month: 10, day: 29).date!, location: "Mexico", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 20, position: nil, reasonDnf: "Hydraulic failure", points: 0, date: DateComponents(calendar: .current, year: 2023, month: 11, day: 5).date!, location: "Brazil", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 21, position: 2, reasonDnf: nil, points: 18, date: DateComponents(calendar: .current, year: 2023, month: 11, day: 18).date!, location: "USA", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 22, position: 2, reasonDnf: nil, points: 18, date: DateComponents(calendar: .current, year: 2023, month: 11, day: 26).date!, location: "Abu Dhabi", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil)
        ]
),
        DriverSeasonStats(year: 2024, team: "Ferrari", position: 3, points: 356, podiums: 13, wins: 3, poles: 4, fastestLaps: 4, penaltyPoints: 0, races: 24, raceStats: [
            RacesStats(team: "Ferrari", race: 1, position: 4, reasonDnf: nil, points: 12, date: DateComponents(calendar: .current, year: 2024, month: 3, day: 2).date!, location: "Bahrain", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 2, position: 3, reasonDnf: nil, points: 16, date: DateComponents(calendar: .current, year: 2024, month: 3, day: 9).date!, location: "Saudi Arabia", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 3, position: 2, reasonDnf: nil, points: 19, date: DateComponents(calendar: .current, year: 2024, month: 3, day: 24).date!, location: "Australia", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 4, position: 4, reasonDnf: nil, points: 12, date: DateComponents(calendar: .current, year: 2024, month: 4, day: 7).date!, location: "Japan", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 5, position: 4, reasonDnf: nil, points: 17, date: DateComponents(calendar: .current, year: 2024, month: 4, day: 21).date!, location: "China", penalties: 0, reasonPenalty: nil, fastestLap: true, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 6, position: 3, reasonDnf: nil, points: 22, date: DateComponents(calendar: .current, year: 2024, month: 5, day: 5).date!, location: "USA", penalties: 0, reasonPenalty: nil, fastestLap: true, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 7, position: 3, reasonDnf: nil, points: 15, date: DateComponents(calendar: .current, year: 2024, month: 5, day: 19).date!, location: "Emilia-Romagna", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 8, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2024, month: 5, day: 26).date!, location: "Monaco", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 9, position: nil, reasonDnf: "Engine failure", points: 0, date: DateComponents(calendar: .current, year: 2024, month: 6, day: 9).date!, location: "Canada", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 10, position: 5, reasonDnf: nil, points: 10, date: DateComponents(calendar: .current, year: 2024, month: 6, day: 23).date!, location: "Spain", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 11, position: 11, reasonDnf: nil, points: 2, date: DateComponents(calendar: .current, year: 2024, month: 6, day: 30).date!, location: "Austria", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 12, position: 14, reasonDnf: nil, points: 0, date: DateComponents(calendar: .current, year: 2024, month: 7, day: 7).date!, location: "UK", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 13, position: 4, reasonDnf: nil, points: 12, date: DateComponents(calendar: .current, year: 2024, month: 7, day: 21).date!, location: "Hungary", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 14, position: 3, reasonDnf: nil, points: 15, date: DateComponents(calendar: .current, year: 2024, month: 7, day: 28).date!, location: "Belgium", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 15, position: 3, reasonDnf: nil, points: 15, date: DateComponents(calendar: .current, year: 2024, month: 8, day: 25).date!, location: "Netherlands", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 16, position: 1, reasonDnf: nil, points: 25, date: DateComponents(calendar: .current, year: 2024, month: 9, day: 1).date!, location: "Italy", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 17, position: 2, reasonDnf: nil, points: 18, date: DateComponents(calendar: .current, year: 2024, month: 9, day: 15).date!, location: "Azerbaijan", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 18, position: 5, reasonDnf: nil, points: 10, date: DateComponents(calendar: .current, year: 2024, month: 9, day: 22).date!, location: "Singapore", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 19, position: 1, reasonDnf: nil, points: 30, date: DateComponents(calendar: .current, year: 2024, month: 10, day: 20).date!, location: "USA", penalties: 0, reasonPenalty: nil, fastestLap: true, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 20, position: 3, reasonDnf: nil, points: 16, date: DateComponents(calendar: .current, year: 2024, month: 10, day: 27).date!, location: "Mexico", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 21, position: 5, reasonDnf: nil, points: 10, date: DateComponents(calendar: .current, year: 2024, month: 11, day: 3).date!, location: "Brazil", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 22, position: 4, reasonDnf: nil, points: 12, date: DateComponents(calendar: .current, year: 2024, month: 11, day: 23).date!, location: "USA", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            RacesStats(team: "Ferrari", race: 23, position: 2, reasonDnf: nil, points: 18, date: DateComponents(calendar: .current, year: 2024, month: 12, day: 10).date!, location: "Qatar", penalties: 0, reasonPenalty: nil, fastestLap: false, fastestLapTime: nil),
            ]

                        )
        ],


        careerstats: [
        DriverCareerStats(gpentered: 159, carrerpoints: 1549, highestracefinish: "1 (x8)", podiums: 47, poles: 26, wcs: 0, dnfs: 21,)
        ]
    ),
    ],
    "de": [ ],
    "it": [],
    "fr": [],


])


