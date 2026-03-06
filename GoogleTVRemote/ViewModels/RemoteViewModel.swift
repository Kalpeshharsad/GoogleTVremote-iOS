import Foundation
import SwiftUI

/// ViewModel for managing remote control operations
class RemoteViewModel: ObservableObject {
    @Published var adbClient = ADBClient()
    @Published var savedConnections: [ADBConnection] = []
    @Published var isShowingAddConnection = false
    @Published var selectedConnection: ADBConnection?
    
    private let userDefaultsKey = "SavedADBConnections"
    
    init() {
        loadSavedConnections()
    }
    
    // MARK: - Connection Management
    func connectToDevice(_ connection: ADBConnection) {
        selectedConnection = connection
        adbClient.connect(toHost: connection.host)
    }
    
    func disconnectFromDevice() {
        adbClient.disconnect()
        selectedConnection = nil
    }
    
    func saveConnection(_ connection: ADBConnection) {
        if !savedConnections.contains(where: { $0.id == connection.id }) {
            savedConnections.append(connection)
            persistConnections()
        }
    }
    
    func deleteConnection(_ connection: ADBConnection) {
        savedConnections.removeAll { $0.id == connection.id }
        persistConnections()
    }
    
    // MARK: - Remote Control Actions
    func pressButton(_ keyCode: RemoteKeyCode) {
        adbClient.sendKeyEvent(keyCode.rawValue) { error in
            if let error = error {
                print("Error sending key event: \(error)")
            }
        }
    }
    
    func home() {
        pressButton(.home)
    }
    
    func back() {
        pressButton(.back)
    }
    
    func navigate(up: Bool) {
        pressButton(up ? .up : .down)
    }
    
    func navigate(left: Bool) {
        pressButton(left ? .left : .right)
    }
    
    func select() {
        pressButton(.enter)
    }
    
    func openMenu() {
        pressButton(.menu)
    }
    
    func volumeUp() {
        pressButton(.volumeUp)
    }
    
    func volumeDown() {
        pressButton(.volumeDown)
    }
    
    func toggleMute() {
        pressButton(.mute)
    }
    
    func playPause() {
        pressButton(.playpause)
    }
    
    func next() {
        pressButton(.next)
    }
    
    func previous() {
        pressButton(.previous)
    }
    
    func channelUp() {
        pressButton(.channelUp)
    }
    
    func channelDown() {
        pressButton(.channelDown)
    }
    
    // MARK: - Persistence
    private func loadSavedConnections() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let connections = try? JSONDecoder().decode([ADBConnection].self, from: data) {
            self.savedConnections = connections
        }
    }
    
    private func persistConnections() {
        if let data = try? JSONEncoder().encode(savedConnections) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
}
