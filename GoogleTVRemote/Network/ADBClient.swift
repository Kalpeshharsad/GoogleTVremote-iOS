import Foundation

/// ADB Client for communicating with Google TV devices via TCP
class ADBClient: NSObject, ObservableObject {
    @Published var isConnected = false
    @Published var connectionStatus = "Disconnected"
    @Published var lastError: String?
    
    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    private var streamDelegate: StreamDelegate?
    
    private let adbPort = 5555
    private var host: String?
    
    // ADB protocol message constants
    private let MESSAGE_SIZE_BYTES = 4
    private let DATA_SIZE_BYTES = 4
    
    /// Connect to an ADB device
    func connect(toHost host: String) {
        self.host = host
        connectionStatus = "Connecting to \(host)..."
        
        // Resolve host and establish connection
        var readStream: InputStream?
        var writeStream: OutputStream?
        
        Stream.getStreamsToHost(withName: host, port: adbPort, inputStream: &readStream, outputStream: &writeStream)
        
        guard let input = readStream, let output = writeStream else {
            connectionStatus = "Failed to create streams"
            lastError = "Could not establish stream connection"
            return
        }
        
        self.inputStream = input
        self.outputStream = output
        
        // Set up delegate for stream events
        streamDelegate = StreamDelegate(client: self)
        input.delegate = streamDelegate
        output.delegate = streamDelegate
        
        input.schedule(in: .current, forMode: .common)
        output.schedule(in: .current, forMode: .common)
        
        input.open()
        output.open()
    }
    
    /// Disconnect from the ADB device
    func disconnect() {
        inputStream?.close()
        outputStream?.close()
        inputStream = nil
        outputStream = nil
        isConnected = false
        connectionStatus = "Disconnected"
        lastError = nil
    }
    
    /// Send an ADB shell command
    func sendCommand(_ command: String, completion: @escaping (String?, Error?) -> Void) {
        guard let output = outputStream, output.streamStatus == .open else {
            completion(nil, ADBError.notConnected)
            return
        }
        
        // Format: shell:<command>
        let shellCommand = "shell:\(command)"
        sendADBMessage(shellCommand) { [weak self] error in
            if let error = error {
                self?.lastError = error.localizedDescription
                completion(nil, error)
            } else {
                completion("Command sent", nil)
            }
        }
    }
    
    /// Send an ADB key event (for button presses)
    func sendKeyEvent(_ keyCode: Int, completion: @escaping (Error?) -> Void) {
        let command = "input keyevent \(keyCode)"
        sendCommand(command) { _, error in
            completion(error)
        }
    }
    
    /// Send a text input command
    func sendText(_ text: String, completion: @escaping (Error?) -> Void) {
        let command = "input text '\(text)'"
        sendCommand(command) { _, error in
            completion(error)
        }
    }
    
    private func sendADBMessage(_ message: String, completion: @escaping (Error?) -> Void) {
        guard let output = outputStream else {
            completion(ADBError.notConnected)
            return
        }
        
        let messageData = message.data(using: .utf8) ?? Data()
        let messageLength = messageData.count
        
        // Create size header (4 bytes, hex format)
        let sizeString = String(format: "%04x", messageLength)
        guard let sizeData = sizeString.data(using: .utf8) else {
            completion(ADBError.encodingError)
            return
        }
        
        // Write size
        var bytesWritten = output.write(sizeData.withUnsafeBytes { $0.baseAddress! }, maxLength: sizeData.count)
        if bytesWritten < 0 {
            completion(ADBError.writeFailed)
            return
        }
        
        // Write message
        bytesWritten = output.write(messageData.withUnsafeBytes { $0.baseAddress! }, maxLength: messageData.count)
        if bytesWritten < 0 {
            completion(ADBError.writeFailed)
            return
        }
        
        completion(nil)
    }
    
    private func handleStreamEvent(_ event: Stream.Event, stream: Stream) {
        switch event {
        case .openCompleted:
            if stream == outputStream {
                connectionStatus = "Connected"
                isConnected = true
                lastError = nil
            }
        case .errorOccurred:
            connectionStatus = "Connection error"
            isConnected = false
            lastError = stream.streamError?.localizedDescription ?? "Unknown error"
            disconnect()
        case .endEncoded:
            connectionStatus = "Disconnected"
            isConnected = false
            disconnect()
        default:
            break
        }
    }
}

// MARK: - Stream Delegate
private class StreamDelegate: NSObject, StreamDelegate {
    weak var client: ADBClient?
    
    init(client: ADBClient) {
        self.client = client
    }
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        client?.handleStreamEvent(eventCode, stream: aStream)
    }
}

// MARK: - Error Handling
enum ADBError: LocalizedError {
    case notConnected
    case encodingError
    case writeFailed
    case invalidResponse
    case timeout
    
    var errorDescription: String? {
        switch self {
        case .notConnected:
            return "Not connected to device"
        case .encodingError:
            return "Failed to encode message"
        case .writeFailed:
            return "Failed to write to device"
        case .invalidResponse:
            return "Invalid response from device"
        case .timeout:
            return "Command timeout"
        }
    }
}
