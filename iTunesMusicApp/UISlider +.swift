//
//  UISlider +.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 05.01.2021.
//  Copyright © 2021 Artem Ustinov. All rights reserved.
//

import UIKit

extension UISlider {
    
    convenience init (
        value: Float = 0.5
    ) {
        self.init()
        self.value = value
        minimumTrackTintColor = .lightGray
        maximumTrackTintColor = .secondarySystemBackground
        translatesAutoresizingMaskIntoConstraints = false
    }
}
