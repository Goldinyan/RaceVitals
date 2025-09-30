import SwiftUI

// Wellenform
struct OceanWave: Shape {
    var phase: CGFloat
    var amplitude: CGFloat
    var frequency: CGFloat

    var animatableData:
        AnimatablePair<AnimatablePair<CGFloat, CGFloat>, CGFloat>
    {
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

    func ShiftingViews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 4.8)) {
                shiftUp = true
            }
        }
    }
    var body: some View {
        GeometryReader { geo in
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
                            .frame(
                                width: geo.size.width,
                                height: geo.size.width
                            )
                            .offset(y: -geo.size.height * 0.1)

                        OceanWave(
                            phase: phase,
                            amplitude: amplitude,
                            frequency: frequency
                        )
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [darkRed, brightRed]
                                ),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: geo.size.height * 0.04)

                    }

                    .offset(y: shiftUp ? -UIScreen.main.bounds.height * 1 : 0)
                    .animation(.easeInOut(duration: 2), value: shiftUp)

                    VStack {

                        VStack {

                            WelcomeScreen(
                                onLoginTap: {
                                    showLogin = true
                                    showSignUp = false
                                    ShiftingViews()
                                },
                                onSignUpTap: {
                                    showSignUp = true
                                    showLogin = false
                                    ShiftingViews()
                                },
                                shiftUp: $shiftUp
                            )

                        }
                        .frame(height: UIScreen.main.bounds.height * 0.6)
                        //           .padding(.top, UIScreen.main.bounds.height * 0.4)
                        .offset(
                            y: shiftUp
                                ? -UIScreen.main.bounds.height * 1
                                : -UIScreen.main.bounds.height * 0.1
                        )
                        .animation(.easeInOut(duration: 2), value: shiftUp)

                        FlipCard(showLogin: $showLogin, showSignUp: $showSignUp)
                            .frame(height: UIScreen.main.bounds.height * 0.8)
                            .offset(
                                y: shiftUp ? -UIScreen.main.bounds.height : 0
                            ).animation(.easeInOut(duration: 2), value: shiftUp)

                    }
                }

            }
            .ignoresSafeArea()
            .onAppear {
                let waveAnimation = Animation.easeInOut(duration: 8)
                    .repeatForever(autoreverses: true)
                withAnimation(waveAnimation) {
                    amplitude = 25
                    frequency = 1.6
                    phase = .pi * 2
                }
            }

        }
    }
}

struct FlipCard: View {
    @Binding var showLogin: Bool
    @Binding var showSignUp: Bool
    @State private var flipped = false

    var body: some View {
        ZStack {
            // Vorderseite: Login
            LoginViewOverlay(showSignUp: $showSignUp, showLogin: $showLogin)
                .opacity(flipped ? 0 : 1)
                .rotation3DEffect(
                    .degrees(flipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0),
                    perspective: 0.6
                )

            // Rückseite: SignUp
            SignUpViewOverlay(showSignUp: $showSignUp, showLogin: $showLogin)
                .opacity(flipped ? 1 : 0)
                .rotation3DEffect(
                    .degrees(flipped ? 0 : -180),
                    axis: (x: 0, y: 1, z: 0),
                    perspective: 0.6
                )
        }
        .frame(height: UIScreen.main.bounds.height * 0.8)
        .animation(.easeInOut(duration: 0.8), value: flipped)
        .onChange(of: showLogin) { flipped = !showLogin }
        .onChange(of: showSignUp) { flipped = showSignUp }
    }
}

//  Begrüßungsseite
struct WelcomeScreen: View {
    var onLoginTap: () -> Void
    var onSignUpTap: () -> Void
    @State private var isPressed = false
    @Binding var shiftUp: Bool
    let darkRed = Color(red: 0.5, green: 0.0, blue: 0.0)
    let brightRed = Color(red: 1.0, green: 0.2, blue: 0.2)
    @EnvironmentObject var AppState: AppState

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [darkRed, brightRed]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .ignoresSafeArea()

