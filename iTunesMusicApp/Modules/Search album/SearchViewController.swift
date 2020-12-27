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
    
    //MARK: - Private properties:
    private let cellIdentifier = "SearchAlbumCell"
    
    private let searchController =
        UISearchController(searchResultsController: nil)
    
    private var albums = SearchViewModel(cells: [])
    
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
        case .some:
            print("Some...")
        case .displayAlbums(let searchViewModel):
            self.albums = searchViewModel
            print("Search response!")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: Setup
    private func setup() {
        let viewController        = self
        let interactor            = SearchInteractor()
        let presenter             = SearchPresenter()
        let router                = SearchRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    //MARK: - Private methods:
    private func setupTableView() {
        tableView.register(SearchAlbumCell.self,
                                forCellReuseIdentifier: cellIdentifier)
        
        tableView.backgroundColor = .secondarySystemBackground
    }
    
    private func performTo(_ viewController: UIViewController) {
        let detailAlbumVC = viewController
        detailAlbumVC.modalPresentationStyle = .popover
        present(detailAlbumVC, animated: true)
    }

    //  // MARK: Object lifecycle
    //
    //  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    //    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    //    setup()
    //  }
    //
    //  required init?(coder aDecoder: NSCoder) {
    //    super.init(coder: aDecoder)
    //    setup()
    //  }
    
    
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
            tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                               for: indexPath) as? SearchAlbumCell else {
                                                fatalError("Error! Not cell")
        }
        
        let result = getFilteredAlbums(indexPath: indexPath)
        
        cell.configureCell(with: result)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        66
    }
    
    override func tableView(_ tableView: UITableView,
                                 didSelectRowAt indexPath: IndexPath) {
        
        performTo(DetailAlbumViewController())
    }
}


//MARK: - UISearch bar delegate
extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.4,
                                     repeats: false,
                                     block: { [weak self] _ in
                                        self?.interactor?.makeRequest(request: Search.Model.Request.RequestType.getAlbums(searchText: searchText))
        })
    }
    
    private func setupSearchController() {
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder =
        "Album or singer"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func getFilteredAlbums(indexPath: IndexPath) -> SearchViewModel.Cell? {
        
        isFiltering ? albums.cells?[indexPath.item] : nil
    }
}
