//
//  HomeViewController.swift
//  QubeStackClient
//
//  Created by pratheepkumar on 20/11/19.
//  Copyright © 2019 Qube. All rights reserved.
//

import Foundation
import UIKit


class HomeViewController: UITabBarController,UITabBarControllerDelegate{
    override func viewDidLoad() {
        self.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
}
