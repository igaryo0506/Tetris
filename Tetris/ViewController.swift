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
    
    var game: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        game = Game(widthSize: WIDTH, heightSize: HEIGHT)
    }
    
    @IBAction func startButtonClicked() {
        print("startButton Clicked")
    }
    
    @IBAction func rotateButtonClicked() {
        print("rotateButton Clicked")
    }
    
    @IBAction func leftButtonClicked() {
        print("leftButton Clicked")
        
    }
    
    @IBAction func downButtonClicked() {
        print("downButton Clicked")
        
    }
    
    @IBAction func rightButtonClicked() {
        print("rightButton Clicked")
        
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
        
        let gameCell = game.board[indexPath.row / WIDTH][indexPath.row % WIDTH]
        cell.backgroundColor = gameCell.color
        return cell
    }
}
