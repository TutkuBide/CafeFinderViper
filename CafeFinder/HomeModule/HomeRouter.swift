//
//  HomeRouter.swift
//  CafeFinder
//
//  Created by tutkubide on 24.10.2020.
//

import UIKit

protocol HomeRouterInterface {
    func  openListView(with model: [VenuesModel], nav: UINavigationController)
}

class HomeRouter: HomeRouterInterface {
    
    func createModule() -> UIViewController {
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let interactor = HomeInteractor()
        let router = HomeRouter()
        let presenter = HomePresenter(interactor: interactor, router: router)
        view.presenter = presenter
        return view
    }
    
    func openListView(with model: [VenuesModel], nav: UINavigationController) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let vcc = main.instantiateViewController(identifier: "CafeListViewController") as! CafeListViewController
        vcc.model = model
        nav.pushViewController(vcc, animated: true)
    }
}
