//
//  SearchViewController.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 25.12.2020.
//  Copyright (c) 2020 Artem Ustinov. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: AnyObject {
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UITableViewController, SearchDisplayLogic {
    
    //MARK: - Properties:
    private lazy var footerView = FooterView()
    private var albums = CellSearchViewModel(cells: [])
    private var timer: Timer?
    private var currentTrackIndex: IndexPath?
    
    private let searchController =
        UISearchController(searchResultsController: nil)
    private var isFiltering: Bool {
        !(searchController.searchBar.text?.isEmpty ?? false)
    }
    
    weak var tabBarDelegate: TabBarControllerDelegate?
    
    //MARK: - Setup cleanArchitecture
    var interactor: SearchBusinessLogic?
    var router: (NSObjectProtocol & SearchRoutingLogic)?
    
    private func setup() {
        let viewController = self
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        let router = SearchRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayFooterView:
            footerView.showLoaderIndicator()
        case .displaySearchData(let searchViewModel):
            self.albums = searchViewModel
            DispatchQueue.main.async {
                self.tableView.reloadData()
//                self.tableView.contentInset.bottom = self.tabBarController?.tabBar.safeAreaInsets.bottom ?? .zero
                self.footerView.hideLoaderIndicator()
            }
        }
    }
    
    // MARK: - Override methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupTableView()
        setupSearchController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        /// добавить пачку проверок, есть ли индекс, тот ли трек и тд

//        guard let index = currentTrackIndex,
//              let _ = tableView.cellForRow(at: index) else { return }
//
//        tableView.selectRow(at: index,
//                            animated: true,
//                            scrollPosition: .middle)
    }
    
    //MARK: - Private methods:
    private func setupTableView() {
        tableView.register(SearchTrackCell.self)
        tableView.tableFooterView = footerView
        tableView.rowHeight = 84
        tableView.backgroundColor = .secondarySystemBackground

//        tableView.contentInset.bottom = 64
    }
    
    /// не размещай марки близко друг к другу, они конфликтуют на Minimap
    /// MARK: Routing
}

// MARK: - TableView
extension SearchViewController {
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        isFiltering ? (albums.cells?.count ?? 0) : 0
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SearchTrackCell = tableView.dequeueReusableCell(for: indexPath)
        let result = getFilteredTracks(indexPath: indexPath)
        cell.configureCell(with: result)
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.text = "Please enter search term above"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForHeaderInSection section: Int) -> CGFloat {
        
        let halfScreen = UIScreen.main.bounds.height / 1.5
        let cellsIsEmpty = albums.cells?.isEmpty == true
        return cellsIsEmpty ? halfScreen : 0
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        UIWindow().getKeyWindow(forTrack: self)
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
        searchController.searchBar.placeholder = "Name of track"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        /// Разберись как отменять предыдущие запросы, что бы не было возможности отображения "просроченных" данных
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            withTimeInterval: 0.4,
            repeats: false,
            block: { [weak self] _ in
                self?.interactor?
                    .makeRequest(request: Search.Model.Request
                        .RequestType.getSearchData(searchText: searchText))
        })
    }
    
    private func getFilteredTracks(indexPath: IndexPath) -> CellSearchViewModel.Cell {
        
        guard let tracks = isFiltering ? albums.cells?[indexPath.row] : nil else {
            fatalError("Don't have sorted search")
        }
        return tracks
    }
}

// MARK: - TrackMovingDelegate
extension SearchViewController: TrackMovingDelegate {
    
    func moveBackForPreviousTrack() -> CellSearchViewModel.Cell? {
        getTrack(isForwardTrack: false)
    }
    
    func moveForwardForNextTrack() -> CellSearchViewModel.Cell? {
        getTrack(isForwardTrack: true)
    }
    
    private func getTrack(isForwardTrack: Bool) -> CellSearchViewModel.Cell? {
        
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

