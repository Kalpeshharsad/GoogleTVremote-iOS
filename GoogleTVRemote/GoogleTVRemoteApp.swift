import SwiftUI

@main
struct GoogleTVRemoteApp: App {
    @StateObject private var viewModel = RemoteViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
