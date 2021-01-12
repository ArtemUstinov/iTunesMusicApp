//
//  ErrorAlertController.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 11.01.2021.
//  Copyright © 2021 Artem Ustinov. All rights reserved.
//

import UIKit

class AlertController: UIAlertController {
    
    func show(with title: Error,
              completion: @escaping (UIAlertController) -> Void) {
        let alertController = UIAlertController(
            title: "No data",
            message: title.localizedDescription,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            completion(alertController)
        }
    }
}
