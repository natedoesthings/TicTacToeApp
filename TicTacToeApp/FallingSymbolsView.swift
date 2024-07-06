import SwiftUI

struct FallingSymbolsView: View {
    @State private var positions: [CGPoint] = Array(repeating: .zero, count: 20)
    
    private let symbols = ["X", "O"]
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<positions.count, id: \.self) { index in
                    Text(symbols.randomElement() ?? "X")
                        .font(.system(size: 30, weight: .bold))
                        .position(positions[index])
                        .animation(.linear(duration: 5).repeatForever(autoreverses: false), value: positions[index])
                        .blur(radius: 3)
                }
            }
            .onAppear {
                for index in positions.indices {
                    positions[index] = CGPoint(x: CGFloat.random(in: 0...geometry.size.width), y: CGFloat.random(in: 0...geometry.size.height))
                }
            }
            .onReceive(timer) { _ in
                for index in positions.indices {
                    positions[index].y += 10
                    if positions[index].y > geometry.size.height {
                        positions[index].y = -30
                        positions[index].x = CGFloat.random(in: 0...geometry.size.width)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    FallingSymbolsView()
}
