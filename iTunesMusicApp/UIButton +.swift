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
        image: UIImage,
        state: UIControl.State,
        backgroundColor: UIColor = .clear,
        cornerRadius: CGFloat = 0,
        autoresizing: Bool = false
    ) {
        self.init(type: type)
        self.tintColor = tintColor
        setImage(image, for: state)
        self.backgroundColor = backgroundColor
        layer.cornerRadius = cornerRadius
        translatesAutoresizingMaskIntoConstraints = autoresizing
        
    }
}

private let a: UIButton = {
    let button = UIButton(type: .system)
    button.tintColor = #colorLiteral(red: 0.9098039216, green: 0.2705882353, blue: 0.3529411765, alpha: 1)
    button.setImage(#imageLiteral(resourceName: "Add"), for: .normal)
    return button
}()
