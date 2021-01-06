//
//  UIStackView +.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 04.01.2021.
//  Copyright © 2021 Artem Ustinov. All rights reserved.
//

import UIKit

extension UIStackView {
    
    convenience init (
        axis: NSLayoutConstraint.Axis = .horizontal,
        distribution: UIStackView.Distribution = .fill,
        spacing: CGFloat = 0,
        alignment: UIStackView.Alignment = .fill,
        autoresizing: Bool = false
    ) {
        self.init()
        self.axis = axis
        self.distribution = distribution
        self.spacing = spacing
        self.alignment = alignment
        translatesAutoresizingMaskIntoConstraints = autoresizing
    }
}

