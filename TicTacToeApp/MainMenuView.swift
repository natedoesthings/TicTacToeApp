import SwiftUI

struct MainMenuView: View {
    @State private var animateButton = false
    @EnvironmentObject var globalSettings: GlobalSettings
    @State private var showRestartButton: Bool = false
    


    
    var body: some View {
        NavigationView {
            ZStack {
                globalSettings.reverseWhite().ignoresSafeArea()
                VStack {
                    ZStack {
                        HStack(spacing: 0) {
                            Text("TIK-TAK-")
                                .font(.system(size: 45, weight: .heavy))
                                .foregroundColor(globalSettings.reverseBlack())
                            Text("TOE")
                                .font(.system(size: 45, weight: .heavy))
                                .overlay(
                                    GeometryReader { geometry in
                                        Path { path in
                                            let width = geometry.size.width
                                            let height = geometry.size.height
                                            path.move(to: CGPoint(x: 0, y: height))
                                            path.addLine(to: CGPoint(x: width, y: 0))
                                        }
                                        .stroke(globalSettings.reverseBlack(), lineWidth: 10)
                                    }
                                )
                                .foregroundColor(globalSettings.reverseBlack())
                        }
                        .padding(.bottom, 10)
                        
                        Text("AI?")
                            .font(.system(size: 30, weight: .heavy))
                            .foregroundColor(globalSettings.reverseBlack())
                            .offset(x: 150, y: 15)
                            .rotationEffect(Angle(degrees: 10)) // Adjust position as needed
                    }
                    .padding(.bottom, 50)
                    
                    NavigationLink(destination: ContentView(gameMode: .twoPlayer, Difficulty: .easy, showRestartButton: $showRestartButton)) {
                        Text("PLAY vs. FRIEND")
                            .frame(width: animateButton ? 220 : 200, height: animateButton ? 55 : 50)
                            .background(globalSettings.reverseBlack())
                            .foregroundColor(globalSettings.reverseWhite())
                            .font(.system(size: 20, weight: .heavy))
                            .clipShape(Capsule())
 
                    }
                    .padding(.bottom, 20)
                    
                    NavigationLink(destination: GameModeSelection()) {
                        Text("PLAY vs. BOT")
                            .frame(width: animateButton ? 220 : 200, height: animateButton ? 55 : 50)
                            .background(globalSettings.reverseBlack())
                            .foregroundColor(globalSettings.reverseWhite())
                            .font(.system(size: 20, weight: .heavy))
                            .clipShape(Capsule())
 
                    }
                }
                .padding()
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                        animateButton = true
                    }
                    
                }
                // Settings button in the bottom left corner
                VStack {
                    Spacer()
                    HStack {
                        NavigationLink(destination: SettingsView()) {
                            Image(globalSettings.darkMode ? "white_settings" : "settings")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()
                                
                        }
                        
                        Button(action: {
                            globalSettings.darkMode = !globalSettings.darkMode
                        }) {
                            Image(globalSettings.darkMode ? "white_mode_switch" : "mode_switch")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()
                                
                            
                        }
                        
                        Button(action: {
                            globalSettings.mainMute = !globalSettings.mainMute
                            
                            
                            if globalSettings.mainMute {
                                // save the volume before mute
                                globalSettings.mainVolume = globalSettings.soundManager.mainVolume
                                // mute
                                globalSettings.soundManager.mainVolume = 0
                            }
                            else {
                                globalSettings.soundManager.mainVolume = globalSettings.mainVolume
                                
                            }
                            
                            globalSettings.soundManager.updateVolume(for: .main)
                        }) {
                            Image(globalSettings.darkMode ? globalSettings.mainMute ? "white_sound_off" : "white_sound_on" : globalSettings.mainMute ? "black_sound_off" : "black_sound_on")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()
                            
                        }

                    }
                }
            }
        }
       

    }
    
    
}

struct SlashView: View {
    var visible: Bool
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                path.move(to: CGPoint(x: width, y: 0))
                path.addLine(to: CGPoint(x: 0, y: height))
            }
            .stroke(Color.black, lineWidth: 2)
            .opacity(visible ? 1 : 0)
        }
    }
}

#Preview {
    MainMenuView()
        .environmentObject(GlobalSettings())



}
