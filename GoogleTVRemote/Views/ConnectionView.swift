import SwiftUI

/// View for managing device connections
struct ConnectionView: View {
    @ObservedObject var viewModel: RemoteViewModel
    @State private var newConnectionName = ""
    @State private var newConnectionHost = ""
    @State private var showingAddConnection = false
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.adbClient.isConnected {
                    connectedView
                } else {
                    disconnectedView
                }
            }
            .navigationTitle("Google TV Remote")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddConnection = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddConnection) {
                addConnectionSheet
            }
        }
    }
    
    @ViewBuilder
    private var connectedView: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                HStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 12, height: 12)
                    Text("Connected to \(viewModel.selectedConnection?.name ?? "Device")")
                        .font(.headline)
                    Spacer()
                }
                Text(viewModel.selectedConnection?.host ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
            Button(role: .destructive) {
                viewModel.disconnectFromDevice()
            } label: {
                Label("Disconnect", systemImage: "xmark.circle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            
            Spacer()
        }
        .padding()
    }
    
    @ViewBuilder
    private var disconnectedView: some View {
        VStack(spacing: 12) {
            if viewModel.savedConnections.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "wifi.slash")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                    Text("No Saved Connections")
                        .font(.headline)
                    Text("Add a Google TV device to get started")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(.gray)
            } else {
                List {
                    ForEach(viewModel.savedConnections) { connection in
                        Button(action: { viewModel.connectToDevice(connection) }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(connection.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Text(connection.host)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                viewModel.deleteConnection(connection)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var addConnectionSheet: some View {
        NavigationView {
            Form {
                Section(header: Text("Device Information")) {
                    TextField("Device Name", text: $newConnectionName)
                    TextField("Device IP Address", text: $newConnectionHost)
                        .keyboardType(.decimalPad)
                }
                
                Section(footer: Text("Make sure your device's ADB TCP/IP port is enabled (default: 5555).")) {
                    Button(action: addConnection) {
                        Text("Save Connection")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.filled)
                    .disabled(newConnectionName.isEmpty || newConnectionHost.isEmpty)
                }
            }
            .navigationTitle("Add Connection")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showingAddConnection = false
                    }
                }
            }
        }
    }
    
    private func addConnection() {
        let connection = ADBConnection(name: newConnectionName, host: newConnectionHost)
        viewModel.saveConnection(connection)
        newConnectionName = ""
        newConnectionHost = ""
        showingAddConnection = false
    }
}

#Preview {
    let viewModel = RemoteViewModel()
    ConnectionView(viewModel: viewModel)
}
