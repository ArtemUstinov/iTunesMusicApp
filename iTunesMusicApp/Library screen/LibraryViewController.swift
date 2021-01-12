//
//  LibraryViewController.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 02.01.2021.
//  Copyright (c) 2021 Artem Ustinov. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController {
    
    //MARK: - Properties:
    weak var tabBarDelegate: TabBarControllerDelegate?
    
    let tableView = UITableView()
    private var favouriteTracks = StorageManager.shared.fetchTracks()
    private var currentTrackIndex: IndexPath?
    
    //MARK: - UI elements:
    private let bottomLineView = UIView(
        backgroundColor: .opaqueSeparator,
        alpha: 0.7
    )
    
    private let favouriteTracksStackView = UIStackView(
        axis: .vertical,
        spacing: 10
    )
    private let buttonsStackView = UIStackView(
        axis: .horizontal,
        distribution: .fillEqually,
        spacing: 20
    )
    
    private let playTrackButton = UIButton(
        tintColor: #colorLiteral(red: 0.9098039216, green: 0.2705882353, blue: 0.3529411765, alpha: 1),
        image: UIImage(systemName: "play.fill") ?? UIImage(),
        backgroundColor: .secondarySystemBackground,
        cornerRadius: 10
    )
    private let sortListButton = UIButton(
        tintColor: #colorLiteral(red: 0.9098039216, green: 0.2705882353, blue: 0.3529411765, alpha: 1),
        text: "A-Z",
        backgroundColor: .secondarySystemBackground,
        cornerRadius: 10
    )
    
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
    
    //MARK: - Private methods:
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
    
    //MARK: - UI Targets
    private func addTargets() {
        playTrackButton.addTarget(
            self,
            action: #selector(handlePlayButtonTapped),
            for: .touchUpInside
        )
        sortListButton.addTarget(
            self,
            action: #selector(handleSortListButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func handlePlayButtonTapped() {
        
        if !favouriteTracks.isEmpty {
            let indexPath = IndexPath(row: 0, section: 0)
            
            tableView.selectRow(at: indexPath,
                                animated: true,
                                scrollPosition: .bottom)
            currentTrackIndex = indexPath
            let track = favouriteTracks.first
            tabBarDelegate?.setMaximizedTrackDetailView(cellViewModel: track)
            
            UIWindow().getKeyWindow(forPlayTrack: self)
        }
    }
    
    @objc private func handleSortListButtonTapped() {
        let date = "First added"
        let az = "A-Z"
        if sortListButton.titleLabel?.text == az {
            favouriteTracks =
                favouriteTracks.sorted {
                    $0.trackName ?? "" < $1.trackName ?? ""
            }
            sortListButton.setTitle(date, for: .normal)
        } else {
            favouriteTracks = StorageManager.shared.fetchTracks()
            sortListButton.setTitle(az, for: .normal)
        }
        tableView.reloadData()
        tableView.selectRow(at: currentTrackIndex,
                            animated: true,
                            scrollPosition: .middle)
    }
    
    //MARK: - Setup Layout
    private func setupLayoutFooterStackView() {
        view.addSubview(favouriteTracksStackView)
        
        favouriteTracksStackView.addArrangedSubview(buttonsStackView)
        
        favouriteTracksStackView.addArrangedSubview(bottomLineView)
        favouriteTracksStackView.addArrangedSubview(tableView)
        
        buttonsStackView.addArrangedSubview(playTrackButton)
        buttonsStackView.addArrangedSubview(sortListButton)
        NSLayoutConstraint.activate([
            favouriteTracksStackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 20),
            favouriteTracksStackView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: 0),
            favouriteTracksStackView.leadingAnchor.constraint(
                equalTo: view.readableContentGuide.leadingAnchor,
                constant: 0),
            favouriteTracksStackView.trailingAnchor.constraint(
                equalTo: view.readableContentGuide.trailingAnchor,
                constant: 0),
            
            buttonsStackView.heightAnchor.constraint(equalToConstant: 50),
            
            bottomLineView.heightAnchor.constraint(equalToConstant: 1)
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
        
        let cell: LibraryTrackCell =
            tableView.dequeueReusableCell(for: indexPath)
        
        let track = favouriteTracks[indexPath.row]
        cell.configureCell(with: track)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        currentTrackIndex = indexPath
        UIWindow().getKeyWindow(forPlayTrack: self)
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
    
    func moveBackForPreviousTrack() -> CellSearchModel.Cell? {
        getTrack(isForwardTrack: false)
    }
    
    func moveForwardForNextTrack() -> CellSearchModel.Cell? {
        getTrack(isForwardTrack: true)
    }
    
    private func getTrack(isForwardTrack: Bool) -> CellSearchModel.Cell? {
        
        guard let indexPath =
            tableView.indexPathForSelectedRow else { return nil }
        
        var nextIndexPath = IndexPath(row: 0, section: 0)
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



