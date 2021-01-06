//
//  UIImageView +.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 05.01.2021.
//  Copyright © 2021 Artem Ustinov. All rights reserved.
//

import UIKit

extension UIImageView {
    
    convenience init (
        image: UIImage,
        autoresizing: Bool = false
    ) {
        self.init()
        self.image = image
        translatesAutoresizingMaskIntoConstraints = autoresizing
    }
}
