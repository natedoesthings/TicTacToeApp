import SwiftUI

struct ContentView: View {
    
    @ObservedObject var TicTic = TicTacModel()
    
    var body: some View {
        VStack {
            Text("TIC TAC TOE").font(.system(size: 45, weight: .heavy))
            
            HStack {
                Text("Player X: \(TicTic.playerXScore)").font(.system(size: 20, weight: .bold))
                Spacer()
                Text("Bot: \(TicTic.playerOScore)").font(.system(size: 20, weight: .bold))
            }
            .padding()
            
            let col = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
            
            LazyVGrid(columns: col, content: {
                ForEach(0..<9) { i in
                    Button(action: {
                        TicTic.buttonTap(i:i)
                        
                    }, label: {
                        Text(TicTic.buttonLabel(i:i))
                            .frame(width: 100, height: 100)
                            .background(.white)
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
                TicTic.resetGame()
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
    }
}

#Preview {
    ContentView()
}
