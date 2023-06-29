//
//  ViewController.swift
//  Tetris
//
//  Created by 五十嵐諒 on 2023/06/29.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            let layout = UICollectionViewFlowLayout()
            let length = collectionView.layer.frame.width / 10 - 1
            layout.itemSize = CGSize(width: length, height: length)
            layout.minimumLineSpacing = 1
            layout.minimumInteritemSpacing = 0
            collectionView.collectionViewLayout = layout
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}


extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 120
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .darkGray
        print(indexPath.row)
        return cell
    }
}
