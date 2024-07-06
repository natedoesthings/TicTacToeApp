import SwiftUI


enum GameMode {
    case singlePlayer
    case twoPlayer
}




struct ContentView: View {
    var gameMode: GameMode
    @ObservedObject var TicTac = TicTacModel()
    
    private var opponentText: String {
            gameMode == .singlePlayer ? "Bot" : "Player 2"
        }
    
    private var gameModeText: String {
            gameMode == .singlePlayer ? "AI?" : "FRIEND?"
        }
    
    
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
                                .stroke(Color.black, lineWidth: 10)
                            }
                        )
                }
                
                Text(gameModeText)
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(.black)
                    .offset(x: 140, y: -25)
                    .rotationEffect(Angle(degrees: 10))
                
                
                HStack {
                    HStack{
                        
                        Text("Player 1:").font(.system(size: 20, weight: .bold))
                        Text("\(TicTac.playerXScore)").font(.system(size: 20, weight: .bold))
                            .foregroundColor(TicTac.playerScoreColor(playerXScore: TicTac.playerXScore,playerOScore: TicTac.playerOScore))
                    }
                    Spacer()
                    HStack{
                        Text("\(opponentText): ").font(.system(size: 20, weight: .bold))
                        Text("\(TicTac.playerOScore)").font(.system(size: 20, weight: .bold))
                            .foregroundColor(TicTac.playerScoreColor(playerXScore: TicTac.playerOScore,playerOScore: TicTac.playerXScore))
                    }
                    
                    
                    
                }
                .padding()
                
                let col = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
                
                LazyVGrid(columns: col, content: {
                    ForEach(0..<9) { i in
                        Button(action: {
                            TicTac.buttonTap(i: i, gameMode: gameMode)
                            
                        }, label: {
                            var textColor: Color {
                                TicTac.buttonLabel(i:i) == "X" ? .black : .white
                                }
                            
                            var background: Color {
                                TicTac.winningCombination.contains(i) ? .green : .white
                                }
                            
                            Text(TicTac.buttonLabel(i:i))
                                .frame(width: 100, height: 100)
                                .background(background)
                                .foregroundColor(.black)
                                .font(.system(size: 45, weight: .heavy))
                                .overlay(
                                    Rectangle()
                                        .stroke(Color.black, lineWidth: 3)
                                )
                        })
                    }
                })
                .padding(.bottom)
                
                Button(action: {
                    TicTac.resetGame()
                }, label: {
                    Text("RESET GAME")
                        .frame(width: 200, height: 50)
                        .background(.black)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .heavy))
                        .clipShape(Capsule())
                })
            }
            .padding()
//            
//            if !TicTic.winningCombination.isEmpty {
//                            WinningLineView(winningCombination: TicTic.winningCombination)
//                                .transition(.opacity)
//                        }
        }
    }
}

#Preview {
    ContentView(gameMode: .singlePlayer)
}