                VStack {
                    Text(
                        AppState.TextChanger(
                            OptionEn: "Welcome",
                            OptionGe: "Willkommen",
                            OptionSp: "Bienvenido",
                            OptionFr: "Bienvenue"
                        )
                    )
                    .font(
                        Font.custom("Poppins-Bold", size: geo.size.width * 0.1)
                    )
                    .foregroundColor(.white)
                    .padding(.bottom, geo.size.height * 0.05)

                    Text(
                        AppState.TextChanger(
                            OptionEn:
                                "Stats, calendars, and race history\nbuilt for true F1 fans.",
                            OptionGe:
                                "Statistiken, Kalender und Renngeschichte\nfür echte F1-Fans gemacht.",
                            OptionSp:
                                "Estadísticas, calendarios e historia de carreras\ncreado para verdaderos fanáticos de la F1.",
                            OptionFr:
                                "Statistiques, calendriers et historique des courses\nconçu pour les vrais fans de F1."
                        )
                    )
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(
                        Font.custom(
                            "Poppins-Medium",
                            size: geo.size.width * 0.05
                        )
                    )
                    .foregroundColor(.white.opacity(0.85))
                    .padding(.bottom, geo.size.height * 0.1)

                    HStack {
                        Spacer()
                            .frame(width: geo.size.width * 0.15)

                        Button("Login") {
                            isPressed = true
                            onLoginTap()
                        }
                        .font(
                            Font.custom(
                                "Poppins-Medium",
                                size: geo.size.width * 0.07
                            )
                        )
                        .frame(maxWidth: .infinity)
                        .padding(geo.size.width * 0.03)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(
                                cornerRadius: geo.size.width * 0.03
                            )
                            .stroke(
                                Color.white,
                                lineWidth: geo.size.width * 0.01
                            )
                        )
                        .cornerRadius(geo.size.width * 0.03)
                        .foregroundColor(.white)
                        .scaleEffect(isPressed ? 1.05 : 1)
                        .animation(.spring(), value: isPressed)

                        Spacer()
                            .frame(width: geo.size.width * 0.15)
                    }
                    .padding(.bottom, geo.size.height * 0.025)

                    HStack {
                        Spacer()
                            .frame(width: geo.size.width * 0.15)

                        Button("Sign Up") {
                            onSignUpTap()
                        }
                        .foregroundStyle(Color.black)
                        .font(
                            Font.custom(
                                "Poppins-Medium",
                                size: geo.size.width * 0.07
                            )
                        )
                        .frame(maxWidth: .infinity)
                        .padding(geo.size.width * 0.03)
                        .background(Color.white)
                        .cornerRadius(geo.size.width * 0.03)
                        .foregroundColor(.white)
                        .scaleEffect(isPressed ? 1.05 : 1)
                        .animation(.spring(), value: isPressed)

                        Spacer()
                            .frame(width: geo.size.width * 0.15)
                    }
                }
                .padding(.bottom, geo.size.height * 0.4)
            }
        }
    }
}

