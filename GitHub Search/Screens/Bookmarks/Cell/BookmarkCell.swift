//
//  BookmarkCell.swift
//  GitHub Search
//
//  Created by Sergey on 23/08/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import UIKit
import SwipeCellKit

class BookmarkCell: SwipeTableViewCell {
    
    @IBOutlet weak var repositoryName: UILabel!
    
    @IBOutlet weak var ownerName: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func layoutSubviews() {
        avatarImageView.round()
    }
}
