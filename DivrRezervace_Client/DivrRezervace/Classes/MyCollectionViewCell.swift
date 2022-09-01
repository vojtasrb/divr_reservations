//
//  MyCollectionViewCell.swift
//  DivrRezervace
//
//  Created by Vojtěch Srb on 16/09/2019.
//  Copyright © 2019 Vojtěch Srb. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var playerNumber: UILabel!
    @IBOutlet weak var gameLang: UIImageView!
    @IBOutlet weak var statusImage: UIImageView!
    
    var oldColor = UIColor.brown
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                oldColor = (self.backgroundColor)!
            }
            else {
                self.backgroundColor = oldColor
                self.transform = CGAffineTransform.identity
            }
        }
    }
    
    func selectedLang() -> String {
        if gameLang.image == UIImage(named: "czech") {
            return "czech"
        }
        else if gameLang.image == UIImage(named: "eng") {
            return "eng"
        }
        else { return "" }
    }
    
    func selectedGame() -> String {
        if backgroundColor == UIColor.brown {
            return "brown"
        }
        else if backgroundColor == UIColor.red {
            return "red"
        }
        else if backgroundColor == UIColor.black {
            return "black"
        }
        else { return "" }
    }
    
    func selectedStatus() -> String {
        if statusImage.image == UIImage(named: "checkmark") {
            return "checkmark"
        }
        else { return "" }
    }
}
