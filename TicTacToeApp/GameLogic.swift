import Foundation

enum Player {
    case X
    case O
}

class TicTacModel: ObservableObject {
    
    @Published var board:[Player?] = Array(repeating: nil, count: 9)
    @Published var activePlayer:Player = .X
    @Published var winner:Player? = nil
    @Published var playerXScore: Int = 0
    @Published var playerOScore: Int = 0
    
    //Button Pressed
    func buttonTap(i:Int) {
        
        guard board[i] == nil && winner == nil else {
            return
        }
        
        board[i] = activePlayer
                
        if checkWinner() {
            winner = activePlayer
            if activePlayer == .X {
                playerXScore += 1
            } else {
                playerOScore += 1
            }
            print("\(activePlayer) has won the game!")
        }
        else {
            activePlayer = (activePlayer == .X) ? .O : .X
            if activePlayer == .O {
                botMove()
            }
        }
    }
    
    //Label of button, return label
    func buttonLabel(i:Int) -> String {
        if let player = board[i] {
            return player == .X ? "X" : "O"
        }
        return ""
    }
    
    //Reset Game
    func resetGame() {
        board = Array(repeating: nil, count: 9)
        activePlayer = .X
        winner = nil
    }
    
    //Check for winner
    func checkWinner() -> Bool {
        
        // check the rows
        for i in stride(from: 0, to: 9, by: 3) {
            if board[i] == activePlayer && board[i + 1] == activePlayer && board[i + 2] == activePlayer {
                return true
            }
        }
        
        // check the columns
        for i in 0..<3{
            if board[i] == activePlayer && board[i + 3] == activePlayer && board[i + 6] == activePlayer {
                return true
            }
        }
        
        // Diagonals
        if board[0] == activePlayer && board[4] == activePlayer && board[8] == activePlayer {
            return true
        }
        
        if board[2] == activePlayer && board[4] == activePlayer && board[6] == activePlayer {
            return true
        }
        
        return false
    }
    
    // Bot's move
    func botMove() {
        var availableMoves = [Int]()
        for i in 0..<board.count {
            if board[i] == nil {
                availableMoves.append(i)
            }
        }
        
        if let move = availableMoves.randomElement() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.buttonTap(i: move)
            }
        }
    }
}
