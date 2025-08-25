//
//  TabManager.swift
//  F1 Check-Up v3
//
//  Created by Ansgar Seifert on 18.07.25.
//

// GlobalManagers.swift
import Foundation
import FirebaseAuth
import FirebaseFirestore
import Security
import SwiftUICore
import SwiftUI

class AppState: ObservableObject {
    @Published var selectedLanguage: Language = .en
    @Published var selectedTab: Tab = .roster
    @Published var PrimaryColor: PrimaryColor = .blue
    @Published var userEmail: String?
    @Published var errorMessage: String?
    @Published var EndStartView: Bool = false
    @Published var username: String?
    @Published var isLoggedIn: Bool = false
    @Published var SequenceBeforeDriver: Bool = false
    @Published var ShowSplash : Bool = true
    @Published var AccountCreated = Timestamp()
    @Published var ColorPreset: Int = 0
    @Published var ColorPickerShow = false
    @Published var Notifications = false
    @Published var SelectedView: String = "Drivers"
    @Published var FavIndicies: Set<Int> = []
    @Published var SelectedOption: selectedOption = .Search
    
   
    
    @AppStorage("DriverFavorites") private var driverFavoritesStorage: String = ""
    @AppStorage("TeamFavorites") private var teamFavoritesStorage: String = ""
    @AppStorage("RulesFavorites") private var rulesFavoritesStorage: String = ""
    @AppStorage("SeasonFavorites") private var seasonFavoritesStorage: String = ""
    @AppStorage("StrategiesFavorites") private var strategiesFavoritesStorage: String = ""
    @AppStorage("CircuitsFavorites") private var circuitsFavoritesStorage: String = ""
    @AppStorage("RecordsFavorites") private var recordsFavoritesStorage: String = ""
    @AppStorage("TriviaFavorites") private var triviaFavoritesStorage: String = ""
    @AppStorage("FanVotingFavorites") private var fanVotingFavoritesStorage: String = ""
    @AppStorage("TechFavorites") private var techFavoritesStorage: String = ""
    @AppStorage("RadioMomentsFavorites") private var radioMomentsFavoritesStorage: String = ""
    
    
    
    
    var DriverFav: Set<String> = []
    var TeamFav: Set<String> = []
    var RulesFav: Set<String> = []
    var SeasonFav: Set<String> = []
    var StrategiesFav: Set<String> = []
    var CircuitsFav: Set<String> = []
    var RecordsFav: Set<String> = []
    var TriviaFav: Set<String> = []
    var FanVotingFav: Set<String> = []
    var TechFav: Set<String> = []
    var RadioMomentsFav: Set<String> = []

    
  
    @AppStorage("DriverHistory") private var driverHistoryStorage: String = ""
    @AppStorage("TeamHistory") private var teamHistoryStorage: String = ""
    @AppStorage("RulesHistory") private var rulesHistoryStorage: String = ""
    @AppStorage("SeasonHistory") private var seasonHistoryStorage: String = ""
    @AppStorage("StrategiesHistory") private var strategiesHistoryStorage: String = ""
    @AppStorage("CircuitsHistory") private var circuitsHistoryStorage: String = ""
    @AppStorage("RecordsHistory") private var recordsHistoryStorage: String = ""
    @AppStorage("TriviaHistory") private var triviaHistoryStorage: String = ""
    @AppStorage("FanVotingHistory") private var fanVotingHistoryStorage: String = ""
    @AppStorage("TechHistory") private var techHistoryStorage: String = ""
    @AppStorage("RadioMomentsHistory") private var radioMomentsHistoryStorage: String = ""
    

    
    var DriverHistory: Set<String> = []
    var TeamHistory: Set<String> = []
    var RulesHistory: Set<String> = []
    var SeasonHistory: Set<String> = []
    var StrategiesHistory: Set<String> = []
    var CircuitsHistory: Set<String> = []
    var RecordsHistory: Set<String> = []
    var TriviaHistory: Set<String> = []
    var FanVotingHistory: Set<String> = []
    var TechHistory: Set<String> = []
    var RadioMomentsHistory: Set<String> = []
    
    
    
