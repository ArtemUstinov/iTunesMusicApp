//
//  UIButton +.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 04.01.2021.
//  Copyright © 2021 Artem Ustinov. All rights reserved.
//

import UIKit

extension UIButton {
    
    convenience init (
        type: UIButton.ButtonType = .system,
        tintColor: UIColor = .darkText,
        text: String = "",
        image: UIImage = UIImage(),
        backgroundColor: UIColor = .clear,
        cornerRadius: CGFloat = 0
    ) {
        self.init(type: type)
        self.tintColor = tintColor
        setTitle(text, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        setImage(image, for: .normal)
        self.backgroundColor = backgroundColor
        layer.cornerRadius = cornerRadius
        translatesAutoresizingMaskIntoConstraints = false
    }
}
