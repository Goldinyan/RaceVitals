import SwiftUI

// 🌊 Sanfte Wellenform
struct OceanWave: Shape {
    var phase: CGFloat
    var amplitude: CGFloat
    var frequency: CGFloat

    var animatableData: AnimatablePair<AnimatablePair<CGFloat, CGFloat>, CGFloat> {
        get { .init(.init(phase, amplitude), frequency) }
        set {
            phase = newValue.first.first
            amplitude = newValue.first.second
            frequency = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let midHeight = amplitude

        path.move(to: CGPoint(x: 0, y: midHeight))
        for x in stride(from: 0, through: width, by: 1) {
            let angle = (x / width) * .pi * 2 * frequency + phase
            let y = sin(angle) * amplitude + midHeight - height * 5.5
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        return path
    }
}

// 🏁 Haupt-View
struct StartView: View {
    @State private var showLogin = false
    @State private var showSignUp = false
    @State private var phase: CGFloat = 0
    @State private var amplitude: CGFloat = 12
    @State private var frequency: CGFloat = 1.2
    @State private var shiftUp = false
    @EnvironmentObject private var AppState: AppState
    let darkRed = Color(red: 0.5, green: 0.0, blue: 0.0)
    let brightRed = Color(red: 1.0, green: 0.2, blue: 0.2)
    let idk = Color(red: 1.0, green: 0.7, blue: 0.4)

    
    
    var body: some View {
        ZStack {
            LinearGradient(
                      gradient: Gradient(colors: [darkRed, brightRed]),
                      startPoint: .leading,
                      endPoint: .trailing
              )
              .ignoresSafeArea()
              .zIndex(-1)
            
            VStack(spacing: 0) {
            
            
                VStack(spacing: 0) {
                    Image("LoginImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 400, height: 400)
                        .padding(.top, 80)
                    
                                   
                    OceanWave(phase: phase, amplitude: amplitude, frequency: frequency)
                        .fill( LinearGradient( gradient: Gradient(colors: [darkRed, brightRed]), startPoint: .leading, endPoint: .trailing ) )
                        .frame(height: 20)
                        .background(Color.green)
                        
                }
               
                .position(x: UIScreen.main.bounds.width / 2, y: shiftUp ? -600 : 100)
                .animation(.easeInOut(duration: 2), value: shiftUp)

                
                VStack {
                    if showLogin {
                        LoginView(showSignUp: $showSignUp, showLogin: $showLogin, shiftUp: $shiftUp)
                           

                    } else if showSignUp  {
                        SignUpView(showLogin: $showLogin, showSignUp: $showSignUp)
                    } else {
                        WelcomeScreen(
                            onLoginTap: { showLogin = true; showSignUp = false },
                            onSignUpTap: { showSignUp = true; showLogin = false },
                            shiftUp: $shiftUp
                        )
                        
                    }
                }
                .padding(.bottom , 30)
                
                
               
            }
            
        }
        .ignoresSafeArea()
        .onAppear {
            let waveAnimation = Animation.easeInOut(duration: 8).repeatForever(autoreverses: true)
            withAnimation(waveAnimation) {
                amplitude = 25
                frequency = 1.6
                phase = .pi * 2
            }
        }
        
        
        
        
    }
}
// 🎉 Begrüßungsseite
struct WelcomeScreen: View {
    var onLoginTap: () -> Void
    var onSignUpTap: () -> Void
    @State private var isPressed = false
    @Binding var shiftUp: Bool
    let darkRed = Color(red: 0.5, green: 0.0, blue: 0.0)
    let brightRed = Color(red: 1.0, green: 0.2, blue: 0.2)
    

    
    var body: some View {
        
        ZStack{
            LinearGradient(
                      gradient: Gradient(colors: [darkRed, brightRed]),
                      startPoint: .leading,
                      endPoint: .trailing
              )
              .ignoresSafeArea()
        
        VStack(spacing: 15) {
            Text("Welcome")
                .font(.system(size: 50, weight: .bold, design: .default))
                .foregroundColor(.white)
                .padding(.bottom, 20)

            Text("Stats, calendars, and race history")
                .font(.system(size: 20, design: .serif))
                .foregroundColor(.white.opacity(0.85))

            Text("built for true F1 fans.")
                .font(.system(size: 20, design: .serif))
                .foregroundColor(.white.opacity(0.85))
                .padding(.bottom, 40)

            Button("Login") {
                isPressed = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeInOut(duration: 4.8)) {
                        shiftUp = true
                    }
                }

                onLoginTap()
            }
                .font(.system(size: 18, weight: .bold, design: .default))
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                            gradient: Gradient(colors: [brightRed, darkRed]),
                            startPoint: .trailing,
                            endPoint: .leading
                            )
                        )
                        //.shadow(color: .red.opacity(0.5), radius: 10, x: 0, y: 5)
                )
                .foregroundColor(.white)
                .scaleEffect(isPressed ? 1.05 : 1)
                .animation(.spring(), value: isPressed)

            Button("Sign Up", action: onSignUpTap)
                .font(.system(size: 18, weight: .bold, design: .serif))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(10)
            Spacer()
                .frame(height: UIScreen.main.bounds.height * 0.1)
        }
        .padding()
        }
    }
}