    //Save
    func saveSearchBarInfos() {
        driverHistoryStorage = Set(DriverHistory.prefix(10)).joined(separator: ",")
        teamHistoryStorage = Set(TeamHistory.prefix(10)).joined(separator: ",")
        rulesHistoryStorage = Set(RulesHistory.prefix(10)).joined(separator: ",")
        seasonHistoryStorage = Set(SeasonHistory.prefix(10)).joined(separator: ",")
        strategiesHistoryStorage = Set(StrategiesHistory.prefix(10)).joined(separator: ",")
        circuitsHistoryStorage = Set(CircuitsHistory.prefix(10)).joined(separator: ",")
        recordsHistoryStorage = Set(RecordsHistory.prefix(10)).joined(separator: ",")
        triviaHistoryStorage = Set(TriviaHistory.prefix(10)).joined(separator: ",")
        fanVotingHistoryStorage = Set(FanVotingHistory.prefix(10)).joined(separator: ",")
        techHistoryStorage = Set(TechHistory.prefix(10)).joined(separator: ",")
        radioMomentsHistoryStorage = Set(RadioMomentsHistory.prefix(10)).joined(separator: ",")
        
        
        
        driverFavoritesStorage = DriverFav.joined(separator: ",")
        teamFavoritesStorage = TeamFav.joined(separator: ",")
        rulesFavoritesStorage = RulesFav.joined(separator: ",")
        seasonFavoritesStorage = SeasonFav.joined(separator: ",")
        strategiesFavoritesStorage = StrategiesFav.joined(separator: ",")
        circuitsFavoritesStorage = CircuitsFav.joined(separator: ",")
        recordsFavoritesStorage = RecordsFav.joined(separator: ",")
        triviaFavoritesStorage = TriviaFav.joined(separator: ",")
        fanVotingFavoritesStorage = FanVotingFav.joined(separator: ",")
        techFavoritesStorage = TechFav.joined(separator: ",")
        radioMomentsFavoritesStorage  = RadioMomentsFav.joined(separator: ",")
        
        
      

        
    }
   // load
    func LoadSearcgBarInfos() {
        DriverHistory = Set(driverHistoryStorage.split(separator: ",").map { String($0) }.filter { !$0.isEmpty })
        TeamHistory = Set(teamHistoryStorage.split(separator: ",").map { String($0) }.filter { !$0.isEmpty })
        RulesHistory = Set((rulesHistoryStorage.split(separator: ",").map { String($0) }.filter { !$0.isEmpty }))
        SeasonHistory = Set((seasonHistoryStorage.split(separator: ",").map { String($0) }.filter { !$0.isEmpty }))
        StrategiesHistory = Set((strategiesHistoryStorage.split(separator: ",").map { String($0) }.filter { !$0.isEmpty }))
        CircuitsHistory = Set((circuitsHistoryStorage.split(separator: ",").map { String($0) }.filter { !$0.isEmpty }))
        RecordsHistory = Set((recordsHistoryStorage.split(separator: ",").map { String($0) }.filter { !$0.isEmpty }))
        TriviaHistory = Set((triviaHistoryStorage.split(separator: ",").map { String($0) }.filter { !$0.isEmpty }))
        FanVotingHistory = Set((fanVotingHistoryStorage.split(separator: ",").map { String($0) }.filter { !$0.isEmpty }))
        TechHistory = Set((techHistoryStorage.split(separator: ",").map { String($0) }.filter { !$0.isEmpty }))
        RadioMomentsHistory = Set((radioMomentsHistoryStorage.split(separator: ",").map { String($0) }.filter { !$0.isEmpty }))
        
        
        
        
        DriverFav = Set(driverFavoritesStorage.split(separator: ",").map { String($0) }.filter { !$0.isEmpty })
        TeamFav = Set(teamFavoritesStorage.split(separator: ",").map { String($0) }.filter { !$0.isEmpty })
        RulesFav = Set((rulesFavoritesStorage.split(separator: ",").map { String($0) }.filter { !$0.isEmpty }))
        SeasonFav = Set((seasonFavoritesStorage.split(separator: ",").map { String($0) }.filter { !$0.isEmpty }))
        StrategiesFav = Set((strategiesFavoritesStorage.split(separator: ",").map { String($0) }.filter { !$0.isEmpty }))
        CircuitsFav = Set((circuitsFavoritesStorage.split(separator: ",").map { String($0) }.filter { !$0.isEmpty }))
        RecordsFav = Set((recordsFavoritesStorage.split(separator: ",").map { String($0) }.filter { !$0.isEmpty }))
        TriviaFav = Set((triviaFavoritesStorage.split(separator: ",").map { String($0) }.filter { !$0.isEmpty }))
        FanVotingFav = Set((fanVotingFavoritesStorage.split(separator: ",").map { String($0) }.filter { !$0.isEmpty }))
        TechFav = Set((techFavoritesStorage.split(separator: ",").map { String($0) }.filter { !$0.isEmpty }))
        RadioMomentsFav = Set((radioMomentsFavoritesStorage.split(separator: ",").map { String($0) }.filter { !$0.isEmpty }))
        
    }
    
    
    var mergedHistory: Set<String> {
        return DriverHistory.union(TeamHistory).union(RulesHistory).union(SeasonHistory).union(StrategiesHistory).union(CircuitsHistory).union(RecordsHistory).union(TriviaHistory).union(FanVotingHistory).union(TechHistory).union(RadioMomentsHistory)
    }
    
