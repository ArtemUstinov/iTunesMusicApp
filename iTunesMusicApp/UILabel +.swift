//
//  UILabel +.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 04.01.2021.
//  Copyright © 2021 Artem Ustinov. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init (
        text: String = "",
        size: CGFloat = 17,
        weight: UIFont.Weight = .medium,
        alignment: NSTextAlignment = .natural,
        lines: Int = 1,
        color: UIColor = .darkText
    ) {
        self.init()
        self.text = text
        font = .systemFont(ofSize: size, weight: weight)
        textAlignment = alignment
        numberOfLines = lines
        textColor = color
        translatesAutoresizingMaskIntoConstraints = false
    }
}
