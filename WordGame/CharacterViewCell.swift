//
//  CharacterViewCell.swift
//  WordGame
//
//  Created by Vincent Fan on 2/5/2020.
//  Copyright © 2020 Vincent Fan. All rights reserved.
//

import UIKit

class CharacterViewCell: UICollectionViewCell {
    
    @IBOutlet weak var characterLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: {
                self.characterLabel.transform = self.isSelected ? CGAffineTransform(scaleX: 1.3, y: 1.3).concatenating(CGAffineTransform(translationX: 0, y: -3)) : .identity
            })
        }
    }
}
