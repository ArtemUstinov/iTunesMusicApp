//
//  UIView +.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 05.01.2021.
//  Copyright © 2021 Artem Ustinov. All rights reserved.
//

import UIKit

extension UIView {
    
    convenience init(
        backgroundColor: UIColor,
        alpha: CGFloat = 1
    ) {
        self.init()
        self.alpha = alpha
        self.backgroundColor = backgroundColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}
