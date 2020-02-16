//
//  CollectionViewCell.swift
//  Notes Manager
//
//  Created by Alexey Mefodyev on 27.01.2020.
//  Copyright © 2020 LexMefodyev. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var emojiLabel: UILabel!
}
