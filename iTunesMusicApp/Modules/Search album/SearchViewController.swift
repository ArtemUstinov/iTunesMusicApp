//
//  SearchViewController.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 25.12.2020.
//  Copyright (c) 2020 Artem Ustinov. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: class {
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UITableViewController, SearchDisplayLogic {
    
    //MARK: - Public properties:
    var interactor: SearchBusinessLogic?
    var router: (NSObjectProtocol & SearchRoutingLogic)?
    
    weak var tabBarDelegate: TabBarControllerDelegate?
    
    //MARK: - Private properties:    
    private let searchController =
        UISearchController(searchResultsController: nil)
    
    private lazy var footerView = FooterView()
    
    private var albums = CellSearchViewModel(cells: [])
    
    private var timer: Timer?
    
    private var isFiltering: Bool {
        !(searchController.searchBar.text?.isEmpty ?? false)
    }
    
    // MARK: - Override methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setup()
        setupSearchController()
        
    }
    
    override func loadView() {
        super.loadView()
    }
    
    //MARK: - Public methods:
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
        
        switch viewModel {
        case .displayFooterView:
            footerView.showLoaderIndicator()
        case .displaySearchData(let searchViewModel):
            self.albums = searchViewModel
            print("Search response!")
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.footerView.hideLoaderIndicator()
            }
        }
    }
    
    // MARK: Setup
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
    
    //MARK: - Private methods:
    private func setupTableView() {
        tableView.register(SearchTrackCell.self,
                           forCellReuseIdentifier: SearchTrackCell.cellIdentifier)
        
        tableView.tableFooterView = footerView
        
        tableView.rowHeight = 84
        tableView.backgroundColor = .secondarySystemBackground
    }
    
    private func performTo(_ viewController: UIViewController) {
        let detailAlbumVC = viewController
        detailAlbumVC.modalPresentationStyle = .popover
        present(detailAlbumVC, animated: true)
    }
    
    // MARK: Routing
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchViewController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        
        isFiltering ? (albums.cells?.count ?? 0) : 0
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell =
            tableView.dequeueReusableCell(withIdentifier: SearchTrackCell.cellIdentifier,
                                          for: indexPath) as? SearchTrackCell else {
                                            fatalError("Error! Not cell")
        }
        
        let result = getFilteredAlbums(indexPath: indexPath)
        
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
        
        let halfScreen = UIScreen.main.bounds.height / 2
        return (albums.cells?.count ?? 0) > 0 ? 0 : halfScreen
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        let selectedTrack = getFilteredAlbums(indexPath: indexPath)
        tabBarDelegate?.setMaximizedTrackDetailView(cellViewModel: selectedTrack)
        
//        guard let window = UIApplication.shared.windows.first else { return }
//        let trackDetailView = TrackDetailView(frame: window.frame)
//        trackDetailView.trackMovingDelegate = self
//        trackDetailView.set(cellViewModel: selectedTrack)
//        window.addSubview(trackDetailView)
    }
}


//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchResultsUpdating  {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
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
    
    private func setupSearchController() {
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder =
        "Name of track"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func getFilteredAlbums(indexPath: IndexPath) -> CellSearchViewModel.Cell {
        
        guard let isFiltering = isFiltering ? albums.cells?[indexPath.item] : nil else {
            fatalError("Don't have sorted search")
        }
        return isFiltering
    }
}

extension SearchViewController: TrackMovingDelegate {
    
    private func getTrack(isForwardTrack: Bool) -> CellSearchViewModel.Cell? {
        guard let indexPath =
            tableView.indexPathForSelectedRow else { return nil }
        var nextIndexPath: IndexPath!
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
        
        let cellSearchViewModel = albums.cells?[nextIndexPath.row]
        return cellSearchViewModel
    }
    
    func moveBackForPreviousTrack() -> CellSearchViewModel.Cell? {
        getTrack(isForwardTrack: false)
    }
    
    func moveForwardForNextTrack() -> CellSearchViewModel.Cell? {
        getTrack(isForwardTrack: true)
    }
}
