//
//  FeedsViewController.swift
//  QubeStackClient
//
//  Created by pratheepkumar on 20/11/19.
//  Copyright © 2019 Qube. All rights reserved.
//

import Foundation
import UIKit
import SwipeMenuViewController


class FeedsViewController: SwipeMenuViewController{
    
    let categoryList: [Category] = [
        Category.init(title: "Activity", sortType: "activity"),
        Category.init(title: "Hot", sortType: "hot"),
        Category.init(title: "Votes", sortType: "votes"),
        Category.init(title: "Created Date", sortType: "creation")
    ]
    
    var options = SwipeMenuViewOptions()
    var dataCount: Int = 5
    
    override func viewDidLoad() {
        categoryList.forEach { data in
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
            vc.title = data.title
            vc.category = data
            self.addChild(vc)
        }
        changeColorBasedOnMode()
        super.viewDidLoad()
    }
    
    func changeColorBasedOnMode(){
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .gray
        } else {
            view.backgroundColor = .white
        }
    }
}
