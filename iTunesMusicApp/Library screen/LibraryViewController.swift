//
//  LibraryViewController.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 02.01.2021.
//  Copyright (c) 2021 Artem Ustinov. All rights reserved.
//

import UIKit

protocol LibraryDisplayLogic: AnyObject {
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
    
    weak var tabBarDelegate: TabBarControllerDelegate?
    
    
    
    
    //MARK: - UIViews:
    private let bottomLineView: UIView = {
        let view = UIView()
        view.alpha = 0.7
        view.backgroundColor = .opaqueSeparator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - UI elements:
    private let favouriteTracksStackView = UIStackView(axis: .vertical,
                                                       distribution: .fill,
                                                       spacing: 10)
    
    private let buttonsStackView = UIStackView(axis: .horizontal,
                                               distribution: .fillEqually,
                                               spacing: 20)
    
    private let playTrackButton = UIButton(
        tintColor: #colorLiteral(red: 0.9098039216, green: 0.2705882353, blue: 0.3529411765, alpha: 1),
        image: UIImage(systemName: "play.fill")!,
        state: .normal,
        backgroundColor: .secondarySystemBackground,
        cornerRadius: 10
    )
    
    private let refreshListButton = UIButton(
        tintColor: #colorLiteral(red: 0.9098039216, green: 0.2705882353, blue: 0.3529411765, alpha: 1),
        image: UIImage(systemName: "arrow.2.circlepath")!,
        state: .normal,
        backgroundColor: .secondarySystemBackground,
        cornerRadius: 10
    )
    
    
    // MARK: Routing
    
    
    
    // MARK: Override methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupTableView()
        
        addTargets()
        
        addSubviews()
        setupLayoutFooterStackView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getRefreshTrackList()
    }
    
    private func getRefreshTrackList() {
        
        let refreshTrackList = StorageManager.shared.fetchTracks()
        if refreshTrackList.count != favouriteTracks.count {
            favouriteTracks = StorageManager.shared.fetchTracks()
            tableView.reloadData()
        }
    }
    
    //MARK: - Setup TableView
    private func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LibraryTrackCell.self)
        
        /// Скрываем пустые ячейки если у нас нет данных
        tableView.tableFooterView = UIView()
        
        tableView.rowHeight = 84
        view.backgroundColor = .white
    }
    
    private func addTargets() {
        playTrackButton.addTarget(self,
                                  action: #selector(handlePlayButtonTapped),
                                  for: .touchUpInside)
        
        refreshListButton.addTarget(self,
                                    action: #selector(handleRefreshButtonTapped),
                                    for: .touchUpInside)
    }
    
    
    @objc private func handlePlayButtonTapped() {
        if !favouriteTracks.isEmpty {
            let track = favouriteTracks.first
            tabBarDelegate?.setMaximizedTrackDetailView(cellViewModel: track)
            
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let tabBarVC = keyWindow?.rootViewController as? TabBarController
            tabBarVC?.trackDetailView.trackMovingDelegate = self
        }
    }
    
    @objc private func handleRefreshButtonTapped() {
        getRefreshTrackList()
        
    }
    
    //MARK: - Setup Layout
    private func addSubviews() {
        view.addSubview(favouriteTracksStackView)
    }
    
    
    private func setupLayoutFooterStackView() {
        favouriteTracksStackView.addArrangedSubview(buttonsStackView)
        
        buttonsStackView.addArrangedSubview(playTrackButton)
        buttonsStackView.addArrangedSubview(refreshListButton)
        
        favouriteTracksStackView.addArrangedSubview(bottomLineView)
        favouriteTracksStackView.addArrangedSubview(tableView)
        
        NSLayoutConstraint.activate([
            favouriteTracksStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                          constant: 20),
            favouriteTracksStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                             constant: 0),
            favouriteTracksStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                              constant: 20),
            favouriteTracksStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                               constant: -20),
            
            buttonsStackView.heightAnchor.constraint(equalToConstant: 50),
            
            bottomLineView.heightAnchor.constraint(equalToConstant: 1),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: 0),
            tableView.trailingAnchor.constraint(equalTo: favouriteTracksStackView.trailingAnchor,
                                                constant: 0)
        ])
    }
}


//MARK: - UITableViewDataSource, UITableViewDelegate:
extension LibraryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        favouriteTracks.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: LibraryTrackCell = tableView.dequeueReusableCell(for: indexPath)
        
        let track = favouriteTracks[indexPath.row]
        cell.configureCell(with: track)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        let track = favouriteTracks[indexPath.row]
        tabBarDelegate?.setMaximizedTrackDetailView(cellViewModel: track)
        
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let tabBarVC = keyWindow?.rootViewController as? TabBarController
        tabBarVC?.trackDetailView.trackMovingDelegate = self
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        StorageManager.shared.deleteTrack(at: indexPath.row)
        favouriteTracks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension LibraryViewController: TrackMovingDelegate {
            
       private func getTrack(isForwardTrack: Bool) -> CellSearchViewModel.Cell? {
            
            guard let indexPath =
                tableView.indexPathForSelectedRow else { return nil }
            
            var nextIndexPath = IndexPath(row: 0, section: 0) // !
            if isForwardTrack {
                nextIndexPath = IndexPath(row: indexPath.row + 1,
                                          section: indexPath.section)
                nextIndexPath.row == favouriteTracks.count
                    ? nextIndexPath.row = 0
                    : nil
            } else {
                nextIndexPath = IndexPath(row: indexPath.row - 1,
                                          section: indexPath.section)
                nextIndexPath.row == -1
                    ? nextIndexPath.row = favouriteTracks.count - 1
                    : nil
            }
            tableView.selectRow(at: nextIndexPath,
                                animated: true,
                                scrollPosition: .middle)
            
            let cellSearchViewModel = favouriteTracks[nextIndexPath.row]
            return cellSearchViewModel
        }
    
    func moveBackForPreviousTrack() -> CellSearchViewModel.Cell? {
        
        getTrack(isForwardTrack: false)
    }
    
    func moveForwardForNextTrack() -> CellSearchViewModel.Cell? {
        
        getTrack(isForwardTrack: true)
    }
}



