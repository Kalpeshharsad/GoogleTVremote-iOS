import SwiftUI

/// Main remote control interface view
struct RemoteControlView: View {
    @ObservedObject var viewModel: RemoteViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Top controls (power, volume, mute, channels)
            topControlsView
            
            Divider()
            
            // Navigation pad
            navigationPadView
            
            Divider()
            
            // Media controls
            mediaControlsView
            
            Divider()
            
            // Action buttons
            actionButtonsView
            
            Spacer()
        }
        .navigationTitle("Remote Control")
        .background(Color(.systemGray6))
    }
    
    private var topControlsView: some View {
        VStack(spacing: 12) {
            // Power button
            Button(action: { viewModel.pressButton(.power) }) {
                Image(systemName: "power.circle.fill")
                    .font(.system(size: 32))
                    .frame(width: 60, height: 60)
                    .background(Color(.systemGray4))
                    .clipShape(Circle())
            }
            .foregroundColor(.red)
            
            // Volume and mute controls
            HStack(spacing: 16) {
                Button(action: { viewModel.volumeUp() }) {
                    VStack(spacing: 4) {
                        Image(systemName: "speaker.wave.2.fill")
                        Text("Vol+")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                }
                
                Button(action: { viewModel.toggleMute() }) {
                    VStack(spacing: 4) {
                        Image(systemName: "speaker.slash.fill")
                        Text("Mute")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                }
                
                Button(action: { viewModel.volumeDown() }) {
                    VStack(spacing: 4) {
                        Image(systemName: "speaker.wave.1.fill")
                        Text("Vol-")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                }
            }
            
            // Channel controls
            HStack(spacing: 16) {
                Button(action: { viewModel.channelUp() }) {
                    VStack(spacing: 4) {
                        Image(systemName: "arrow.up")
                        Text("Ch+")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                }
                
                Button(action: { viewModel.channelDown() }) {
                    VStack(spacing: 4) {
                        Image(systemName: "arrow.down")
                        Text("Ch-")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                }
            }
        }
        .padding()
    }
    
    private var navigationPadView: some View {
        VStack(spacing: 16) {
            Text("Navigation")
                .font(.headline)
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                // Up
                Button(action: { viewModel.navigate(up: true) }) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 20, weight: .semibold))
                        .frame(width: 60, height: 60)
                        .background(Color(.systemBlue))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                
                // Left, Select, Right
                HStack(spacing: 8) {
                    Button(action: { viewModel.navigate(left: true) }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .semibold))
                            .frame(width: 60, height: 60)
                            .background(Color(.systemBlue))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    
                    Button(action: { viewModel.select() }) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 28))
                            .frame(width: 60, height: 60)
                            .background(Color(.systemGreen))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    
                    Button(action: { viewModel.navigate(left: false) }) {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 20, weight: .semibold))
                            .frame(width: 60, height: 60)
                            .background(Color(.systemBlue))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                
                // Down
                Button(action: { viewModel.navigate(up: false) }) {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 20, weight: .semibold))
                        .frame(width: 60, height: 60)
                        .background(Color(.systemBlue))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
        }
        .padding()
    }
    
    private var mediaControlsView: some View {
        HStack(spacing: 16) {
            Button(action: { viewModel.previous() }) {
                VStack(spacing: 4) {
                    Image(systemName: "backward.fill")
                    Text("Previous")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(Color(.systemGray5))
                .cornerRadius(8)
            }
            
            Button(action: { viewModel.playPause() }) {
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 40))
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
            }
            
            Button(action: { viewModel.next() }) {
                VStack(spacing: 4) {
                    Image(systemName: "forward.fill")
                    Text("Next")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(Color(.systemGray5))
                .cornerRadius(8)
            }
        }
        .padding()
    }
    
    private var actionButtonsView: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button(action: { viewModel.home() }) {
                    VStack(spacing: 4) {
                        Image(systemName: "house.fill")
                        Text("Home")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                }
                
                Button(action: { viewModel.back() }) {
                    VStack(spacing: 4) {
                        Image(systemName: "arrowshape.left.fill")
                        Text("Back")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                }
                
                Button(action: { viewModel.openMenu() }) {
                    VStack(spacing: 4) {
                        Image(systemName: "list.bullet")
                        Text("Menu")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}

#Preview {
    let viewModel = RemoteViewModel()
    RemoteControlView(viewModel: viewModel)
}