    var mergedFav: Set<String> {
        return DriverFav.union(TeamFav).union(RulesFav).union(SeasonFav).union(StrategiesFav).union(CircuitsFav).union(RecordsFav).union(TriviaFav).union(FanVotingFav).union(TechFav).union(RadioMomentsFav)
    }
    
    

    func TeamColors(team: String) -> String {
        switch team {
        case "Ferrari":
            return "#DC0000" // Klassisches Ferrari-Rot
        case "McLaren":
            return "#FF8700" // Papaya-Orange
        case "McLaren (Marlboro)":
            return "#FF0000" // Marlboro-Rot
        case "Mercedes":
            return "#00D2BE" // Petronas-Türkis
        case "Red Bull Racing":
            return "#1E41FF" // Dunkelblau mit roten Akzenten
        case "Williams":
            return "#005AFF" // Königsblau
        case "Williams (Rothmans)":
            return "#0033A0" // Dunkelblau/Gold
        case "Lotus":
            return "#006400" // British Racing Green
        case "Lotus (Gold Leaf)":
            return "#FFD700" // Gold/Rot/Weiß
        case "Jordan":
            return "#FFD700" // Gelb/Schwarz
        case "Benetton":
            return "#00FF00" // Grün/Blau/Gelb
        case "Renault":
            return "#FFD700" // Gelb/Blau/Schwarz
        case "Renault (ING)":
            return "#FF6600" // Orange/Weiß
        case "BAR":
            return "#FFFFFF" // Weiß/Rot/Blau
        case "Sauber":
            return "#00D2BE" // Petronas-Türkis
        case "Alfa Romeo":
            return "#900000" // Dunkelrot
        case "AlphaTauri":
            return "#2B2D42" // Dunkelblau/Weiß
        case "Toro Rosso":
            return "#0000FF" // Blau/Rot
        case "Force India":
            return "#FF6600" // Orange/Weiß/Grün
        case "Racing Point":
            return "#F596C8" // Pink/Blau
        case "Aston Martin":
            return "#006F62" // Dunkelgrün
        case "Haas":
            return "#FFFFFF" // Weiß/Rot/Schwarz
        case "Brawn GP":
            return "#FFFF00" // Weiß/Neon-Gelb
        case "Toyota":
            return "#EB0A1E" // Rot/Weiß
        case "Jaguar":
            return "#006F62" // Dunkelgrün
        case "Minardi":
            return "#000000" // Schwarz/Gelb
        case "Arrows":
            return "#FF8000" // Orange
        case "Prost":
            return "#0000FF" // Blau
        case "Ligier":
            return "#1E90FF" // Hellblau
        case "Tyrrell":
            return "#0000FF" // Blau
        case "Brabham":
            return "#000080" // Dunkelblau
        case "March":
            return "#FF69B4" // Pink/Orange
        case "Shadow":
            return "#000000" // Schwarz
        case "Surtees":
            return "#FFFFFF" // Weiß/Blau
        case "Matra":
            return "#1E90FF" // Blau
        case "Vanwall":
            return "#006400" // Dunkelgrün
        case "Cooper":
            return "#006400" // Dunkelgrün
        case "BRM":
            return "#006400" // Dunkelgrün
        case "Eagle":
            return "#FFFFFF" // Weiß/Blau
        case "Penske":
            return "#FFFFFF" // Weiß/Blau
        case "HRT":
            return "#A9A9A9" // Grau/Gold
        case "Caterham":
            return "#006400" // Dunkelgrün
        case "Marussia":
            return "#FF0000" // Rot/Schwarz
        case "Manor":
            return "#FF4500" // Orange/Blau
        case "None":
            return "#823943" 
        default:
            return "#808080" // Grau als Fallback
        }
    }

