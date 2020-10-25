//
//  HomeViewController.swift
//  CafeFinder
//
//  Created by tutkubide on 24.10.2020.
//

import UIKit
import MBProgressHUD

class HomeViewController: UIViewController {
    
    var presenter: HomePresenterInterface!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchButton.addTarget(self, action: #selector(buttonPressed), for: UIControl.Event.touchUpInside)
    }
    
    @objc func buttonPressed() {
        self.presenter.viewDidLoad()
        self.presenter?.fetch()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let model = self.presenter.getModel()
            self.presenter.openDetail(with: model, navigation: self.navigationController!)
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
