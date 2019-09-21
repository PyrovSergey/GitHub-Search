//
//  RepositoryCell.swift
//  GitHub Search
//
//  Created by Sergey on 21/08/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {
    
    @IBOutlet weak var repositoryName: UILabel!
    
    @IBOutlet weak var ownerName: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func layoutSubviews() {
        avatarImageView.round()
    }
}
