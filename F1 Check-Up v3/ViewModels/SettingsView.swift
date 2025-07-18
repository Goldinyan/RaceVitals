//struct SettingsView: View {



import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var LanguageManager: LanguageManager
    @AppStorage("NotificationEnabled") private var Notification = false
    @AppStorage("DarkModeEnabled") private var DarkMode = false

    var body: some View {
        NavigationStack {
            
        
        VStack(alignment: .leading, spacing: 0) {
            
            HStack {
                Text("F1 Check-Up v3")
                    .font(.system(size: 30, weight: .bold, design: .serif))
                    .foregroundColor(.white)
                    .padding(.leading, 20)
                    .padding(.bottom, 10)
                    .padding(.top, 10)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 80)
            .background(Color.red)
            
            HStack {
                Text("Settings")
                    .font(.system(size: 26, weight: .bold, design: .serif))
                    .foregroundColor(.white)
                    .padding(.leading, 10)
                    .padding(.top, 10)
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(hex: "#111827"))
            
            
           // languageManager.SelectedLanguage
            
            // Erster Block
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "bell")
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
                    Text("Notifications")
                        .font(.system(size: 22, weight: .regular, design: .serif))
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                    Spacer()
                    Button {
                        withAnimation(.easeInOut(duration: 2)) {
                            Notification.toggle()
                        }
                    } label: {
                        if !Notification {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.white)
                                .padding(5)
                                .padding(.trailing, 30)
                                .background(Color(hex: "#4B5563"))
                                .cornerRadius(20)
                                .transition(.scale)
                                
                        } else {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.white)
                                .padding(5)
                                .padding(.leading, 30)
                                .background(Color.red)
                                .cornerRadius(20)
                                .transition(.scale)
                            
                        }
                    }
                    .overlay(
                        Rectangle()
                            .frame(width: 700, height: 2)
                            .foregroundStyle(Color(hex: "#374151"))
                            .offset(y: 30),
                        alignment: .center
                    )
                }
                .padding()
                
                HStack {
                    Image(systemName: "globe")
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
                    Text("Language")
                        .font(.system(size: 22, weight: .regular, design: .serif))
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                    Spacer()
                   

                 
                        
                    Menu {
                        ForEach(Language.allCases, id: \.self) { language in
                            Button(action: {
                                LanguageManager.selectedLanguage = language
                            }) {
                                Text(language.rawValue)
                                    .foregroundColor(.white)
                            }
                        }
                    } label: {
                        Text("\(LanguageManager.selectedLanguage.rawValue)  >")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold, design: .serif))
                    }
                    .padding(.horizontal)
                    .padding(.vertical,5)
                    .background(Color(hex: "#374151"))
                    .cornerRadius(10)
                    



                            
                        
                        
                        
                    
                    .overlay(
                        Rectangle()
                            .frame(width: 700, height: 2)
                            .foregroundStyle(Color(hex: "#374151"))
                            .offset(y: 30),
                        alignment: .center
                    )
                }
                .padding()
                
                HStack {
                    Image(systemName: "moon")
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
                    Text("Dark Mode")
                        .font(.system(size: 22, weight: .regular, design: .serif))
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                    Spacer()
                    Button {
                        withAnimation(.easeInOut(duration: 2)) {
                            DarkMode.toggle()
                        }
                    } label: {
                        if !DarkMode {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.white)
                                .padding(5)
                                .padding(.trailing, 30)
                                .background(Color(hex: "#4B5563"))
                                .cornerRadius(20)
                                .transition(.scale)
                                
                        } else {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.white)
                                .padding(5)
                                .padding(.leading, 30)
                                .background(Color.red)
                                .cornerRadius(20)
                                .transition(.scale)
                            
                        }
                    }

                }
                .padding()
            }
            .padding(.horizontal)
            .background(Color(hex: "#1F2937"))
            .cornerRadius(20)
            .padding()
            
            // Zweiter Block
            VStack(spacing: 0) {
                NavigationLink(destination: AboutView()) {
                
                HStack {
                    Image(systemName: "info.circle")
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
                    Text("About")
                        .font(.system(size: 22, weight: .regular, design: .serif))
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                    Spacer()
                    Button {
                        // Aktion
                    } label: {
                        Image(systemName: "arrow.right")
                            .foregroundStyle(Color.white)
                    }
                    .overlay(
                        Rectangle()
                            .frame(width: 700, height: 2)
                            .foregroundStyle(Color(hex: "#374151"))
                            .offset(y: 30),
                        alignment: .center
                    )
                    
                  
                        
                    
                    
                    
                }
                .padding()
                }
                
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 22))
                        .foregroundColor(.red)
                    Text("Sign Out")
                        .font(.system(size: 22, weight: .regular, design: .serif))
                        .foregroundColor(.red)
                        .padding(.leading, 10)
                    Spacer()
                    
                }
                .padding()
                
                
            }
            .padding(.horizontal)
            .background(Color(hex: "#1F2937"))
            .cornerRadius(20)
            .padding()
            
            
            HStack {
                Spacer()
                Text("F1 Check-Up v3.0")
                    .font(.system(size: 20, weight: .regular, design: .serif))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.top, 10)
            .padding(.bottom, 180)
        }
        .background(Color(hex: "#111827"))
    }
   

    
    
}

struct AboutView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // App Logo
            Image("AppIcon") // Dein App-Logo hier einfügen
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.top, 30)
                .padding(.bottom, 10)
            
            // App Name & Version
            Text("F1 Check-Up v3")
                .font(.system(size: 28, weight: .bold, design: .serif))
                .foregroundColor(.white)
            
            Text("Version 3.0.1 (Build 45)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Divider()
                .background(Color.gray)
            
            // About Text
            Text("F1 Check-Up is your personal companion for Formula 1. All teams, drivers, races, and statistics — always up to date, always clear and easy to navigate.")
                .font(.body)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold, design: .serif))
            
            Divider()
                .background(Color.gray)
            
            // Developer Info
            VStack(alignment: .leading, spacing: 5) {
                Text("Entwickelt von")
                    .font(.headline)
                    .foregroundColor(.gray)
                Text("Goldinyan")
                    .font(.title3)
                    .foregroundColor(.white)
            }
            
            Divider()
                .background(Color.gray)
            
            // Links
            VStack(alignment: .leading, spacing: 10) {
                Link("🌐 Website", destination: URL(string: "https://f1checkup.example.com")!)
                    .foregroundColor(.blue)
                Link("📧 Support", destination: URL(string: "mailto:support@f1checkup.example.com")!)
                    .foregroundColor(.blue)
            }
            
            Spacer()
        }
        .padding()
        .background(Color( hex: "#111827").edgesIgnoringSafeArea(.all))
    }
    }
}


    
    
    
    
    #Preview {
        ContentView()
            .environmentObject(TabManager())
            .environmentObject(LanguageManager())

        
    }

