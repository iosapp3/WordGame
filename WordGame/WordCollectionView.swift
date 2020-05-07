//
//  WordCollectionView.swift
//  WordGame
//
//  Created by Vincent Fan on 4/5/2020.
//  Copyright © 2020 Vincent Fan. All rights reserved.
//

import UIKit

class WordCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout ,UICollectionViewDataSource {
    
    var words: [String] = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.delegate = self
        self.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.bounds.width/CGFloat(ceil(Float(words.count).squareRoot()))
        let height = self.bounds.height/CGFloat(floor(Float(words.count).squareRoot()))
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let wordCell = collectionView.dequeueReusableCell(withReuseIdentifier: "wordCell", for: indexPath) as! WordViewCell
        wordCell.cellLabel.text = words[indexPath.row]
        return wordCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func selectCell(target: String) {
        let indexPath = IndexPath(row: words.firstIndex(of: target)!, section: 0)
        self.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
    }
    
    func deselectAllCell() {
        reloadData()
    }
}
