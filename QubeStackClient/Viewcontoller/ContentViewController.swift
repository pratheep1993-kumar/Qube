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
import NVActivityIndicatorView
import JGProgressHUD


struct Category {
    var title: String
    var sortType: String
}

class ContentViewController: UIViewController {
    
    @IBOutlet weak var feedsListing: UITableView!
    var listQuestion: [Items] = [Items]()
    
    
    @IBOutlet weak var noResultFound: UILabel!
    var content: String = ""
    var loadingCount = 10
    var pagecount =  1
    var isLoading: Bool = true
    var LastPages: Bool = true
    var category : Category?
    var contentLabel: UILabel! {
        didSet {
            contentLabel.textColor = .black
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.feedsListing.register(UINib(nibName: "FeedsTableViewCell", bundle: nil), forCellReuseIdentifier: "Feeds_Table_View_Cell")
        feedsListing.allowsSelection = false
        intNoResultFound()
        getAllQuestions()
    }
    
    
    
    
    func intNoResultFound(){
        noResultFound.center = self.view.center
        noResultFound.textAlignment = .center
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Feeds"
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
    }
    
    
    
    
    func getAllQuestions() {
        let progress = JGProgressHUD(style: .dark)
        progress.show(in: self.view)
        isLoading = true
        let param = Parameters.getQuestion(page: "1", sort: category!.sortType, site: "stackoverflow")
        Services.getAllQuestion(parameters: param as [String: AnyObject],completionHandler: { response in
            progress.dismiss()
            let data: AllQuestionResponse = Mapper<AllQuestionResponse>().map(JSON: response.result.value as! [String: Any])!
            self.listQuestion = data.items!
            if data.items!.count > 0 {
                self.feedsListing.reloadData()
            }else{
                self.feedsListing.isHidden = true
            }
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
        var tags: [String] = []
        tags = listQuestion[indexPath.row].tags ?? [""]
        let cell: FeedsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Feeds_Table_View_Cell", for: indexPath) as! FeedsTableViewCell
        cell.title.text = listQuestion[indexPath.row].title
        cell.userName.text = listQuestion[indexPath.row].owner?.display_name
        cell.tagList.removeAllTags()
        cell.tagList.addTags(tags)
        cell.tagList.delegate = self
        cell.timeStamp.text = Utils.getDateFromTimeStamp(timeStamp: Double(listQuestion[indexPath.row].creationDate ?? 0))
        cell.upCount.text = "\(listQuestion[indexPath.row].score ?? 0)"
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





