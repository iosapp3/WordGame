//
//  WordViewCell.swift
//  WordGame
//
//  Created by Vincent Fan on 4/5/2020.
//  Copyright © 2020 Vincent Fan. All rights reserved.
//

import UIKit

class WordViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            UIView.transition(with: self.cellLabel, duration: 0.7, options: .transitionFlipFromBottom, animations: {
                let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self.cellLabel.text!)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                if self.isSelected {
                    self.cellLabel.attributedText = attributeString
                } else {
                    self.cellLabel.attributedText = NSAttributedString(string: attributeString.string)
                }
            }, completion: nil)
        }
    }
}
