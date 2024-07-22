import SwiftUI


enum GameMode {
    case singlePlayer
    case twoPlayer
}

enum Difficulty {
    case easy
    case medium
    case hard
    
}





struct ContentView: View {
    var gameMode: GameMode
    var Difficulty: Difficulty
    @ObservedObject var TicTac = TicTacModel()

    @EnvironmentObject var globalSettings: GlobalSettings
    
    @Binding var showRestartButton: Bool

    
    private var opponentText: String {
            gameMode == .singlePlayer ? "Computer" : "Player 2"
        }
    
    private var gameModeText: String {
            gameMode == .singlePlayer ? "AI?" : "FRIEND?"
        }
    
//    @State private var showRestartButton = false {
//        didSet {
//            globalSettings.showRestartButton
//        }
//    }
    
    var body: some View {
        
        ZStack {
            
            globalSettings.reverseWhite().ignoresSafeArea()
            
            VStack {
                
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
                
                Text(gameModeText)
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(globalSettings.reverseBlack())
                    .offset(x: 140, y: -25)
                    .rotationEffect(Angle(degrees: 10))
                
                
                HStack {
                    HStack{
                        
                        Text("Player 1:").font(.system(size: 20, weight: .bold))
                            .foregroundColor(globalSettings.reverseBlack())
                        Text("\(TicTac.playerXScore)").font(.system(size: 20, weight: .bold))
                            .foregroundColor(playerScoreColor(x: TicTac.playerXScore, o: TicTac.playerOScore))
                    }
                    Spacer()
                    HStack{
                        Text("\(opponentText): ").font(.system(size: 20, weight: .bold))
                            .foregroundColor(globalSettings.reverseBlack())
                        Text("\(TicTac.playerOScore)").font(.system(size: 20, weight: .bold))
                            .foregroundColor(playerScoreColor(x: TicTac.playerOScore, o: TicTac.playerXScore))
                    }
                    
                    
                    
                }
                .padding()
                
                let col = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)

                LazyVGrid(columns: col, spacing: globalSettings.connected ? 0 : 10, content: {
                    ForEach(0..<9) { i in
                        Button(action: {
                            TicTac.buttonTap(i: i, gameMode: gameMode, Difficulty: Difficulty)
                        }, label: {
                            Text(TicTac.buttonLabel(i:i, playerX:globalSettings.playerXSymbol, playerO:globalSettings.playerOSymbol))
                                .frame(width: globalSettings.connected ? 120 : 100, height: globalSettings.connected ? 120 : 100)
                                .background(tieBreaker(i:i))
                                .foregroundColor(globalSettings.reverseBlack())
                                .font(.system(size: globalSettings.symbolSize, weight: .heavy))
                                .overlay(
                                    Rectangle()
                                        .stroke(globalSettings.reverseBlack(), lineWidth: 3)
                                )
                        }).buttonStyle(NoEffectButtonStyle())
                    }
                })
                .padding(.vertical)
                if showRestartButton  {
                    Button(action: {
                        withAnimation {
                            showRestartButton.toggle()
                            TicTac.resetGame()
                        }
                        
                    }) {
                        Text("RESTART ↻")
                            .frame(width: 200, height: 50)
                            .background(globalSettings.reverseWhite())
                            .foregroundColor(globalSettings.reverseBlack())
                            .font(.system(size: 20, weight: .heavy))
                            .clipShape(Capsule())
                    }
                    .transition(.scale(scale: 0.1, anchor: .center).combined(with: .opacity))
                }
            }
            .padding()
            .onAppear {
                
                SoundManager.shared.playSound(named: "NextPage", volumeType: .effects)
            }

        }
        .onChange(of: TicTac.winner) {
            if TicTac.winner != nil {
                withAnimation(.easeOut(duration: 0.5)) {
                    showRestartButton.toggle()
//                    globalSettings.updateRestart()
                }
            }
        }
    }
    
    private func tieBreaker(i: Int) -> Color {
        if TicTac.winner != .T {
            return TicTac.winningCombination.contains(i) ? .green : globalSettings.reverseWhite()
        }
        else {
            return .red
        }
    }
    
    private func playerScoreColor(x: Int, o: Int) -> Color {
        if x > o {
                return .green
        } else if x < o {
                return .red
            } else {
                return globalSettings.darkMode ? globalSettings.reverseWhite() : globalSettings.reverseBlack()
            }
        }
}

struct NoEffectButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}




//
//#Preview {
//    ContentView(gameMode: .twoPlayer, Difficulty: .medium, showRestartButton: Binding<false>)
//        .environmentObject(GlobalSettings())
//}
