//
//  ViewController.swift
//  Tetris
//
//  Created by 五十嵐諒 on 2023/06/29.
//

import UIKit

class ViewController: UIViewController {
    let WIDTH = 10
    let HEIGHT = 15

    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            let layout = UICollectionViewFlowLayout()
            let length = collectionView.layer.frame.width / CGFloat(WIDTH) - 1
            layout.itemSize = CGSize(width: length, height: length)
            layout.minimumLineSpacing = 1
            layout.minimumInteritemSpacing = 0
            collectionView.collectionViewLayout = layout
        }
    }
    @IBOutlet var startButton: UIButton!
    @IBOutlet var gameOverLabel: UILabel!
    
    var game: Game! {
        didSet {
            game.delegate = self
            self.board = game.board
        }
    }
    
    var board:[[GameCell]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        game = Game(widthSize: WIDTH, heightSize: HEIGHT)
    }
    
    @IBAction func startButtonClicked() {
        print("startButton Clicked")
        game.start()
        startButton.isEnabled = false
    }
    
    @IBAction func rotateButtonClicked() {
        print("rotateButton Clicked")
        game.rotateMino()
    }
    
    @IBAction func leftButtonClicked() {
        print("leftButton Clicked")
        game.leftMino()
        
    }
    
    @IBAction func downButtonClicked() {
        print("downButton Clicked")
        game.downMino()
    }
    
    @IBAction func rightButtonClicked() {
        print("rightButton Clicked")
        game.rightMino()
        
    }
}


extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WIDTH * HEIGHT
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let gameCell = board[indexPath.row / WIDTH][indexPath.row % WIDTH]
        cell.backgroundColor = gameCell.color
        return cell
    }
}

extension ViewController: GameDelegate {
    func boardUpdated(_ game: Game, board: [[GameCell]]) {
        self.board = board
        collectionView.reloadData()
    }
    
    func gameOver(_ game: Game) {
        gameOverLabel.isHidden = false
        startButton.isEnabled = true
    }
}