struct LoginViewOverlay: View {
    @Binding var showSignUp: Bool
    @Binding var showLogin: Bool

    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: geo.size.width * 0.08)
                    .fill(Color(hex: "#001127"))
                    .frame(
                        maxWidth: geo.size.width * 0.9,
                        maxHeight: UIScreen.main.bounds.height * 0.75
                    )
                    .overlay(
                        ZStack {

                            LoginView(
                                showSignUp: $showSignUp,
                                showLogin: $showLogin
                            )
                        }
                    )
                    .compositingGroup()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    @State private var welcomeOffset: CGFloat = 0
    let darkRed = Color(red: 0.5, green: 0.0, blue: 0.0)
    let brightRed = Color(red: 1.0, green: 0.2, blue: 0.2)
    @State private var sequencefinished = false
    @State private var appOpacity: Double = 0.0
    @State private var dontlogin: Bool = true
    @State private var EmailFocused: Bool = false
    @State private var PasswordFocused: Bool = false
    @FocusState private var EmailInputFocusState: Bool
    @FocusState private var PasswordInputFocusState: Bool
    @State private var errorMessage: String?
    @State private var showerror = false

    @State private var ErrorAtEmail: Bool = false
    @State private var ErrorforEmail: String?
    @State private var ErrorAtPassword: Bool = false
    @State private var ErrorforPassword: String?
    
    @State private var ShowSwitch: Bool = false

    func errorRecognitionReset() {
        ErrorAtEmail = false
        ErrorAtPassword = false
        ErrorforEmail = nil
        ErrorforPassword = nil
    }

    func errorRecognition() {

        ErrorforEmail = nil
        ErrorforPassword = nil
        ErrorAtEmail = false
        ErrorAtPassword = false

        switch AppState.errorMessage {
        case "Kein Account mit dieser E-Mail gefunden.":
            ErrorAtEmail = true
            ErrorforEmail = AppState.TextChanger(
                OptionEn: "Email not registered.",
                OptionGe: "Email nicht registriert",
                OptionSp: "Correo no registrado.",
                OptionFr: "Email non reconnue."
            )
        case "Falsches Passwort.":
            ErrorAtPassword = true
            ErrorforPassword = AppState.TextChanger(
                OptionEn: "Wrong password.",
                OptionGe: "Falsches Passwort",
                OptionSp: "Contraseña incorrecta.",
                OptionFr: "Mot de passe incorrect."
            )
        case "Ungültige E-Mail-Adresse.":
            ErrorAtEmail = true
            ShowSwitch = true
            ErrorforEmail = AppState.TextChanger(
                OptionEn: "Invalid email address.",
                OptionGe: "Ungültige E-Mail-Adresse",
                OptionSp: "Dirección de correo electrónico inválida.",
                OptionFr: "Adresse e-mail invalide."
            )
        default:
            print("Not defined Error at LoginView")
        }

    }

   
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        
                        VStack(alignment: .center, spacing: geo.size.height * 0.005) {
                            
                            HStack {
                                Text(
                                    AppState.TextChanger(
                                        OptionEn: "Welcome Back!",
                                        OptionGe: "Willkommen zurück!",
                                        OptionSp: "¡Bienvenido de nuevo!",
                                        OptionFr: "Bon retour!"
                                    )
                                )
                                .font(
                                    Font.custom(
                                        "Poppins-Bold",
                                        size: geo.size.width * 0.07
                                    )
                                )
                                .foregroundStyle(Color.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, geo.size.height * 0.04)
                            
                            HStack {
                                Text(
                                    AppState.TextChanger(
                                        OptionEn: "Log in to your account",
                                        OptionGe:
                                            "Melde dich in deinem Konto an",
                                        OptionSp: "Inicia sesión en tu cuenta",
                                        OptionFr:
                                            "Connectez-vous à votre compte"
                                    )
                                )
                                .font(.system(size: geo.size.height * 0.035))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            
                            Spacer()
                                .frame(height: geo.size.height * 0.1)
                            
                            HStack{
                                Spacer()
                                InputView(label: "Email", text: $email, error: ErrorAtEmail)
                                Spacer()
                            }
                            .frame(maxWidth: geo.size.width * 0.8, maxHeight: geo.size.height * 0.1)
                            
                            VStack(alignment: .leading) {
                                if ErrorforEmail != nil {
                                    HStack {
                                        
                                        Image(
                                            systemName: "exclamationmark.circle"
                                        )
                                        .foregroundStyle(.red)
                                        Text(ErrorforEmail ?? "")
                                            .foregroundStyle(.red)
                                        
                                    }
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .center
                                    )
                                    
                                }
                            }
                            .frame(height: geo.size.height * 0.09)
                            
                            HStack{
                                Spacer()
                                InputView(label: "Password", text: $password, error: ErrorAtPassword)
                                Spacer()
                            }
                            .frame(maxWidth: geo.size.width * 0.8, maxHeight: geo.size.height * 0.1)
                            
                            VStack(alignment: .leading) {
                                if ErrorforPassword != nil {
                                    HStack {
                                        Image(
                                            systemName: "exclamationmark.circle"
                                        )
                                        .foregroundStyle(.red)
                                        Text(ErrorforPassword ?? "")
                                            .foregroundStyle(.red)
                                    }
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .center
                                    )
                                }
                            }
                            .frame(height: geo.size.height * 0.09)
                            
                            
                            LoginBottomView(
                                showSignUp: $showSignUp,
                                showLogin: $showLogin,
                                password: password,
                                email: email,
                                LoginTap: {
                                    errorRecognition()
                                    
                                }
                                
                            )
                            
                        }
                        
                    }
                    
                }
                .zIndex(0)
                
                .onChange(of: password) {
                    errorRecognitionReset()
                }
                .onChange(of: email) {
                    errorRecognitionReset()
                }
                
                .frame(height: UIScreen.main.bounds.height * 0.6)
                .overlay(
                    Group {
                        if ShowSwitch {
                            ChangeOverlay(
                                switch1: $showSignUp,
                                switch2: $showLogin,
                                ShowOverlay: $ShowSwitch,
                                Caption: AppState.TextChanger(
                                    OptionEn: "Invalid email address",
                                    OptionGe: "Ungültige E-Mail-Adresse",
                                    OptionSp: "Dirección de correo electrónico no válida",
                                    OptionFr: "Adresse e-mail invalide"
                                ),
                                ButtonOverlay: AppState.TextChanger(
                                    OptionEn: "Sign Up",
                                    OptionGe: "Registrieren",
                                    OptionSp: "Registrarse",
                                    OptionFr: "S'inscrire"
                                )
                            )
                            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.6)
                        } else {
                            Text("")
                        }
                    }
                )

            }

        }

    }
}

