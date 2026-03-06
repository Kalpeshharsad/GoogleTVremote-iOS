import SwiftUI

/// Main content view - handles connection and remote control
struct ContentView: View {
    @ObservedObject var viewModel: RemoteViewModel
    @State private var showingRemote = false
    
    var body: some View {
        if viewModel.adbClient.isConnected {
            RemoteControlView(viewModel: viewModel)
        } else {
            ConnectionView(viewModel: viewModel)
        }
    }
}

#Preview {
    let viewModel = RemoteViewModel()
    ContentView(viewModel: viewModel)
}
