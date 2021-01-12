//
//  SearchViewController.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 25.12.2020.
//  Copyright (c) 2020 Artem Ustinov. All rights reserved.
//

import UIKit

//MARK: - Protocols
protocol SearchDisplayLogic: AnyObject {
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

protocol SearchTrackCellDelegate {
    func saveTrack(track: CellSearchModel.Cell?)
}

class SearchViewController: UITableViewController, SearchDisplayLogic {
    
    //MARK: - Properties:
    weak var tabBarDelegate: TabBarControllerDelegate?
    
    private let alertController = AlertController()
    private lazy var footerView = FooterView()
    private var albums = CellSearchModel(cells: [])
    private var timer: Timer?
    private var currentTrackIndex: IndexPath?
    private var isFavouriteTrack = false
    
     let searchController =
        UISearchController(searchResultsController: nil)
    private var isFiltering: Bool {
        !(searchController.searchBar.text?.isEmpty ?? false)
    }
    
    //MARK: - Setup cleanArchitecture
    var interactor: SearchBusinessLogic?
    
    private func setup() {
        let viewController = self
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayFooterView:
            footerView.showLoaderIndicator()
        case .displaySearchData(let searchViewModel):
            self.albums = searchViewModel
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.footerView.hideLoaderIndicator()
            }
        case .displayError(let error):
            alertController.show(with: error) {
                [weak self] alert in
                self?.present(alert, animated: true)
            }
        case .displayFavouriteTrack(let isFavourite):
            self.isFavouriteTrack = isFavourite
        }
    }
    
    // MARK: - Override methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setup()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkCellForActivity()
        tableView.reloadData()
    }
    
    //MARK: - Private methods:
    private func setupTableView() {
        tableView.register(SearchTrackCell.self)
        tableView.tableFooterView = footerView
        tableView.rowHeight = 84
    }
    
    private func checkCellForActivity() {
        if searchController.isActive {
            tableView.selectRow(at: currentTrackIndex,
                                animated: true,
                                scrollPosition: .middle)
        }
    }    
}

// MARK: - TableView
extension SearchViewController {
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        isFiltering ? (albums.cells?.count ?? 0) : 0
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell: SearchTrackCell =
            tableView.dequeueReusableCell(for: indexPath)
        cell.searchTrackCellDelegate = self
        let result = getFilteredTracks(indexPath: indexPath)
        interactor?.makeRequest(request:
            Search.Model.Request.RequestType.getStorageData(forCell: result)
        )
        cell.configureCell(with: result, isFavourite: isFavouriteTrack)
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        
        let label = UILabel()
        label.text = "Please enter search term above"
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        return label
    }
    
    override func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        let halfScreen = UIScreen.main.bounds.height / 1.5
        let cellsIsEmpty = albums.cells?.isEmpty == true
        return cellsIsEmpty ? halfScreen : 0
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        UIWindow().getKeyWindow(forPlayTrack: self)
        currentTrackIndex = indexPath
        tableView.selectRow(at: indexPath,
                            animated: true,
                            scrollPosition: .middle)
        
        let selectedTrack = getFilteredTracks(indexPath: indexPath)
        tabBarDelegate?.setMaximizedTrackDetailView(cellViewModel: selectedTrack)
    }
}


//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchResultsUpdating  {
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Artist or track"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            withTimeInterval: 0.27,
            repeats: false,
            block: { [weak self] _ in
                self?.interactor?
                    .makeRequest(request: Search.Model.Request
                        .RequestType.getSearchData(searchText: searchText))
        })
    }
    
    private func getFilteredTracks(
        indexPath: IndexPath
    ) -> CellSearchModel.Cell {
        
        guard let tracks = isFiltering
            ? albums.cells?[indexPath.row]
            : nil else { fatalError("Don't have sorted search") }
        return tracks
    }
}

// MARK: - TrackMovingDelegate
extension SearchViewController: TrackMovingDelegate {
    
    func moveBackForPreviousTrack() -> CellSearchModel.Cell? {
        getTrack(isForwardTrack: false)
    }
    
    func moveForwardForNextTrack() -> CellSearchModel.Cell? {
        getTrack(isForwardTrack: true)
    }
    
    private func getTrack(isForwardTrack: Bool) -> CellSearchModel.Cell? {
        
        guard let indexPath =
            tableView.indexPathForSelectedRow else { return nil }
        
        var nextIndexPath = IndexPath()
        if isForwardTrack {
            nextIndexPath = IndexPath(row: indexPath.row + 1,
                                      section: indexPath.section)
            nextIndexPath.row == albums.cells?.count
                ? nextIndexPath.row = 0
                : nil
        } else {
            nextIndexPath = IndexPath(row: indexPath.row - 1,
                                      section: indexPath.section)
            nextIndexPath.row == -1
                ? nextIndexPath.row = (albums.cells?.count ?? 0) - 1
                : nil
        }
        tableView.selectRow(at: nextIndexPath,
                            animated: true,
                            scrollPosition: .middle)
        
        currentTrackIndex = nextIndexPath
        let cellSearchViewModel = albums.cells?[nextIndexPath.row]
        return cellSearchViewModel
    }
}

extension SearchViewController: SearchTrackCellDelegate {
    func saveTrack(track: CellSearchModel.Cell?) {
        interactor?.makeRequest(
            request:
            Search.Model.Request.RequestType.saveTrack(track: track)
        )
    }
}

