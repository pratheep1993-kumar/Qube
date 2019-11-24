//
//  TagViewController.swift
//  QubeStackClient
//
//  Created by pratheepkumar on 22/11/19.
//  Copyright © 2019 Qube. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import JGProgressHUD


class TagViewController : UIViewController{
    
    @IBOutlet weak var myQuestionList: UITableView!
    var listQuestion: [Items] = [Items]()
    var tagName: String = ""
    
    
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = false
        self.myQuestionList.register(UINib(nibName: "FeedsTableViewCell", bundle: nil), forCellReuseIdentifier: "Feeds_Table_View_Cell")
        myQuestionList.allowsSelection = false
        self.view.addSubview(myQuestionList!)
        getTagBasedQuestion()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.rightBarButtonItem = nil
    }
    
    
    
    func getTagBasedQuestion() {
        let progress = JGProgressHUD(style: .dark)
        progress.show(in: self.view)
        let param = Parameters.getTagBasedQuestion(page: "1")
        Services.getTagBasedQuestion(tag: tagName, parameters: param as [String: AnyObject],completionHandler: { response in
            progress.dismiss()
            let data: AllQuestionResponse = Mapper<AllQuestionResponse>().map(JSON: response.result.value as! [String: Any])!
            self.listQuestion = data.items!
            self.myQuestionList.reloadData()
        }) { _ in
        }
    }
}

extension TagViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return listQuestion.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FeedsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Feeds_Table_View_Cell", for: indexPath) as! FeedsTableViewCell
        cell.title.text = listQuestion[indexPath.row].title
        cell.userName.text = listQuestion[indexPath.row].owner?.display_name
        cell.tagList.removeAllTags()
        cell.tagList.addTags(listQuestion[indexPath.row].tags ?? [""])
        cell.upCount.text = "\(listQuestion[indexPath.row].score )"
        cell.timeStamp.text = Utils.getDateFromTimeStamp(timeStamp: Double(listQuestion[indexPath.row].creationDate ?? 0))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
}


