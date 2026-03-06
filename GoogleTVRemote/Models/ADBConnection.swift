import Foundation

/// Model representing an ADB device connection
struct ADBConnection: Identifiable, Codable {
    let id: UUID
    var name: String
    var host: String
    var port: Int = 5555
    var isConnected: Bool = false
    var lastConnectedDate: Date?
    
    init(name: String, host: String) {
        self.id = UUID()
        self.name = name
        self.host = host
    }
}

/// Remote key codes for Google TV
enum RemoteKeyCode: Int {
    case home = 3
    case back = 4
    case up = 19
    case down = 20
    case left = 21
    case right = 22
    case enter = 23
    case menu = 82
    case power = 26
    case volumeUp = 24
    case volumeDown = 25
    case mute = 164
    case channelUp = 166
    case channelDown = 167
    case play = 79
    case pause = 85
    case playpause = 85
    case next = 130
    case previous = 131
}

/// Remote command model
struct RemoteCommand {
    let name: String
    let keyCode: RemoteKeyCode
    let description: String
}