struct LoginView: View {
    @Binding var showSignUp: Bool
    @Binding var showLogin: Bool
    @State private var showPassword = false
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var AppState: AppState
    @State private var showAmpel = false
    @State private var ampelPhase = 0
    @State private var welcomeOffset: CGFloat = 0
    let darkRed = Color(red: 0.5, green: 0.0, blue: 0.0)
    let brightRed = Color(red: 1.0, green: 0.2, blue: 0.2)
    @State private var Ampel: Int  = 7
    @State private var currentImageIndex = 0
    @State private var sequencefinished = false
    @Binding var shiftUp: Bool
    @State private var appOpacity: Double = 0.0
    @State private var carDrive : Bool = false
    @State private var dontlogin : Bool = true
   
    
    @State private var errorMessage: String?
    @State private var showerror = false
    
    
    
    
    
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [darkRed, brightRed]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .ignoresSafeArea()
            
            VStack {
                
             
          
                
                
               VStack {
                    
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill( LinearGradient( gradient: Gradient(colors: [darkRed, brightRed]), startPoint: .leading, endPoint: .trailing ) )                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 2)
                        )
                    
                    if email.isEmpty {
                        Text("Email")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.system(size: 18, weight: .bold, design: .serif))
                            .padding(.leading, 16)
                    }
                    HStack{
                        TextField("", text: $email)
                            .font(.system(size: 18, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                            .accentColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .autocapitalization(.none)
                        
                        
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 60)
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
                
                
                ZStack(alignment: .leading) {
                    // Hintergrund
                    RoundedRectangle(cornerRadius: 10)
                        .fill( LinearGradient( gradient: Gradient(colors: [darkRed, brightRed]), startPoint: .leading, endPoint: .trailing ) )                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                        )
                    
                    // Placeholder manuell anzeigen
                    if password.isEmpty {
                        Text("Password")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.system(size: 18, weight: .bold, design: .serif))
                            .padding(.leading, 16)
                    }
                    
                    // Eingabe-Feld (je nach Sichtbarkeit)
                    HStack {
                        Group {
                            if showPassword {
                                TextField("", text: $password)
                            } else {
                                SecureField("", text: $password)
                            }
                        }
                        .foregroundColor(.white)
                        .accentColor(.white)
                        .font(.system(size: 18, weight: .bold, design: .serif))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        
                        // Toggle-Button (Auge)
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: !showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.trailing, 16)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 60)
                .padding(.horizontal, 40)
                
                HStack {
                    
                    Spacer()
                    Text("Forgot Password?")
                        .font(.system(size: 16, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                        .padding(.trailing, 42)
                        .padding(.top, 10)
                }
                   if showerror{
                       Text(AppState.errorMessage ??  "")
                           .foregroundStyle(.white)
                           .font(.system(size: 14, weight: .bold, design: .serif))
                   }
                   Button {
                            showerror = true
                           AppState.logIn(email: email, password: password) { success in
                               if success {
                                    AppState.loadUserData ()
                                   
                                   
                                   DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                       AppState.isLoggedIn = true

                                   }
                                  
                               }
                           }
                       
                   } label: {
                       
                           Text("Login")
                               .font(.system(size: 18, weight: .bold, design: .serif))
                               .foregroundColor(.black)
                               .frame(maxWidth: .infinity, maxHeight: 40)
                               .padding()
                               .background(Color.white)
                               .cornerRadius(10)
                               .padding(.horizontal, 60)
                               .padding(.top, 30)
                       
                }
                   
                
                
                
                
                HStack{
                    Spacer()
                    Text("Don't have an account?")
                        .font(.system(size: 16, weight: .regular, design: .serif))
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .padding(.trailing, 20)
                    
                }
                .padding(.top, 20)
                HStack{
                    
                    Spacer()
                    Button(action: {
                        showSignUp = true
                        showLogin = false
                    }) {
                        Text("Sign Up")
                            .font(.system(size: 18, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, 20)
                    
                    
                    
                    
                }
                   
                 
                   
                   
                   
                }
               .position(
                   x: UIScreen.main.bounds.width / 2,
                   y: carDrive
                       ? -900
                       : (sequencefinished ? -100 : 900)
               )
               .animation(.easeInOut(duration: 3), value: carDrive || sequencefinished)
                
                
                VStack(spacing: 0){
                    Image("F1Car")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width * 0.7)
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.7 )
                    VStack(spacing: 0) {
                        ZStack {
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [darkRed, brightRed]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.clear, .black]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                                .blendMode(.multiply) // oder .overlay je nach Look
                             
                             }
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 1.5)
                    }
                    .zIndex(1)
                }
                    .position(
                        x: UIScreen.main.bounds.width / 2,
                        y: carDrive
                            ? -1100
                            : (sequencefinished ? 1300 : 1500)
                    )
                    .animation(.easeInOut(duration: 5), value: carDrive || sequencefinished)
                     

           
              
            }
            
            
          
        }
        
    }
}
struct SignUpView: View {
    @Binding var showLogin: Bool
    @Binding var showSignUp: Bool
    @EnvironmentObject var AppState: AppState
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var confirmPassword = ""
    @State private var isPressed: Bool = false
 /*   func SignUp() {
        if !(UserNameSignUp.count > 3) {
            error = "Username is required"
        } else if !(11 > UserNameSignUp.count ) {
            error = "Username too long"
        } else if !(UserEmailSignUp.contains("@")) {
            error = "Invalid Email"
        } else if UserPasswordSignUp != UserConfirmPasswordSignUp {
            error = "Passwords do not match"
        } else if UserPasswordSignUp.isEmpty || UserConfirmPasswordSignUp.isEmpty {
            error = "Password cannot be empty"
        }else if AppState.AccountUserNames.contains(UserNameSignUp) {
            error = "Username already taken"
        } else {
            showLogin = false
            showSignUp = false
            AppState.AccountUserNames.append(UserNameSignUp)
            AppState.AccountEmails.append(UserEmailSignUp)
            AppState.AccountPasswords.append(UserPasswordSignUp)
            AppState.currentEmail = UserEmailSignUp
            UserNameSignUp = ""
            UserEmailSignUp = ""
            UserPasswordSignUp = ""
            UserConfirmPasswordSignUp = ""
        }
        
    } */
    
