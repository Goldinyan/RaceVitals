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
    
    
    func saveToken(_ token: String) {
        guard let tokenData = token.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "authToken",
            kSecValueData as String: tokenData
        ]
        
        SecItemDelete(query as CFDictionary) // Überschreibt alte Werte
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
    
    
    
    func logIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else if let user = result?.user {
                    self.userEmail = user.email
                    
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
                        "username": username,
                        "email": user.email ?? "",
                        "createdAt": Timestamp(date: Date())
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
    
    

