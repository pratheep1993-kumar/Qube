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
import TagListView

struct Category {
    var title: String
    var sortType: String
}

class ContentViewController: UIViewController {
    
    @IBOutlet weak var feedsListing: UITableView!
    var listQuestion: [Items] = [Items]()
    
    var content: String = ""
    var category : Category?
    var contentLabel: UILabel! {
        didSet {
            contentLabel.textColor = .black
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.feedsListing.register(UINib(nibName: "FeedsTableViewCell", bundle: nil), forCellReuseIdentifier: "Feeds_Table_View_Cell")
        getAllQuestions()
    }
    
    func getAllQuestions() {
        let param = Parameters.getQuestion(page: "1", pagesize: "10", order: "asc", sort: category!.sortType, site: "stackoverflow", fromdate: "1556668800", todate: "1572566400")
        Services.getAllQuestion(parameters: param as [String: AnyObject],completionHandler: { response in
            let data: AllQuestionResponse = Mapper<AllQuestionResponse>().map(JSON: response.result.value as! [String: Any])!
            self.listQuestion = data.items!
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
        return listQuestion.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FeedsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Feeds_Table_View_Cell", for: indexPath) as! FeedsTableViewCell
        cell.title.text = listQuestion[indexPath.row].title
        cell.userName.text = listQuestion[indexPath.row].owner?.display_name
        cell.tagList.addTags(listQuestion[indexPath.row].tags ?? [""])
        cell.tagList.delegate = self
        //cell.upCount.text = listQuestion[indexPath.row].answerCount
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}

extension ContentViewController : TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        let tagViewController = self.storyboard?.instantiateViewController(withIdentifier: "TagViewController") as! TagViewController
        tagViewController.tagName = title
        self.navigationController?.pushViewController(tagViewController, animated: true)
    }
}





