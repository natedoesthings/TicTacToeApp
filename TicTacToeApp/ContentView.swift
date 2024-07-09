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
    
    @Environment(\.colorScheme) var colorScheme
    
    private var opponentText: String {
            gameMode == .singlePlayer ? "Computer" : "Player 2"
        }
    
    private var gameModeText: String {
            gameMode == .singlePlayer ? "AI?" : "FRIEND?"
        }
    
    @State private var showRestartButton = false
    
    
    var body: some View {
        
        ZStack {
            VStack {
                
                HStack(spacing: 0) {
                    Text("TIK-TAK-")
                        .font(.system(size: 45, weight: .heavy))
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
                }
                
                Text(gameModeText)
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(reverseBlack)
                    .offset(x: 140, y: -25)
                    .rotationEffect(Angle(degrees: 10))
                
                
                HStack {
                    HStack{
                        
                        Text("Player 1:").font(.system(size: 20, weight: .bold))
                        Text("\(TicTac.playerXScore)").font(.system(size: 20, weight: .bold))
                            .foregroundColor(TicTac.playerScoreColor(playerXScore: TicTac.playerXScore,playerOScore: TicTac.playerOScore, colorScheme:colorScheme))
                    }
                    Spacer()
                    HStack{
                        Text("\(opponentText): ").font(.system(size: 20, weight: .bold))
                        Text("\(TicTac.playerOScore)").font(.system(size: 20, weight: .bold))
                            .foregroundColor(TicTac.playerScoreColor(playerXScore: TicTac.playerOScore,playerOScore: TicTac.playerXScore, colorScheme:colorScheme))
                    }
                    
                    
                    
                }
                .padding()
                
                let col = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
                
                LazyVGrid(columns: col, content: {
                    ForEach(0..<9) { i in
                        Button(action: {
                            TicTac.buttonTap(i: i, gameMode: gameMode, Difficulty: Difficulty)
                            
                        }, label: {
                            Text(TicTac.buttonLabel(i:i))
                                .frame(width: 100, height: 100)
                                .background(tieBreaker(i:i))
                                .foregroundColor(reverseBlack)
                                .font(.system(size: 45, weight: .heavy))
                                .overlay(
                                    Rectangle()
                                        .stroke(reverseBlack, lineWidth: 3)
                                )
                        })
                    }
                })
                .padding(.bottom)
                if showRestartButton {
                    Button(action: {
                        withAnimation {
                            showRestartButton = false
                        }
                        TicTac.resetGame()
                    }) {
                        Text("RESTART ↻")
                            .frame(width: 200, height: 50)
                            .background(reverseWhite)
                            .foregroundColor(reverseBlack)
                            .font(.system(size: 20, weight: .heavy))
                            .clipShape(Capsule())
                    }
                    .transition(.scale(scale: 0.1, anchor: .center).combined(with: .opacity))
                }
            }
            .padding()
            .onAppear {
                
                SoundManager.shared.playSound(named: "NextPage")
            }

        }
        .onChange(of: TicTac.winner) {
            if TicTac.winner != nil && !TicTac.board.isEmpty {
                withAnimation(.easeOut(duration: 0.5)) {
                    showRestartButton = true
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
    
    private func tieBreaker(i: Int) -> Color {
        if TicTac.winner != .T {
            return TicTac.winningCombination.contains(i) ? .green : reverseWhite
        }
        else {
            return .red
        }
    }
}

#Preview {
    ContentView(gameMode: .singlePlayer, Difficulty: .medium)
}