    func ShowFavorite(topic: String) -> [String] {
        switch topic {
        case "Driver":
            return Array(DriverFav)
        case "Team":
            return Array(TeamFav)
        case "Rules":
            return Array(RulesFav)
        case "Season":
            return Array(SeasonFav)
        case "Strategies":
            return Array(StrategiesFav)
        case "Circuits":
            return Array(CircuitsFav)
        case "Records":
            return Array(RecordsFav)
        case "Trivia":
            return Array(TriviaFav)
        case "FanVoting":
            return Array(FanVotingFav)
        case "Tech":
            return Array(TechFav)
        case "RadioMoments":
            return Array(RadioMomentsFav)
        default:
            print("Unbekanntes Thema: \(topic)")
            return []
        }
    }

    func ShowHistory(topic: String) -> [String] {
        switch topic {
        case "Driver":
            return Array(DriverHistory)
        case "Team":
            return Array(TeamHistory)
        case "Rules":
            return Array(RulesHistory)
        case "Season":
            return Array(SeasonHistory)
        case "Strategies":
            return Array(StrategiesHistory)
        case "Circuits":
            return Array(CircuitsHistory)
        case "Records":
            return Array(RecordsHistory)
        case "Trivia":
            return Array(TriviaHistory)
        case "FanVoting":
            return Array(FanVotingHistory)
        case "Tech":
            return Array(TechHistory)
        case "RadioMoments":
            return Array(RadioMomentsHistory)
        default:
            print("Unbekanntes Thema: \(topic)")
            return []
        }
       
        
    }


    func addFavorite(value: String, topic: String) {
        switch topic {
        case "Driver":
            DriverFav.insert(value)
        case "Team":
            TeamFav.insert(value)
        case "Rules":
            RulesFav.insert(value)
        case "Season":
            SeasonFav.insert(value)
        case "Strategies":
            StrategiesFav.insert(value)
        case "Circuits":
            CircuitsFav.insert(value)
        case "Records":
            RecordsFav.insert(value)
        case "Trivia":
            TriviaFav.insert(value)
        case "FanVoting":
            FanVotingFav.insert(value)
        case "Tech":
            TechFav.insert(value)
        case "RadioMoments":
            RadioMomentsFav.insert(value)
        default:
            print("Invalid Topic: \(topic)")
        }
    
        saveSearchBarInfos()
        LoadSearcgBarInfos()
    }
    func addHistory(value: String, topic: String) {
        switch topic {
        case "Driver":
            DriverHistory.insert(value)
        case "Team":
            TeamHistory.insert(value)
        case "Rules":
            RulesHistory.insert(value)
        case "Season":
            SeasonHistory.insert(value)
        case "Strategies":
            StrategiesHistory.insert(value)
        case "Circuits":
            CircuitsHistory.insert(value)
        case "Records":
            RecordsHistory.insert(value)
        case "Trivia":
            TriviaHistory.insert(value)
        case "FanVoting":
            FanVotingHistory.insert(value)
        case "Tech":
            TechHistory.insert(value)
        case "RadioMoments":
            RadioMomentsHistory.insert(value)
        default:
            print("Unbekanntes Thema: \(topic)")
        }
        saveSearchBarInfos()
        LoadSearcgBarInfos()
    }


