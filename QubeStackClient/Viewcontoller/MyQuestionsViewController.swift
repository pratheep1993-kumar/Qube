//
//  MyQuestionsViewController.swift
//  QubeStackClient
//
//  Created by pratheepkumar on 20/11/19.
//  Copyright © 2019 Qube. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import ObjectMapper
import TagListView

class MyQuestionsViewController: UIViewController,WKNavigationDelegate{
    
    var myQuestionList: UITableView!
    //@IBOutlet weak var webView: WKWebView!
    var wkWebView : WKWebView!
    var listQuestion: [Items] = [Items]()
    var progressView : HorizontalProgressBar?
    
    let redirectURI : String = "https://stackoverflow.com/oauth/login_success"
    let replaceURI : String =  "https://stackoverflow.com/oauth/login_success#"
    let regex = "https:\\/\\/stackoverflow.com\\/oauth\\/login_success#access_token=[A-Za-z0-9!@#$%^{}|()]+&expires=[0-9]+"
    
    
    override func viewDidLoad() {
        wkWebView = WKWebView(frame: CGRect(x: 0, y: self.navigationController?.navigationBar.frame.maxY ?? 0, width: self.view.frame.width, height: self.view.frame.height))
        wkWebView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        wkWebView?.navigationDelegate = self
        self.view.addSubview(wkWebView!)
        
        progressView = HorizontalProgressBar(frame: CGRect(x: 0, y: self.navigationController?.navigationBar.frame.maxY ?? 0, width: self.view.frame.width, height: 2))
        progressView?.pgWidth = self.view.frame.width
        progressView?.pgHeight = 4
        progressView?.barColor = BG_COLOR
        progressView?.bgColor = UIColor.clear
        self.view.addSubview(progressView!)
        
        
        myQuestionList = UITableView(frame: CGRect(x: 0, y: self.navigationController?.navigationBar.frame.maxY ?? 0, width: self.view.frame.width, height: self.view.frame.height))
        myQuestionList.delegate = self
        myQuestionList.dataSource = self
        self.myQuestionList.register(UINib(nibName: "FeedsTableViewCell", bundle: nil), forCellReuseIdentifier: "Feeds_Table_View_Cell")
        self.view.addSubview(myQuestionList!)
        
        funcToCallWhenStartLoadingYourWebview()
        checkAndSetTransaction()
        if UserDefaultsModel.isUserLoggedIn() ?? false {
            showMyQuestion()
        }else{
            showLogin()
        }
        
    }
    
    
    func showMyQuestion(){
        wkWebView.isHidden = true
        myQuestionList.isHidden = false
        getMyQuestion()
    }
    
    func showLogin() {
        wkWebView.isHidden = false
        myQuestionList.isHidden = true
    }
    
    
    func getMyQuestion() {
        let param = Parameters.getMyQuestion(page: "1", pagesize: "10", order: "asc", sort: "activity", site: "stackoverflow", fromdate: "1556668800", todate: "1572566400", sessionToken: UserDefaultsModel.getSessionToken() ?? "")
        Services.getMyQuestion(parameters: param as [String: AnyObject],completionHandler: { response in
            let data: AllQuestionResponse = Mapper<AllQuestionResponse>().map(JSON: response.result.value as! [String: Any])!
            self.listQuestion = data.items!
            self.myQuestionList.reloadData()
        }) { _ in
        }
    }
    
    
    func checkAndSetTransaction(){
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "stackoverflow.com"
        urlComponents.path = "/oauth/dialog"
        urlComponents.setQueryItems(with: getEta(client_id: "16698", scope: "", redirect_uri: redirectURI) as [String : AnyObject])
        let myBlog = urlComponents.url?.absoluteString ?? ""
        let url = NSURL(string: myBlog)
        let request = NSURLRequest(url: url! as URL)
        wkWebView.load(request as URLRequest)
        
    }
    
    func funcToCallWhenStartLoadingYourWebview() {
        progressView?.isHidden = false
        self.progressView?.startAnimation(type: "normal", duration: 3.0)
    }
    
    
    func getEta(client_id:String,scope: String,redirect_uri: String) -> [String: Any] {
        return [
            "client_id": client_id,
            "scope": scope,
            "redirect_uri": redirect_uri
        ]
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationItem()
    }
    
    func setUpNavigationItem() {
        
    }
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let urlStr = navigationAction.request.url?.absoluteString {
            if urlStr.range(of: regex , options: .regularExpression) != nil {
                let accessToken = urlStr.replacingOccurrences(of: "https://stackoverflow.com/oauth/login_success#access_token=", with: "").replacingOccurrences(of: "&expires=86400", with: "")
                print("bucjket \(accessToken)")
                UserDefaultsModel.setObject(object: accessToken, forKey: SESSION_TOKEN)
                UserDefaultsModel.setObject(object: true, forKey: USER_LOGGED_IN)
            }
        }
        decisionHandler(.allow)
    }
    
}

extension URL {
    subscript(queryParam:String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParam })?.value
    }
}


extension MyQuestionsViewController: UITableViewDelegate, UITableViewDataSource {
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
        cell.upCount.text = "\(listQuestion[indexPath.row].answerCount)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
}

extension MyQuestionsViewController : TagListViewDelegate {
    func tagPressed(title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        let vc = TagViewController()
        vc.tagName = title//change this to your class name
        self.present(vc, animated: true, completion: nil)
    }
}
