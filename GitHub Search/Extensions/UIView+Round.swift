//
//  UIView+Round.swift
//  GitHub Search
//
//  Created by Sergey on 22/08/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import UIKit


public extension UIView {
    
    func round() {
        
        let width = bounds.width < bounds.height ? bounds.width : bounds.height
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(ovalIn: CGRect(x: bounds.midX - width / 2, y: bounds.midY - width / 2, width: width, height: width)).cgPath
        self.layer.mask = mask
    }
}