    func removeHistory(value: String, topic: String) {
        switch topic {
        case "Driver":
            DriverHistory.remove(value)
        case "Team":
            TeamHistory.remove(value)
        case "Rules":
            RulesHistory.remove(value)
        case "Season":
            SeasonHistory.remove(value)
        case "Strategies":
            StrategiesHistory.remove(value)
            
        case "Circuits":
            CircuitsHistory.remove(value)
        case "Records":
            RecordsHistory.remove(value)
        case "Trivia":
            TriviaHistory.remove(value)
        case "FanVoting":
            FanVotingHistory.remove(value)
        case "Tech" :
            TechHistory.remove(value)
        case "RadioMoments" :
            RadioMomentsHistory.remove(value)
        default:
            print("Unbekannte Kategorie \(topic)")
        }
        saveSearchBarInfos()
        LoadSearcgBarInfos()
    }
        
    func removeFavorite(value: String, topic: String) {
            switch topic {
            case "Driver":
                DriverFav.remove(value)
            case "Team":
                TeamFav.remove(value)
            case "Rules":
                RulesFav.remove(value)
            case "Season":
                SeasonFav.remove(value)
            case "Strategies":
                StrategiesFav.remove(value)
            case "Circuits":
                CircuitsFav.remove(value)
            case "Records":
                RecordsFav.remove(value)
            case "Trivia":
                TriviaFav.remove(value)
            case "FanVoting":
                FanVotingFav.remove(value)
            case "Tech" :
                TechFav.remove(value)
            case "RadioMoments" :
                RadioMomentsFav.remove(value)
            
            default:
                print("Unbekannte Kategorie \(topic)")
            }
            saveSearchBarInfos()
            LoadSearcgBarInfos()
        }
    func TextChanger(OptionEn: String, OptionGe: String, OptionSp: String, OptionFr: String) -> String {
        switch selectedLanguage {
        case .en:
            return OptionEn
        case .ge:
            return OptionGe
        case .sp:
            return OptionSp
        case .fr:
            return OptionFr
        }
    }

  
    func updateNotifications(_ newNotifications: Bool) {
        guard let user = Auth.auth().currentUser else {
            print("Kein eingeloggter Nutzer.")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).updateData([
            "Notifications": newNotifications
        ]) { error in
            if let error = error {
                print("Fehler beim Aktualisieren: \(error.localizedDescription)")
            } else {
                print("Benachrichtigungen erfolgreich geändert.")
                DispatchQueue.main.async {
                    self.Notifications = newNotifications
                }
            }
        }
    }
    
    
    
