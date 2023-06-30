//
//  Game.swift
//  Tetris
//
//  Created by 五十嵐諒 on 2023/06/29.
//

import UIKit

protocol GameDelegate {
    func boardUpdated(_ game: Game, board: [[GameCell]])
    func gameOver(_ game: Game)
}

class Game {
    private let width: Int
    private let height: Int
    private let startPosition: (Int, Int)
    
    // TODO: board to be private and state should be telled when state changed through delegate method
    var board: [[GameCell]]
    var delegate: GameDelegate?
    private var currentMino: Mino?
    private var gameOverCells: [(Int,Int)]
    private var timer: Timer?

    init(widthSize:Int, heightSize:Int){
        self.width = widthSize
        self.height = heightSize
        self.board = [[GameCell]](repeating: [GameCell](repeating: GameCell(minoType: nil), count: widthSize), count: heightSize)
        self.startPosition = (0, (widthSize + 1) / 2 - 1)
        self.gameOverCells = [
            (startPosition.0, startPosition.1),
            (startPosition.0, startPosition.1 + 1),
            (startPosition.0 + 1, startPosition.1),
            (startPosition.0 + 1, startPosition.1 + 1),]
        currentMino = nil
    }
    
    func start(){
        initializeBoard()
        createNewBlock()
        startRepeatingAction()
    }
    
    func rotateMino(){
        if currentMino != nil, checkCanRotate(mino: currentMino!){
            currentMino?.rotate()
            mergeBoard()
        }
    }
    
    func downMino(){
        guard let mino = currentMino else { return }
        if checkStop(mino: mino, diff: (1,0)){
            let minoCellPositions = mino.getMinoCellPositions()
            for minoCellPosition in minoCellPositions {
                board[mino.minoPosition.0 + minoCellPosition.0][mino.minoPosition.1 + minoCellPosition.1] = GameCell(minoType: mino.minoType)
            }
            deleteLine()
            for gameOverCell in gameOverCells {
                if board[gameOverCell.0][gameOverCell.1].minoType != nil{
                    gameOver()
                    return
                }
            }
            createNewBlock()
            return
        }
        if checkCanMove(mino: mino, diff: (1,0)) {
            currentMino?.move(diff: (1,0))
            mergeBoard()
        }
    }
    
    private func initializeBoard() {
        board = [[GameCell]](repeating: [GameCell](repeating: GameCell(minoType: nil), count: width), count: height)
    }
    
    private func gameOver(){
        timer?.invalidate()
        delegate?.gameOver(self)
    }
    
    private func deleteLine() {
        for (index,line) in board.enumerated() {
            var isAllExist = true
            for cell in line {
                if cell.minoType == nil {
                    isAllExist = false
                }
            }
            if isAllExist {
                board.remove(at: index)
                board = [[GameCell](repeating: GameCell(minoType: nil), count: line.count)] + board
                mergeBoard()
            }
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
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] _ in
            downMino()
            mergeBoard()
        })
    }
    
    private func mergeBoard(){
        var showingBoard = board
        if let currentMino {
            let minoCellPositions = currentMino.getMinoCellPositions()
            for minoCellPosition in minoCellPositions {
                showingBoard[currentMino.minoPosition.0 + minoCellPosition.0][currentMino.minoPosition.1 + minoCellPosition.1] = GameCell(minoType: currentMino.minoType)
            }
        }
        delegate?.boardUpdated(self, board: showingBoard)
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
    
    private func checkCanRotate(mino: Mino) -> Bool {
        let newRotationState = (mino.rotationState + 1) % 4
        let minoCellPositions = Mino.MINOPOSITIONS[mino.minoType.rawValue]![newRotationState]
        for minoCellPosition in minoCellPositions {
            let toMinoCellPosition = (mino.minoPosition.0 + minoCellPosition.0, mino.minoPosition.1 + minoCellPosition.1)
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
    var rotationState: Int
    
    static let MINOPOSITIONS: [String: [[(Int, Int)]]] = [
        "i": [[(0,-1),(0,0),(0,1),(0,2)], [(0,1),(1,1),(2,1),(3,1)],[(0,-1),(0,0),(0,1),(0,2)], [(0,1),(1,1),(2,1),(3,1)]],
        "o": [[(0,0),(0,1),(1,0),(1,1)], [(0,0),(0,1),(1,0),(1,1)], [(0,0),(0,1),(1,0),(1,1)],  [(0,0),(0,1),(1,0),(1,1)]],
        "t": [[(0,-1),(0,0),(0,1),(1,0)], [(0,1),(1,0),(1,1),(2,1)], [(1,0),(2,-1),(2,0),(2,1)], [(0,-1),(1,-1),(1,0),(2,-1)]],
        "s": [[(0,-1),(0,0),(1,0),(1,1)], [(0,1),(1,0),(1,1),(2,0)], [(0,-1),(0,0),(1,0),(1,1)], [(0,1),(1,0),(1,1),(2,0)]],
        "z": [[(0,1),(0,0),(1,0),(1,-1)], [(0,0),(1,0),(1,1),(2,1)],
              [(0,1),(0,0),(1,0),(1,-1)], [(0,0),(1,0),(1,1),(2,1)]],
        "j": [[(0,0),(0,1),(0,2),(1,2)], [(0,2),(1,2),(2,2),(2,1)], [(1,0),(2,0),(2,1),(2,2)], [(0,0),(0,1),(1,0),(2,0)]],
        "l": [[(0,0),(0,1),(0,2),(1,0)], [(0,1),(0,2),(1,2),(2,2)], [(1,2),(2,0),(2,1),(2,2)], [(0,0),(1,0),(2,0),(2,1)]]
    ]
    
    init(startPosition: (Int, Int)) {
        self.minoType = MinoType.allCases.randomElement()!
        self.minoPosition = startPosition
        self.rotationState = 0
    }
    
    func getMinoCellPositions() -> [(Int, Int)] {
        Mino.MINOPOSITIONS[minoType.rawValue]![rotationState]
    }
    
    mutating func move(diff: (Int, Int)){
        minoPosition = (minoPosition.0 + diff.0, minoPosition.1 + diff.1)
    }
    
    mutating func rotate() {
        rotationState = (rotationState+1) % 4
    }
}
