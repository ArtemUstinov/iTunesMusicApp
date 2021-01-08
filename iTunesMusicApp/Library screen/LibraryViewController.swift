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
    
    //MARK: - Private properties:
    private let tableView = UITableView()
    private var favouriteTracks = StorageManager.shared.fetchTracks()
    private var currentTrackIndex: IndexPath?
    
    weak var tabBarDelegate: TabBarControllerDelegate?
    
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
    
    //MARK: - UI elements:
    private let bottomLineView = UIView(alpha: 0.7,
                                        backgroundColor: .opaqueSeparator)
    
    private let favouriteTracksStackView = UIStackView(axis: .vertical,
                                                       distribution: .fill,
                                                       spacing: 10)
    private let buttonsStackView = UIStackView(axis: .horizontal,
                                               distribution: .fillEqually,
                                               spacing: 20)
    
    private let playTrackButton = UIButton(
        tintColor: #colorLiteral(red: 0.9098039216, green: 0.2705882353, blue: 0.3529411765, alpha: 1),
        image: UIImage(systemName: "play.fill") ?? UIImage(),
        state: .normal,
        backgroundColor: .secondarySystemBackground,
        cornerRadius: 10
    )
    
    private let sortListButton = UIButton(
        tintColor: #colorLiteral(red: 0.9098039216, green: 0.2705882353, blue: 0.3529411765, alpha: 1),
        text: "A-Z",
        state: .normal,
        backgroundColor: .secondarySystemBackground,
        cornerRadius: 10
    )
    
////     MARK: Routing
    
    // MARK: - Override methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        addTargets()
        setupLayoutFooterStackView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getRefreshTrackList()
    }
    
    private func getRefreshTrackList() {
        let refreshTrackList = StorageManager.shared.fetchTracks()
        if refreshTrackList.count != favouriteTracks.count {
            favouriteTracks = refreshTrackList
            tableView.reloadData()
        }
    }
    
    //MARK: - Setup TableView
    private func setupTableView() {
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LibraryTrackCell.self)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 84
    }
    
    //MARK: - Targets
    private func addTargets() {
        playTrackButton.addTarget(self,
                                  action: #selector(handlePlayButtonTapped),
                                  for: .touchUpInside)
        
        sortListButton.addTarget(self,
                                    action: #selector(handleRefreshButtonTapped),
                                    for: .touchUpInside)
    }
    
    @objc private func handlePlayButtonTapped() {
                        
        if !favouriteTracks.isEmpty {
            let indexPath = IndexPath(row: 0, section: 0)
            
            tableView.selectRow(at: indexPath,
                                animated: true,
                                scrollPosition: .bottom)
            let track = favouriteTracks[0]
            tabBarDelegate?.setMaximizedTrackDetailView(cellViewModel: track)

            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let tabBarVC = keyWindow?.rootViewController as? TabBarController
            tabBarVC?.trackDetailView.trackMovingDelegate = self

        }
    }
    
    @objc private func handleRefreshButtonTapped() {
        let date = "First added"
        let az = "A-Z"
        getRefreshTrackList()
        if sortListButton.titleLabel?.text == az {
            favouriteTracks =
            favouriteTracks.sorted {$0.trackName ?? "" < $1.trackName ?? ""}
            sortListButton.setTitle(date, for: .normal)
        } else {
            favouriteTracks = StorageManager.shared.fetchTracks()
            sortListButton.setTitle(az, for: .normal)
        }
        tableView.reloadData()
    }
    
    //MARK: - Setup Layout
    private func setupLayoutFooterStackView() {
        view.addSubview(favouriteTracksStackView)
        
        favouriteTracksStackView.addArrangedSubview(buttonsStackView)
        
        buttonsStackView.addArrangedSubview(playTrackButton)
        buttonsStackView.addArrangedSubview(sortListButton)
        
        favouriteTracksStackView.addArrangedSubview(bottomLineView)
        favouriteTracksStackView.addArrangedSubview(tableView)
        
        NSLayoutConstraint.activate([
            favouriteTracksStackView.topAnchor.constraint(equalTo:
                view.safeAreaLayoutGuide.topAnchor,
                                                          constant: 20),
            favouriteTracksStackView.bottomAnchor.constraint(equalTo:
                view.safeAreaLayoutGuide.bottomAnchor,
                                                             constant: 0),
            favouriteTracksStackView.leadingAnchor.constraint(equalTo:
                view.safeAreaLayoutGuide.leadingAnchor,
                                                              constant: 20),
            favouriteTracksStackView.trailingAnchor.constraint(equalTo:
                view.safeAreaLayoutGuide.trailingAnchor,
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
        
        currentTrackIndex = indexPath
        UIWindow().getKeyWindow(forTrack: self)
        tableView.selectRow(at: indexPath,
                            animated: true,
                            scrollPosition: .middle)
        
        let track = favouriteTracks[indexPath.row]
        tabBarDelegate?.setMaximizedTrackDetailView(cellViewModel: track)
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        StorageManager.shared.deleteTrack(at: indexPath.row)
        favouriteTracks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

    //MARK: - TrackMovingDelegate
extension LibraryViewController: TrackMovingDelegate {
    
    func moveBackForPreviousTrack() -> CellSearchViewModel.Cell? {
        getTrack(isForwardTrack: false)
    }
    
    func moveForwardForNextTrack() -> CellSearchViewModel.Cell? {
        getTrack(isForwardTrack: true)
    }
    
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
}



