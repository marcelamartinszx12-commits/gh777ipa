import SwiftUI
import FirebaseCore
import FirebaseFirestore

// MARK: - Modelos de Dados
enum ContentType: String, Codable, CaseIterable {
    case patch = "Patch", wallpaper = "Wallpaper", theme = "Dialer Theme", feature = "3105 Feature"
}

struct InstalledItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var type: ContentType
    var icon: String
    var isUpdated: Bool = false
    var bundleId: String?
}

// MARK: - Gerenciador de Hub
class HubManager: ObservableObject {
    @Published var installedItems: [InstalledItem] = [
        InstalledItem(name: "System Optimizer", type: .patch, icon: "cpu", bundleId: "com.apple.mobile.MobileHouseArrest"),
        InstalledItem(name: "Neon Night", type: .wallpaper, icon: "image"),
        InstalledItem(name: "Modern Dialer", type: .theme, icon: "phone"),
        InstalledItem(name: "Advanced Cleaner", type: .feature, icon: "trash")
    ]
    
    func applyPatch(item: InstalledItem) {
        print("Aplicando patch \(item.name)")
    }
}

// MARK: - Tela de Login com Trava de Dispositivo
struct LoginView: View {
    @State private var key = ""
    @State private var isAuthenticated = false
    @State private var errorMessage = ""
    let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? "unknown_device"

    var body: some View {
        if isAuthenticated {
            ThreeOneOSFiveView()
        } else {
            VStack(spacing: 30) {
                Image("app_logo") 
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                
                Text("EXTERNAL GH777")
                    .font(.title).bold().foregroundColor(.white)
                
                TextField("Insira sua Key", text: $key)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 40)
                    .autocapitalization(.none)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage).foregroundColor(.red).font(.caption)
                }
                
                Button(action: validateKey) {
                    Text("Login").bold().foregroundColor(.white)
                        .frame(maxWidth: .infinity).padding()
                        .background(Color.blue).cornerRadius(10)
                }
                .padding(.horizontal, 40)
            }
            .padding().frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }

    func validateKey() {
        let db = Firestore.firestore()
        
        // Busca a key no Firebase
        db.collection("keys").document(key).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let registeredDevice = data?["device_id"] as? String
                
                if registeredDevice == nil {
                    // Key nova: Vincula ao dispositivo atual
                    db.collection("keys").document(key).updateData(["device_id": deviceID]) { _ in
                        isAuthenticated = true
                    }
                } else if registeredDevice == deviceID {
                    // Key já pertence a este dispositivo
                    isAuthenticated = true
                } else {
                    errorMessage = "Esta key já está vinculada a outro dispositivo."
                }
            } else {
                errorMessage = "Key inválida."
            }
        }
    }
}

// MARK: - Tela Principal
struct ThreeOneOSFiveView: View {
    @StateObject var manager = HubManager()
    var body: some View {
        ZStack {
            Image("wallpaper_bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()

            NavigationView {
                List {
                    Section(header: Text("All Content").foregroundColor(.white)) {
                        ForEach(manager.installedItems) { item in
                            HStack {
                                Image(systemName: item.icon).foregroundColor(.blue).frame(width: 30)
                                VStack(alignment: .leading) {
                                    Text(item.name).font(.headline).foregroundColor(.primary)
                                    Text(item.type.rawValue).font(.caption).foregroundColor(.secondary)
                                }
                                Spacer()
                                Button("Apply") { manager.applyPatch(item: item) }
                                    .padding(6).background(Color.blue.opacity(0.2)).cornerRadius(8)
                            }
                            .listRowBackground(Color.white.opacity(0.7))
                        }
                    }
                }
                .navigationTitle("EXTERNAL GH777")
            }
            .background(Color.black.opacity(0.3))
        }
    }
}

@main
struct GH777App: App {
    init() {
        FirebaseApp.configure() // Inicializa o Firebase
    }
    var body: some Scene {
        WindowGroup { LoginView() }
    }
}
