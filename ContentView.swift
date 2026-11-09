import SwiftUI

struct KeyData {
    let key: String
    let days: Int
}

class HubManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var expiryDate: Date?
    
    // LISTA DE KEYS - Você pode mudar as palavras e os dias aqui
    let validKeys = [
        // 1 Dia
        KeyData(key: "GH1DIA", days: 1),
        KeyData(key: "GH1DIA_A", days: 1),
        KeyData(key: "GH1DIA_B", days: 1),
        
        // 3 Dias
        KeyData(key: "GH3DIAS", days: 3),
        KeyData(key: "GH3DIAS_A", days: 3),
        
        // 7 Dias
        KeyData(key: "GH7DIAS", days: 7),
        KeyData(key: "GH7DIAS_A", days: 7),
        KeyData(key: "GH7DIAS_B", days: 7),
        
        // 15 Dias
        KeyData(key: "GH15DIAS", days: 15),
        KeyData(key: "GH15DIAS_A", days: 15),
        
        // 30 Dias
        KeyData(key: "GH30DIAS", days: 30),
        KeyData(key: "GH30DIAS_A", days: 30),
        KeyData(key: "GH30DIAS_B", days: 30)
    ]
    
    init() {
        checkSubscription()
    }
    
    func checkSubscription() {
        if let savedDate = UserDefaults.standard.object(forKey: "expiryDate") as? Date {
            if savedDate > Date() {
                self.isAuthenticated = true
                self.expiryDate = savedDate
            } else {
                self.isAuthenticated = false
            }
        }
    }
    
    func login(keyInput: String) {
        if let keyInfo = validKeys.first(where: { $0.key == keyInput }) {
            let calendar = Calendar.current
            if let futureDate = calendar.date(byAdding: .day, value: keyInfo.days, to: Date()) {
                UserDefaults.standard.set(futureDate, forKey: "expiryDate")
                self.expiryDate = futureDate
                self.isAuthenticated = true
            }
        }
    }
}

struct ContentView: View {
    @StateObject var manager = HubManager()
    @State private var keyText = ""
    
    var body: some View {
        ZStack {
            Image("wallpaper") // Certifique-se que o nome no Assets é 'wallpaper'
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            if manager.isAuthenticated {
                MainHubView()
            } else {
                LoginView(manager: manager, keyText: $keyText)
            }
        }
    }
}

struct LoginView: View {
    @ObservedObject var manager: HubManager
    @Binding var keyText: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image("logo") // Certifique-se que o nome no Assets é 'logo'
                .resizable()
                .frame(width: 120, height: 120)
                .cornerRadius(20)
            
            Text("EXTERNAL GH777")
                .font(.title).bold()
                .foregroundColor(.white)
            
            TextField("Digite sua Key", text: $keyText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                manager.login(keyInput: keyText)
            }) {
                Text("Acessar")
                    .bold()
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.black.opacity(0.6))
        .cornerRadius(30)
        .padding(30)
    }
}

struct MainHubView: View {
    var body: some View {
        VStack {
            Text("Bem-vindo ao GH777")
                .font(.largeTitle).bold()
                .foregroundColor(.white)
            
            Spacer().frame(height: 40)
            
            // Função Installed
            Button(action: { print("Installed clicked") }) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Installed")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 250, height: 60)
                .background(Color.green)
                .cornerRadius(15)
            }
            
            Spacer()
        }
        .padding()
    }
}
