import SwiftUI

struct MainMenuView: View {
    @State private var animateButton = false

    var body: some View {
        NavigationView {
            
            ZStack {
//                FallingSymbolsView()
//                    .blur(radius: 2)
                
                VStack {
                    Text("TIC TAC TOE")
                        .font(.system(size: 45, weight: .heavy))
                        .padding(.bottom, 50)
                    
                    NavigationLink(destination: ContentView(gameMode: .singlePlayer)) {
                        Text("Singleplayer")
                            .frame(width: animateButton ? 220 : 200, height: animateButton ? 55 : 50)
                            .background(.black)
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .heavy))
                            .clipShape(Capsule())
                    }
                    .padding(.bottom, 20)
                    
                    NavigationLink(destination: ContentView(gameMode: .twoPlayer)) {
                        Text("Multiplayer")
                            .frame(width: animateButton ? 220 : 200, height: animateButton ? 55 : 50)
                            .background(.black)
                            .foregroundColor(.white)
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
            }
        }
    }
}

#Preview {
    MainMenuView()
}
