import SwiftUI

// MARK: - Modelos de Dados
struct KeyData {
    let key: String
    let days: Int
}

// MARK: - Gerenciador de Chaves (Mantendo a função original)
class HubManager: ObservableObject {
    @Published var isInstalled: Bool = false
    @Published var expirationDate: Date?
    
    private let keys = [
        "GH1DIA": 1, "GH1DIA_A": 1, "GH1DIA_B": 1,
        "GH3DIAS": 3, "GH3DIAS_A": 3,
        "GH7DIAS": 7, "GH7DIAS_A": 7, "GH7DIAS_B": 7,
        "GH15DIAS": 15, "GH15DIAS_A": 15,
        "GH30DIAS": 30, "GH30DIAS_A": 30, "GH30DIAS_B": 30
    ]
    
    init() {
        checkStatus()
    }
    
    func checkStatus() {
        if let date = UserDefaults.standard.object(forKey: "exp_date") as? Date {
            if date > Date() {
                self.isInstalled = true
                self.expirationDate = date
            } else {
                self.isInstalled = false
            }
        }
    }
    
    func validateKey(_ inputKey: String) {
        if let days = keys[inputKey] {
            let calendar = Calendar.current
            let date = calendar.date(byAdding: .day, value: days, to: Date())
            UserDefaults.standard.set(date, forKey: "exp_date")
            self.isInstalled = true
            self.expirationDate = date
        } else {
            self.isInstalled = false
        }
    }
}

// MARK: - Componente de Bolha de Mensagem
struct ChatBubble: View {
    let text: String
    let isUser: Bool
    
    var body: some View {
        HStack {
            if isUser { Spacer() }
            
            Text(text)
                .padding(12)
                .background(isUser ? Color.green : Color(white: 0.2))
                .foregroundColor(.white)
                .cornerRadius(15)
                .padding(.horizontal, 10)
            
            if !isUser { Spacer() }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Interface Principal (Nova UI de Chat)
struct ContentView: View {
    @StateObject var hub = HubManager()
    @State private var keyInput: String = ""
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header de Status (Substitui o botão central)
                HStack {
                    Text("GH777")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    if hub.isInstalled {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Installed")
                        }
                        .font(.caption)
                        .foregroundColor(.green)
                        .padding(6)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(white: 0.1))
                
                // Área de Mensagens
                ScrollView {
                    VStack(spacing: 15) {
                        ChatBubble(text: "Bem-vindo ao GH777. Por favor, insira sua chave de acesso para continuar.", isUser: false)
                        
                        if hub.isInstalled {
                            ChatBubble(text: "Acesso concedido! O sistema está instalado e operacional.", isUser: false)
                        }
                    }
                    .padding()
                }
                
                // Campo de Entrada (Composer)
                VStack {
                    if !hub.isInstalled {
                        HStack {
                            TextField("Digite sua Key aqui...", text: $keyInput)
                                .padding(12)
                                .background(Color(white: 0.2))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .textFieldStyle(PlainTextFieldStyle())
                            
                            Button(action: {
                                hub.validateKey(keyInput)
                            }) {
                                Image(systemName: "paperplane.fill")
                                    .padding(12)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        .padding()
                        .background(Color(white: 0.1))
                    } else {
                        // Quando instalado, mostra apenas um rodapé decorativo
                        Text("EXTERNAL GH777")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
            }
        }
    }
}

@main
struct GH777App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
