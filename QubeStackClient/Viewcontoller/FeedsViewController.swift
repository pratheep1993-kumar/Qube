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
    
     private var datas: [String] = ["Bulbasaur","Caterpie", "Golem", "Jynx", "Marshtomp", "Salamence", "Riolu", "Araquanid"]
     var options = SwipeMenuViewOptions()
       var dataCount: Int = 5
    
    override func viewDidLoad() {
        datas.forEach { data in
            let storyboard: UIStoryboard = UIStoryboard(name: "FeedsTableView", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
            vc.title = data
          //  vc.content = data
            self.addChild(vc)
        }
      super.viewDidLoad()
    }
    
}
