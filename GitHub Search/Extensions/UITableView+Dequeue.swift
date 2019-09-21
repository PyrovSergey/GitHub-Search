//
//  UITableView+Dequeue.swift
//  GitHub Search
//
//  Created by Sergey on 21/08/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import UIKit

public extension UITableView {
    
    func dequeueReusableCell<CellType: UITableViewCell>(for indexPath: IndexPath) -> CellType? {
        
        let typeName = String(describing: CellType.self)
        
        guard let cell = dequeueReusableCell(withIdentifier: typeName, for: indexPath) as? CellType else {
            return nil
        }
        return cell
    }
}
