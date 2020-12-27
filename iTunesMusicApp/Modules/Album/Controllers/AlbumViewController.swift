//
//  AlbumViewController.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 27.12.2020.
//  Copyright (c) 2020 Artem Ustinov. All rights reserved.
//

import UIKit

protocol AlbumDisplayLogic: class {
  func displayData(viewModel: Album.Model.ViewModel.ViewModelData)
}

class AlbumViewController: UIViewController, AlbumDisplayLogic {

  var interactor: AlbumBusinessLogic?
  var router: (NSObjectProtocol & AlbumRoutingLogic)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
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
  
  // MARK: Routing
  

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func displayData(viewModel: Album.Model.ViewModel.ViewModelData) {

  }
  
}