    func updateUsername(to newName: String) {
        guard let user = Auth.auth().currentUser else {
            print("Kein eingeloggter Nutzer.")
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(user.uid).updateData([
            "Username": newName
        ]) { error in
            if let error = error {
                print("Fehler beim Aktualisieren: \(error.localizedDescription)")
            } else {
                print("Benutzername erfolgreich geändert zu: \(newName)")
                DispatchQueue.main.async {
                    self.username = newName
                }
            }
        }
    }

    func updateLanguage(to newLanguage: Language) {
        guard let user = Auth.auth().currentUser else {
            print("Kein eingeloggter Nutzer.")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).updateData([
            "Language": newLanguage.rawValue
        ]) { error in
            if let error = error {
                print("Fehler beim Aktualisieren: \(error.localizedDescription)")
            } else {
                print("Sprache erfolgreich geändert zu: \(newLanguage.rawValue)")
                DispatchQueue.main.async {
                    self.selectedLanguage = newLanguage
                }
            }
        }
    }
    
    func updateColorPreset(to newColorPreset: Int) {
        guard let user = Auth.auth().currentUser else {
            print("Kein eingeloggter Nutzer.")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).updateData([
            "ColorPreset": newColorPreset
        ]) { error in
            if let error = error {
                print("Fehler beim Aktualisieren: \(error.localizedDescription)")
            } else {
                print("Farbspiegel erfolgreich geändert zu: \(newColorPreset)")
                DispatchQueue.main.async {
                    self.ColorPreset = newColorPreset
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    func loadUserData() {
        guard let user = Auth.auth().currentUser else {
                print("Kein eingeloggter Nutzer.")
                return
            }
            
            let db = Firestore.firestore()
        
        db.collection("users").document(user.uid).getDocument { document, error in
            if let data = document?.data() {
                self.username = data["Username"] as? String
                self.selectedLanguage = Language(rawValue: data["Language"] as? String ?? "en") ?? .en
                self.userEmail = data["Email"] as? String
                self.ColorPreset = data["ColorPreset"] as? Int ?? 0
                self.AccountCreated = data["CreatedAt"] as? Timestamp ?? Timestamp()
                self.Notifications = data["Notifications"] as? Bool ?? false
                self.SelectedView = data["SelectedView"] as? String ?? "Driver"
         
            } else if let error = error {
                print("Fehler beim Abrufen der Daten: \(error.localizedDescription)")
            }
        }
    }
    
   
    
    func saveToken(_ token: String) {
        guard let tokenData = token.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "authToken",
            kSecValueData as String: tokenData
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    
    
    func loadToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "authToken",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    
    
    func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "authToken"
        ]
        SecItemDelete(query as CFDictionary)
    }
    
    
    
    func logIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error as NSError?, let errCode = AuthErrorCode(rawValue: error.code) {
                    switch errCode {
                    case .userNotFound:
                        self.errorMessage = "Kein Account mit dieser E-Mail gefunden."
                    case .wrongPassword:
                        self.errorMessage = "Falsches Passwort."
                    case .invalidEmail:
                        self.errorMessage = "Ungültige E-Mail-Adresse."
                    default:
                        self.errorMessage = error.localizedDescription
                    }
                    completion(false)
                } else if let user = result?.user {
                    self.userEmail = user.email
                    user.getIDToken { token, error in
                        if let token = token {
                            self.saveToken(token)
                            //self.isLoggedIn = true
                            completion(true)
                        } else {
                            self.errorMessage = "Tokenfehler: \(error?.localizedDescription ?? "Unbekannt")"
                            completion(false)
                        }
                    }
                }
            }
        }
    }


    
    
    func signUp(email: String, password: String, username: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    print("❌ Fehler bei createUser: \(error.localizedDescription)")
                } else if let user = result?.user {
                    self.userEmail = user.email
                    self.errorMessage = nil
                    print("✅ User erfolgreich erstellt")
                    
                    user.getIDToken { token, error in
                        if let token = token {
                            self.saveToken(token)
                            self.isLoggedIn = true
                            print("✅ Token gespeichert in Keychain")
                        } else if let error = error {
                            self.errorMessage = "Tokenfehler: \(error.localizedDescription)"
                            print("❌ Token konnte nicht abgerufen werden: \(error.localizedDescription)")
                        }
                    }

                    let db = Firestore.firestore()
                    let userData: [String: Any] = [
                        "Username": username,
                        "Email": user.email ?? "",
                        "CreatedAt": Timestamp(date: Date()),
                        "Language": "en",
                        "ColorPreset": "1"
                        
                    ]
                    db.collection("users").document(user.uid).setData(userData) { error in
                        if let error = error {
                            print("❌ Firestore Fehler: \(error.localizedDescription)")
                        } else {
                            print("✅ Firestore OK für \(username)")
                            db.collection("users").document(user.uid).getDocument { document, error in
                                if let document = document, document.exists {
                                    let data = document.data()
                                    self.username = data?["username"] as? String
                                    print("👤 Username geladen: \(self.username ?? "-")")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
    
    func percentWidth(_ value: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.width * value
    }
    func percentHeight(_ value: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.height * value
    }
    
    

    
    enum Language: String, CaseIterable {
        case en, ge, sp, fr
    }
    
    enum Tab {
        case roster, stats , races, settings, house
    }
    
    enum PrimaryColor: String {
    case blue, green, yellow, red

    var color: Color {
        switch self {
        case .blue: return .blue
        case .green: return .green
        case .yellow: return .yellow
        case .red: return .red
        }
    }
}

  
enum selectedOption {
    case Favorites, Search, History
}