struct ChangeOverlay: View {
    @Binding var switch1: Bool
    @Binding var switch2: Bool
    @Binding var ShowOverlay: Bool
    let Caption: String
    let ButtonOverlay: String
    
    var body: some View {
        GeometryReader{ geo in
            VStack{
                HStack{
                    Button{
                        ShowOverlay = false
                    }label:{
                        Image(systemName: "xmark")
                    }
                }
                HStack{
                    Text(Caption)
                }
                HStack{
                    Button{
                        switch1.toggle()
                        switch2.toggle()
                        
                    } label:{
                        Text(ButtonOverlay)
                    }
                }
            }
            .background(Color( hex: "#101625"))
            .cornerRadius(geo.size.width * 0.1)
            
        }
    }
}

struct InputView: View {
    let label: String
    @Binding var text: String
    @State private var focus: Bool = false
    let error: Bool?
    @FocusState private var focusState: Bool
    var trimming: CGFloat {
        switch label {
        case "Password": return 0.23
        case "Email": return 0.16
        default: return 0.0
        }
    }


    var body: some View {
        GeometryReader{ geo in
            
            ZStack(alignment: .leading) {
                RoundedRectangle(
                    cornerRadius: geo.size.width * 0.04
                )
                .trim(from: focus ? trimming : 0.0, to: 1)
                .stroke(
                    error ?? false ? Color.red : Color.white,
                    lineWidth: 2
                )
                .rotationEffect(Angle(degrees: 180))
              //  .frame(width: geo.size.width * 0.7)

                RoundedRectangle(
                    cornerRadius: geo.size.width * 0.04
                )
                .trim(from: 0.5, to: 0.56)
                .stroke(
                    error ?? false ? Color.red : Color.white,
                    lineWidth: 2
                )
                //.frame(width: geo.size.width * 0.7)


                Text(label)
                    .foregroundColor(
                    error ?? false ? Color.red : Color.white.opacity(0.7)
                    )
                    .font(
                        .system(
                            size: geo.size.width * 0.08,
                            weight: .bold,
                            design: .default
                        )
                    )
                    .offset(
                        y: !focus
                        ? 0 : -geo.size.height * 0.5
                    )
                    .padding(.leading, geo.size.width * 0.059)
                if focus {
                    HStack {
                        TextField("", text: $text)
                            .font(
                                .system(
                                    size: geo.size.width * 0.08,
                                    weight: .bold,
                                    design: .default
                                )
                            )
                            .foregroundColor(.white)
                            .accentColor(.white)
                            .padding(
                                .leading,
                                geo.size.width * 0.059
                            )
                            .padding(
                                .trailing,
                                geo.size.width * 0.059
                            )
                            .autocapitalization(.none)
                            .focused($focusState)
                            .frame(width: geo.size.width)
                    }
                }
                Button {
                    withAnimation {
                        focus = true
                        focusState = true
                    }
                } label: {
                    Text("")
                        .padding(
                            .leading,
                            geo.size.width * 0.059
                        )
                       .frame(
                            width: geo.size.width * 0.7,
                            height: geo.size.height
                        )
                }

            }

            
            
            
            
            
            
        }
    }
}

