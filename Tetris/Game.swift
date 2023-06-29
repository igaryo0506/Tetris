//
//  Game.swift
//  Tetris
//
//  Created by 五十嵐諒 on 2023/06/29.
//

import UIKit
class Game {
    let width: Int
    let height: Int
    let board: [[GameCell]]
    init(widthSize:Int, heightSize:Int){
        self.width = widthSize
        self.height = heightSize
        self.board = [[GameCell]](repeating: [GameCell](repeating: GameCell(color: .black), count: widthSize), count: heightSize)
    }
}

struct GameCell {
    var color: UIColor
}
