//
//  ContentViewController.swift
//  QubeStackClient
//
//  Created by pratheepkumar on 21/11/19.
//  Copyright © 2019 Qube. All rights reserved.
//

import Foundation
import UIKit
import  ObjectMapper



class ContentViewController: UIViewController {

    @IBOutlet weak var feedsListing: UITableView!
    let animals: [String] = ["Horse", "Cow", "Camel", "Sheep", "Goat"]

    

    var content: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.feedsListing.register(UINib(nibName: "FeedsTableViewCell", bundle: nil), forCellReuseIdentifier: "My_Reserved_Drinks_Cell")
        getAllQuestions()
    }
    
    func getAllQuestions() {
          Services.getAllQuestion(completionHandler: { response in
            let _: AllQuestionResponse = Mapper<AllQuestionResponse>().map(JSON: response.result.value as! [String: Any])!

              self.feedsListing.reloadData()
          }) { _ in
          }
      }
    
}

extension ContentViewController: UITableViewDelegate, UITableViewDataSource {
 func numberOfSections(in _: UITableView) -> Int {
     return 1
 }

 func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return animals.count
 }


 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell: FeedsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "My_Reserved_Drinks_Cell", for: indexPath) as! FeedsTableViewCell
    cell.sample.text = self.animals[indexPath.row]
     return cell
 }

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("You tapped cell number \(indexPath.row).")
}

}



