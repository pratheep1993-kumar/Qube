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
           
           // Create Tab one
           let tabOne = FeedsViewController()
           let tabOneBarItem = UITabBarItem(title: "Tab 1", image: UIImage(named: "home-page.png"), selectedImage: UIImage(named: "home-selected.png"))
           
           tabOne.tabBarItem = tabOneBarItem
           
           
           // Create Tab two
           let tabTwo = MyQuestionsViewController()
           let tabTwoBarItem2 = UITabBarItem(title: "Tab 2", image: UIImage(named: "question.png"), selectedImage: UIImage(named: "question-selected.png"))
           
           tabTwo.tabBarItem = tabTwoBarItem2
           
           
           self.viewControllers = [tabOne, tabTwo]
       }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
         
      }
}
