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
        createNewBlock()
        startRepeatingAction()
    }
    
    func downMino(){
        guard let mino = currentMino else { return }
        if checkStop(mino: mino, diff: (1,0)){
            let minoCellPositions = mino.getMinoCellPositions()
            for minoCellPosition in minoCellPositions {
                board[mino.minoPosition.0 + minoCellPosition.0][mino.minoPosition.1 + minoCellPosition.1] = GameCell(minoType: mino.minoType)
            }
            createNewBlock()
            return
        }
        if checkCanMove(mino: mino, diff: (1,0)) {
            currentMino?.move(diff: (1,0))
            mergeBoard()
        }
    }
    
    func leftMino(){
        guard let mino = currentMino else { return }
        if checkCanMove(mino: mino, diff: (0,-1)) {
            currentMino?.move(diff: (0,-1))
            mergeBoard()
        }
    }
    
    func rightMino(){
        guard let mino = currentMino else { return }
        if checkCanMove(mino: mino, diff: (0,1)) {
            currentMino?.move(diff: (0,1))
            mergeBoard()
        }
    }
    
    private func startRepeatingAction(){
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] _ in
            downMino()
            mergeBoard()
        })
    }
    
    private func mergeBoard(){
        if let currentMino {
            var showingBoard = board
            let minoCellPositions = currentMino.getMinoCellPositions()
            for minoCellPosition in minoCellPositions {
                showingBoard[currentMino.minoPosition.0 + minoCellPosition.0][currentMino.minoPosition.1 + minoCellPosition.1] = GameCell(minoType: currentMino.minoType)
            }
            delegate?.game(self, boardUpdatedAt: showingBoard)
        } else {
            delegate?.game(self, boardUpdatedAt: self.board)
        }
    }
    
    private func createNewBlock(){
        currentMino = Mino(startPosition: startPosition)
        mergeBoard()
    }
    
    private func checkCanMove(mino: Mino, diff: (Int, Int)) -> Bool {
        let minoCellPositions = mino.getMinoCellPositions()
        for minoCellPosition in minoCellPositions {
            let toMinoCellPosition = (mino.minoPosition.0 + minoCellPosition.0 + diff.0, mino.minoPosition.1 + minoCellPosition.1 + diff.1)
            if toMinoCellPosition.0 >= height {
                return false
            }
            if toMinoCellPosition.1 >= width {
                return false
            }
            if toMinoCellPosition.1 < 0 {
                return false
            }
            if board[toMinoCellPosition.0][toMinoCellPosition.1].minoType != nil {
                return false
            }
        }
        return true
    }
    private func checkStop(mino: Mino, diff: (Int, Int)) -> Bool {
        if diff.0 != 1 {
            return false
        }
        let minoCellPositions = mino.getMinoCellPositions()
        for minoCellPosition in minoCellPositions {
            let toMinoCellPosition = (mino.minoPosition.0 + minoCellPosition.0 + diff.0, mino.minoPosition.1 + minoCellPosition.1 + diff.1)
            if toMinoCellPosition.0 >= height {
                return true
            } else if board[toMinoCellPosition.0][toMinoCellPosition.1].minoType != nil {
                return true
            }
        }
        return false
    }
    
    private func printBoard(printedBoard: [[GameCell]]) {
        printedBoard.forEach{ line in
            print(line.map{
                return $0.minoType?.rawValue ?? " "
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

enum MinoType: String, CaseIterable {
    case i = "i"
    case o = "o"
    case t = "t"
    case s = "s"
    case z = "z"
    case j = "j"
    case l = "l"
}

struct Mino {
    var minoType: MinoType
    var minoPosition: (Int,Int)
    init(startPosition: (Int, Int)) {
        self.minoType = MinoType.allCases.randomElement()!
        self.minoPosition = startPosition
    }
    
    func getMinoCellPositions() -> [(Int, Int)] {
        // TODO: add other pattern
        switch minoType {
        case .i:
            return [(0,-1),(0,0),(0,1),(0,2)]
        case .o:
            return [(0,0),(0,1),(1,0),(1,1)]
        case .t:
            return [(0,-1),(0,0),(0,1),(1,0)]
        case .s:
            return [(0,-1),(0,0),(1,0),(1,1)]
        case .z:
            return [(0,0),(0,1),(1,-1),(1,0)]
        case .j:
            return [(0,0),(0,1),(0,2),(1,2)]
        case .l:
            return [(0,0),(0,1),(0,2),(1,0)]
        }
    }
    
    mutating func move(diff: (Int, Int)){
        minoPosition = (minoPosition.0 + diff.0, minoPosition.1 + diff.1)
    }
}
