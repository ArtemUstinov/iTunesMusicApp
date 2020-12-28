//
//  AlbumViewController.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 27.12.2020.
//  Copyright (c) 2020 Artem Ustinov. All rights reserved.
//

import UIKit

protocol AlbumDisplayLogic: class {
    func displayData(viewModel: SelectedAlbum.Model.ViewModel.ViewModelData)
}

class AlbumViewController: UIViewController, AlbumDisplayLogic {
    
    //MARK: - Public properties:
    var interactor: AlbumBusinessLogic?
    var router: (NSObjectProtocol & AlbumRoutingLogic)?
    
    var tracks = TracksViewModel(tracks: [])
    var idAlbum: Int
    
    init(idAlbum: Int) {
        self.idAlbum = idAlbum
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private properties:    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .semibold)

        return label
    }()
    private let priceAlbumLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    private let tracksCountLabel = UILabel()
    
    private let albumImage: CachedImageView = {
        let image = CachedImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let tableView = UITableView()
    
    //MARK: - Override methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        setup()
        setupSubviews()
        performToInteractor(id: idAlbum)
    }
    
    //MARK: - Private methods:
    private func performToInteractor(id: Int) {
        interactor?.makeRequest(request: SelectedAlbum.Model.Request.RequestType.getAlbumInfo(albumId: id))
    }
    //    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    //        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    //        setup()
    //    }
    //
    //    required init?(coder aDecoder: NSCoder) {
    //        super.init(coder: aDecoder)
    //        setup()
    //    }
    
    // MARK: Setup
    
    private func setupUI() {
        tracks.tracks?.forEach({ track in
            albumNameLabel.text = track.albumName
            priceAlbumLabel.text = "\(track.priceOfAlbum ?? 0) \(track.currency ?? "")"
            tracksCountLabel.text = "The album has: \(tracks.tracks?.count ?? 0) tracks:"
            albumImage.setImage(url: track.coverUrlString, placeholder: #imageLiteral(resourceName: "album-art-empty"))
        })
    }
    
    private func setup() {
        let viewController        = self
        let interactor            = AlbumInteractor()
        let presenter             = AlbumPresenter()
        let router                = AlbumRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    private func setupSubviews() {
        view.addSubview(albumNameLabel)
        view.addSubview(priceAlbumLabel)
        view.addSubview(tracksCountLabel)
        view.addSubview(albumImage)
        view.addSubview(tableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        albumNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            albumNameLabel.topAnchor.constraint(equalTo: view.topAnchor,
                                                constant: 20),
            albumNameLabel.bottomAnchor.constraint(equalTo: albumImage.topAnchor,
                                                   constant: -28),
            albumNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor,
                                                 constant: 16),
            albumNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor,
                                                  constant: -16)])
        
        
        albumImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            albumImage.bottomAnchor.constraint(equalTo: priceAlbumLabel.topAnchor,
                                               constant: -18), //!
            albumImage.leftAnchor.constraint(equalTo: view.leftAnchor,
                                             constant: 70),
            albumImage.rightAnchor.constraint(equalTo: view.rightAnchor,
                                              constant: -70),
            albumImage.heightAnchor.constraint(equalToConstant: 253)])
        
        priceAlbumLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceAlbumLabel.topAnchor.constraint(equalTo: albumImage.bottomAnchor,
                                                 constant: 18),
            //            albumNameLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor,
            //                                                 constant: -3),
            priceAlbumLabel.leftAnchor.constraint(equalTo: view.leftAnchor,
                                                  constant: 16),
            priceAlbumLabel.rightAnchor.constraint(equalTo: view.rightAnchor,
                                                   constant: -70)])
        
        tracksCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tracksCountLabel.topAnchor.constraint(equalTo: priceAlbumLabel.bottomAnchor,
                                                  constant: 40),
            //            albumNameLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor,
            //                                                 constant: -3),
            tracksCountLabel.leftAnchor.constraint(equalTo: view.leftAnchor,
                                                   constant: 5),
            tracksCountLabel.rightAnchor.constraint(equalTo: view.rightAnchor,
                                                    constant: -20)])
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: tracksCountLabel.bottomAnchor,
                                           constant: 8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                              constant: 0),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor,
                                            constant: 0),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor,
                                             constant: 0)])
    }
    // MARK: Routing
    
    
    
    // MARK: View lifecycle
    
    func displayData(viewModel: SelectedAlbum.Model.ViewModel.ViewModelData) {
        
        switch viewModel {
        case .displayAlbumData(let tracksViewModel):
            self.tracks = tracksViewModel
            DispatchQueue.main.async {
                self.setupUI()
                self.tableView.reloadData()
            }
        }
    }
}