struct LoginBottomView: View {
    @Binding var showSignUp: Bool
    @Binding var showLogin: Bool
    let password: String
    let email: String
    var LoginTap: () -> Void
    @EnvironmentObject var AppState: AppState
    var body: some View {
        GeometryReader { geo in
            
            VStack{
                HStack {
                    
                    
                    Button {
                        AppState.logIn(email: email, password: password) {
                            success in
                            if success {
                                AppState.loadUserData()
                                
                                DispatchQueue.main.asyncAfter(
                                    deadline: .now() + 3.0
                                ) {
                                    AppState.isLoggedIn = true
                                    
                                }
                                
                            } else {
                                LoginTap()
                            }
                        }
                        
                    } label: {
                        
                        Text("Login")
                            .font(
                                Font.custom(
                                    "Poppins-Medium",
                                    size: geo.size.width * 0.075
                                )
                            )
                            .foregroundColor(.black)
                            .padding(geo.size.width * 0.05)
                            .padding(.horizontal, geo.size.width * 0.12)
                            .background(Color.white)
                            .cornerRadius(geo.size.width * 0.05)
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, geo.size.height * 0.3)

                
                HStack {
                    Spacer()
                    Text("Don't have an account?")
                        .font(
                            Font.custom(
                                "Poppins-Medium",
                                size: geo.size.width * 0.05
                            )
                        )
                        .foregroundColor(.white)
                    
                }
                .padding(.trailing, geo.size.width * 0.1)
                
                HStack {
                    
                    Spacer()
                    Button(action: {
                        showSignUp = true
                        showLogin = false
                    }) {
                        Text("Sign Up")
                            .font(
                                Font.custom(
                                    "Poppins-Medium",
                                    size: geo.size.width * 0.065
                                )
                            )
                            .foregroundColor(.white)
                    }
                    
                }
                .padding(.trailing, geo.size.width * 0.1)


            }

        }
    }
}

struct SignUpViewOverlay: View {
    @Binding var showSignUp: Bool
    @Binding var showLogin: Bool

    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: geo.size.width * 0.08)
                    .fill(Color(hex: "#001127"))
                    .frame(
                        maxWidth: geo.size.width * 0.9,
                        maxHeight: UIScreen.main.bounds.height * 0.75
                    )
                    .overlay(
                        ZStack {

                            SignUpView(
                                showLogin: $showLogin, showSignUp: $showSignUp
                            )
                        }
                    )
                    .compositingGroup()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    
    
    @State private var errorAtPassword: Bool = false
    @State private var errorAtConfirmPassword: Bool = false
    @State private var errorAtUsername: Bool = false
    @State private var errorAtEmail: Bool = false
    
