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

struct Category {
    var title: String
    var sortType: String
}

class ContentViewController: UIViewController {

    @IBOutlet weak var feedsListing: UITableView!

    var content: String = ""
    var category : Category?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.feedsListing.register(UINib(nibName: "FeedsTableViewCell", bundle: nil), forCellReuseIdentifier: "My_Reserved_Drinks_Cell")
        getAllQuestions()
    }
    
    func getAllQuestions() {
        let param = Parameters.getEta(page: "1", pagesize: "10", order: "asc", sort: category!.sortType, site: "stackoverflow", fromdate: "1556668800", todate: "1572566400")
          Services.getAllQuestion(parameters: param as [String: AnyObject],completionHandler: { response in
            let _: AllQuestionResponse = Mapper<AllQuestionResponse>().map(JSON: response.result.value as! [String: Any])!

          }) { _ in
          }
      }
    
}

extension ContentViewController: UITableViewDelegate, UITableViewDataSource {
 func numberOfSections(in _: UITableView) -> Int {
     return 1
 }

 func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return 10
 }


 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell: FeedsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "My_Reserved_Drinks_Cell", for: indexPath) as! FeedsTableViewCell
    //cell.sample.text = self.animals[indexPath.row]
     return cell
 }

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("You tapped cell number \(indexPath.row).")
}

}





