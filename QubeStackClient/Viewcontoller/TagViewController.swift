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


class TagViewController : UIViewController{
    
    var myQuestionList: UITableView!
    //@IBOutlet weak var webView: WKWebView!
    var listQuestion: [Items] = [Items]()
    var tagName: String = ""
    
    
    
    override func viewDidLoad() {
        myQuestionList = UITableView(frame: CGRect(x: 0, y: self.navigationController?.navigationBar.frame.maxY ?? 0, width: self.view.frame.width, height: self.view.frame.height))
        myQuestionList.delegate = self
        myQuestionList.dataSource = self
        self.myQuestionList.register(UINib(nibName: "FeedsTableViewCell", bundle: nil), forCellReuseIdentifier: "Feeds_Table_View_Cell")
        self.view.addSubview(myQuestionList!)
        getTagBasedQuestion()
        
    }
    
    
    func getTagBasedQuestion() {
        let param = Parameters.getTagBasedQuestion(page: "1")
        Services.getTagBasedQuestion(tag: tagName, parameters: param as [String: AnyObject],completionHandler: { response in
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
        cell.tagList.addTags(listQuestion[indexPath.row].tags ?? [""])
        cell.upCount.text = "\(listQuestion[indexPath.row].answerCount ?? 0)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
}


