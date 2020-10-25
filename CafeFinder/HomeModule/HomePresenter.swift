//
//  HomePresenter.swift
//  CafeFinder
//
//  Created by tutkubide on 24.10.2020.
//

import Foundation
import UIKit

protocol HomePresenterInterface {
    func viewDidLoad()
	func fetch()
    func openDetail(with model: [VenuesModel], navigation: UINavigationController)
	func getModel() -> [VenuesModel]
}

class HomePresenter {
    var interactor: HomeInteractorInterface
    var router: HomeRouterInterface
    
    init(interactor: HomeInteractorInterface, router: HomeRouterInterface) {
        self.interactor = interactor
        self.router = router
    }
}

extension HomePresenter: HomePresenterInterface {
    func viewDidLoad() {
       print("This Page HomePresenterInterface")
    }
	
	func fetch() {
		 self.interactor.fetchCafeList()
	}
	
    func openDetail(with model: [VenuesModel], navigation: UINavigationController) {
        self.router.openListView(with: model, nav: navigation)
	}
	
	func getModel() -> [VenuesModel] {
		return self.interactor.getModel()
	}
}