    @State private var errorForPassword: String? = ""
    @State private var errorForConfirmPassword: String? = ""
    @State private var errorForUsername: String? = ""
    @State private var errorForEmail: String? = ""
    
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
        GeometryReader{ geo in
            ZStack {
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        
                        VStack(alignment: .center, spacing: geo.size.height * 0.005) {
                            
                            HStack {
                                Text(
                                    AppState.TextChanger(
                                        OptionEn: "Welcome Back!",
                                        OptionGe: "Willkommen zurück!",
                                        OptionSp: "¡Bienvenido de nuevo!",
                                        OptionFr: "Bon retour!"
                                    )
                                )
                                .font(
                                    Font.custom(
                                        "Poppins-Bold",
                                        size: geo.size.width * 0.07
                                    )
                                )
                                .foregroundStyle(Color.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, geo.size.height * 0.04)
                            
                            HStack {
                                Text(
                                    AppState.TextChanger(
                                        OptionEn: "Log in to your account",
                                        OptionGe:
                                            "Melde dich in deinem Konto an",
                                        OptionSp: "Inicia sesión en tu cuenta",
                                        OptionFr:
                                            "Connectez-vous à votre compte"
                                    )
                                )
                                .font(.system(size: geo.size.height * 0.035))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            
                            Spacer()
                                .frame(height: geo.size.height * 0.1)
                            
                            HStack{
                                Spacer()
                                InputView(label: "Email", text: $email, error: errorAtEmail)
                                Spacer()
                            }
                            .frame(maxWidth: geo.size.width * 0.8, maxHeight: geo.size.height * 0.1)
                            
                            VStack(alignment: .leading) {
                                if errorForEmail != nil {
                                    HStack {
                                        
                                        Image(
                                            systemName: "exclamationmark.circle"
                                        )
                                        .foregroundStyle(.red)
                                        Text(errorForEmail ?? "")
                                            .foregroundStyle(.red)
                                        
                                    }
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .center
                                    )
                                    
                                }
                            }
                            .frame(height: geo.size.height * 0.09)
                            
                            HStack{
                                Spacer()
                                InputView(label: "Password", text: $password, error: errorAtPassword)
                                Spacer()
                            }
                            .frame(maxWidth: geo.size.width * 0.8, maxHeight: geo.size.height * 0.1)
                            
                            VStack(alignment: .leading) {
                                if errorForPassword != nil {
                                    HStack {
                                        Image(
                                            systemName: "exclamationmark.circle"
                                        )
                                        .foregroundStyle(.red)
                                        Text(errorForPassword ?? "")
                                            .foregroundStyle(.red)
                                    }
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .center
                                    )
                                }
                            }
                            .frame(height: geo.size.height * 0.09)
                            
                            
                            LoginBottomView(
                                showSignUp: $showSignUp,
                                showLogin: $showLogin,
                                password: password,
                                email: email,
                                LoginTap: {
                                 //  errorRecognition()
                                    
                                }
                                
                            )
                            
                        }
                        
                    }
                    
                }
                .zIndex(0)
                
//                .onChange(of: password) {
//                    errorRecognitionReset()
//                }
//                .onChange(of: email) {
//                    errorRecognitionReset()
//                }
                
                .frame(height: UIScreen.main.bounds.height * 0.6)
//                .overlay(
//                    Group {
//                        if ShowSwitch {
//                            ChangeOverlay(
//                                switch1: $showSignUp,
//                                switch2: $showLogin,
//                                ShowOverlay: $ShowSwitch,
//                                Caption: AppState.TextChanger(
//                                    OptionEn: "Invalid email address",
//                                    OptionGe: "Ungültige E-Mail-Adresse",
//                                    OptionSp: "Dirección de correo electrónico no válida",
//                                    OptionFr: "Adresse e-mail invalide"
//                                ),
//                                ButtonOverlay: AppState.TextChanger(
//                                    OptionEn: "Sign Up",
//                                    OptionGe: "Registrieren",
//                                    OptionSp: "Registrarse",
//                                    OptionFr: "S'inscrire"
//                                )
//                            )
//                            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.6)
//                        } else {
//                            Text("")
//                        }
//                    }
//                )
                
            }
            
        }
        
        
        
        Button(action: {
            AppState.signUp(
                email: email,
                password: password,
                username: username
            )
            approved()
        }) {
            Text("Sign Up")
                .font(.headline)
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    Capsule()
                        .fill(Color.white)
                        .shadow(
                            color: .black.opacity(0.3),
                            radius: 8,
                            x: 0,
                            y: 4
                        )
                )
                .scaleEffect(isPressed ? 1.05 : 1.0)
                .animation(.spring(), value: isPressed)
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}
               
#Preview {
    ContentView()
        .environmentObject(AppState())

}

