import SwiftUI

struct MainMenuView: View {
    @State private var animateButton = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ZStack {
                        HStack(spacing: 0) {
                            Text("TIK-TAK-")
                                .font(.system(size: 45, weight: .heavy))
                                .foregroundColor(reverseBlack)
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
                                        .stroke(reverseBlack, lineWidth: 10)
                                    }
                                )
                                .foregroundColor(reverseBlack)
                        }
                        .padding(.bottom, 10)
                        
                        Text("AI?")
                            .font(.system(size: 30, weight: .heavy))
                            .foregroundColor(reverseBlack)
                            .offset(x: 150, y: 15)
                            .rotationEffect(Angle(degrees: 10)) // Adjust position as needed
                    }
                    .padding(.bottom, 50)
                    
                    NavigationLink(destination: ContentView(gameMode: .twoPlayer, Difficulty: .easy)) {
                        Text("PLAY vs. FRIEND")
                            .frame(width: animateButton ? 220 : 200, height: animateButton ? 55 : 50)
                            .background(reverseBlack)
                            .foregroundColor(reverseWhite)
                            .font(.system(size: 20, weight: .heavy))
                            .clipShape(Capsule())
                    }
                    .padding(.bottom, 20)
                    
                    NavigationLink(destination: GameModeSelection()) {
                        Text("PLAY vs. BOT")
                            .frame(width: animateButton ? 220 : 200, height: animateButton ? 55 : 50)
                            .background(reverseBlack)
                            .foregroundColor(reverseWhite)
                            .font(.system(size: 20, weight: .heavy))
                            .clipShape(Capsule())
                    }
                }
                .padding()
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                        animateButton = true
                    }
                    SoundManager.shared.playSound(named: "MainMenuTrack", loop: true)
                }
                .onDisappear {
                    SoundManager.shared.stopSound()
                }
            }
        }
    }
    
    private var reverseBlack: Color {
            colorScheme == .dark ? Color.white : Color.black
        }
    
    private var reverseWhite: Color {
            colorScheme == .dark ? Color.black : Color.white
        }
    
}

#Preview {
    MainMenuView()
}
