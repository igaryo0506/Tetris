//
//  Game.swift
//  Tetris
//
//  Created by 五十嵐諒 on 2023/06/29.
//

import UIKit

protocol GameDelegate {
    func game(_ game: Game, boardUpdatedAt board: [[GameCell]])
}

class Game {
    private let width: Int
    private let height: Int
    private let startPosition: (Int, Int)
    
    // TODO: board to be private and state should be telled when state changed through delegate method
    var board: [[GameCell]]
    var delegate: GameDelegate?
    private var currentMino: Mino?

    init(widthSize:Int, heightSize:Int){
        self.width = widthSize
        self.height = heightSize
        self.board = [[GameCell]](repeating: [GameCell](repeating: GameCell(minoType: nil), count: widthSize), count: heightSize)
        self.startPosition = (0, (widthSize + 1) / 2 - 1)
        currentMino = nil
    }
    
    func start(){
        startRepeatingAction()
        createNewBlock()
    }
    
    private func startRepeatingAction(){
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] _ in
            delegate?.game(self, boardUpdatedAt: self.board)
            // self.printBoard()
        })
    }
    
    private func createNewBlock(){
        currentMino = Mino(minoType: .o, startPosition: startPosition)
        guard let currentMino else { return }
        let minoShape = currentMino.getMinoShape()
        for gameCellPosition in minoShape {
            board[currentMino.minoPosition.0 + gameCellPosition.0][currentMino.minoPosition.1 + gameCellPosition.1] = GameCell(minoType: currentMino.minoType)
        }
    }
    
    private func printBoard() {
        board.forEach{ line in
            print(line.map{
                return $0.minoType?.rawValue ?? -1
            })
        }
    }
}

struct GameCell {
    let minoType: MinoType?
    var color: UIColor {
        if let minoType {
            switch minoType {
            case .i:
                return .red
            case .o:
                return .blue
            case .t:
                return .green
            case .s:
                return .yellow
            case .z:
                return .purple
            case .j:
                return .orange
            case .l:
                return .brown
            }
        } else {
            return .black
        }
    }
}

enum MinoType: Int {
    case i = 0
    case o = 1
    case t = 2
    case s = 3
    case z = 4
    case j = 5
    case l = 6
}

struct Mino {
    var minoType: MinoType
    var minoPosition: (Int,Int)
    
    init(minoType: MinoType, startPosition: (Int, Int)) {
        self.minoType = minoType
        self.minoPosition = startPosition
    }
    
    func getMinoShape() -> [(Int, Int)] {
        // TODO: add other pattern
        switch minoType {
        case .i:
            break
        case .o:
            break
        case .t:
            break
        case .s:
            break
        case .z:
            break
        case .j:
            break
        case .l:
            break
        }
        // case o
        return [(0,0),(0,1),(1,0),(1,1)]
    }
}
