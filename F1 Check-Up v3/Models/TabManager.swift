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

class AppState: ObservableObject {
    @Published var selectedLanguage: Language = .English
    @Published var selectedTab: Tab = .roster
    @Published var userEmail: String?
    @Published var errorMessage: String?
    @Published var EndStartView: Bool = false
    @Published var username: String?
    @Published var isLoggedIn: Bool = false
    @Published var SequenceBeforeDriver: Bool = false
    @Published var ShowSplash : Bool = true
    @Published var AccountCreated = Timestamp()
    @Published var ColorPreset: Int = 0
    @Published var CollerPickerShow = false
    
    
    
    
  
    
    
    
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
                self.selectedLanguage = Language(rawValue: data["Language"] as? String ?? "English") ?? .English
                self.userEmail = data["Email"] as? String
                self.ColorPreset = data["ColorPreset"] as? Int ?? 0
                self.AccountCreated = data["CreatedAt"] as? Timestamp ?? Timestamp()
                
                for _ in 0...5 {
                    print("")
                }
                print("----Load-User-Data-----")
                print("Username: \(self.username ?? "N/A")")
                print("Sprache: \(self.selectedLanguage.rawValue)")
                print("Preset: \(self.ColorPreset)")
                print(self.AccountCreated)
                print("Email: \(self.userEmail ?? "N/A")")
                print("-----------------------")
                print("Raw Data: \(document?.data() ?? [:])")
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
                            self.isLoggedIn = true
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
        case English, German, Spanish, French
    }
    
    enum Tab {
        case roster, stats , races, settings
    }
    
    enum PrimaryColor: String {
    case blue, green, yellow, red
}

    enum SecondaryColor: String {
    case blue, green, yellow, red
}

    enum TertiaryColor: String {
    case blue, green, yellow, red
}
 
    enum Font: String {
    case regular, medium, bold
}

    