    func approved() {
        print("approved")
    }
    var body: some View {
        ZStack{
            VStack(spacing: 20) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.red)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 2)
                        )
                    
                    if username.isEmpty {
                        Text("Username")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.system(size: 18, weight: .bold, design: .serif))
                            .padding(.leading, 16)
                    }
                    HStack{
                        TextField("", text: $username)
                            .font(.system(size: 18, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                            .accentColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                       
                            
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 60)
                .padding(.horizontal, 20)
                .padding(.bottom, 5)
                

                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.red)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 2)
                        )
                    
                    if email.isEmpty {
                        Text("Email")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.system(size: 18, weight: .bold, design: .serif))
                            .padding(.leading, 16)
                    }
                    HStack{
                        TextField("", text: $email)
                            .font(.system(size: 18, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                            .accentColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                       
                            
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 60)
                .padding(.horizontal, 20)
                .padding(.bottom, 5)
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.red)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 2)
                        )
                    
                    if password.isEmpty {
                        Text("Email")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.system(size: 18, weight: .bold, design: .serif))
                            .padding(.leading, 16)
                    }
                    HStack{
                        TextField("", text: $password)
                            .font(.system(size: 18, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                            .accentColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                       
                            
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 60)
                .padding(.horizontal, 20)
                .padding(.bottom, 5)
                

                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.red)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 2)
                        )
                    
                    if confirmPassword.isEmpty {
                        Text("Email")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.system(size: 18, weight: .bold, design: .serif))
                            .padding(.leading, 16)
                    }
                    HStack{
                        TextField("", text: $confirmPassword)
                            .font(.system(size: 18, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                            .accentColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                       
                            
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 60)
                .padding(.horizontal, 20)
                .padding(.bottom, 5)
                

                
                
                
                
                Button(action: {
                    AppState.signUp(email: email, password: password, username: username)
                    approved()                }) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            Capsule()
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                        )
                        .scaleEffect(isPressed ? 1.05 : 1.0)
                        .animation(.spring(), value: isPressed)
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in isPressed = true }
                        .onEnded { _ in isPressed = false }
                )

                
                Spacer()
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.white)
                    Button("Log In") {
                        showLogin = true
                        showSignUp = false
                    }
                    .foregroundColor(.yellow)
                    .bold()
                }
                .font(.footnote)

            }
            .padding()
            .background(Color.red)
           

        }
        .background(Color.red)
    }
}



#Preview {
    ContentView()
        .environmentObject(AppState())
    

}


    

