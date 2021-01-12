//
//  UIWindow +.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 06.01.2021.
//  Copyright © 2021 Artem Ustinov. All rights reserved.
//

import UIKit

extension UIWindow {
    
    func getKeyWindow(forPlayTrack viewController: UIViewController) {
        let keyWindow =
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let tabBarVC =
            keyWindow?.rootViewController as? TabBarController
        
        tabBarVC?.trackDetailView.trackMovingDelegate
            = viewController as? TrackMovingDelegate
    }
}
