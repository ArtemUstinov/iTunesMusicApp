//
//  FooterView.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 28.12.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import UIKit

class FooterView: UIView {
    
    //MARK: - Private properties:
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.631372549, green: 0.6470588235, blue: 0.662745098, alpha: 1)
        return label
    }()
    
    private let loaderIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    //MARK: - Initializers:
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods:
    private func setupElements() {
        
        addSubview(loadingLabel)
        addSubview(loaderIndicator)
        
        NSLayoutConstraint.activate([
            loaderIndicator.topAnchor.constraint(equalTo: topAnchor,
                                                 constant: 8),
            loaderIndicator.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                     constant: 20),
            loaderIndicator.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                      constant: -20),
            
            loadingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingLabel.topAnchor.constraint(equalTo: loaderIndicator.bottomAnchor,
                                              constant: 8)
        ])
    }
    
     func showLoaderIndicator() {
        loaderIndicator.startAnimating()
        loadingLabel.text = "LOADING"
    }
    
     func hideLoaderIndicator() {
        loaderIndicator.stopAnimating()
        loadingLabel.text = ""
    }
}
