//
//  LibraryViewController.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 02.01.2021.
//  Copyright (c) 2021 Artem Ustinov. All rights reserved.
//

import UIKit

protocol LibraryDisplayLogic: class {
    func displayData(viewModel: Library.Model.ViewModel.ViewModelData)
}

class LibraryViewController: UIViewController, LibraryDisplayLogic {
    
    //MARK: - Setup cleanArchitecture
    
    var interactor: LibraryBusinessLogic?
    var router: (NSObjectProtocol & LibraryRoutingLogic)?
    
    private func setup() {
        let viewController        = self
        let interactor            = LibraryInteractor()
        let presenter             = LibraryPresenter()
        let router                = LibraryRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    func displayData(viewModel: Library.Model.ViewModel.ViewModelData) {
        
    }
    
    //MARK: - Private properties:
    private let tableView = UITableView()
    
    private var favouriteTracks = StorageManager.shared.fetchTracks()
    
    //MARK: - UIViews:
    private let bottomLineView: UIView = {
        let view = UIView()
        view.alpha = 0.7
        view.backgroundColor = .opaqueSeparator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - UIStackViews:
    private let footerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - UIButtons:
    private let playTrackButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = #colorLiteral(red: 0.9098039216, green: 0.2705882353, blue: 0.3529411765, alpha: 1)
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 10
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let refreshListButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = #colorLiteral(red: 0.9098039216, green: 0.2705882353, blue: 0.3529411765, alpha: 1)
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 10
        button.setImage(UIImage(systemName: "arrow.2.circlepath"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Routing
    
    
    
    // MARK: Override methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        addSubviews()
        setupLayoutFooterStackView()
    }
    
    //MARK: - Setup TableView
    private func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self

        /// Скрываем пустые ячейки если у нас нет данных
        tableView.tableFooterView = UIView()
        
        tableView.rowHeight = 84
        view.backgroundColor = .white
        
        tableView.register(
            LibraryTrackCell.self,
            forCellReuseIdentifier: LibraryTrackCell.cellIdentifier
        )
    }
    
    //MARK: - Setup Layout
    private func addSubviews() {
        view.addSubview(footerStackView)
    }
    
    
    private func setupLayoutFooterStackView() {
        NSLayoutConstraint.activate([
            footerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                 constant: 20),
            footerStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                    constant: 0),
            footerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                     constant: 20),
            footerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                      constant: -20),
        ])
        
        footerStackView.addArrangedSubview(buttonsStackView)
        NSLayoutConstraint.activate([
            buttonsStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        buttonsStackView.addArrangedSubview(playTrackButton)
        
        buttonsStackView.addArrangedSubview(refreshListButton)
        
        footerStackView.addArrangedSubview(bottomLineView)
        NSLayoutConstraint.activate([
            bottomLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        footerStackView.addArrangedSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                               constant: 0),
            tableView.trailingAnchor.constraint(equalTo: footerStackView.trailingAnchor,
                                                constant: 0),
        ])
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension LibraryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        favouriteTracks.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LibraryTrackCell.cellIdentifier,
            for: indexPath
            ) as? LibraryTrackCell
            else { fatalError("Have not cell") }
        
        let track = favouriteTracks[indexPath.row]
        cell.configureCell(with: track)
        
        return cell
    }
}
