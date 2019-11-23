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
    var wkWebView : WKWebView!
    var listQuestion: [Items] = [Items]()
    let redirectURI : String = "https://stackoverflow.com/oauth/login_success"
    let replaceURI : String =  "https://stackoverflow.com/oauth/login_success#"
    let regex = "https:\\/\\/stackoverflow.com\\/oauth\\/login_success#access_token=[A-Za-z0-9!@#$%^{}|()]+&expires=[0-9]+"
    
    
    override func viewDidLoad() {
        initWebView()
        initTableView()
        checkAndSetTransaction()
        if UserDefaultsModel.isUserLoggedIn() ?? false {
            showMyQuestion()
        }else{
            showLogin()
        }
        
    }
    
    func initWebView(){
        wkWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        wkWebView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        wkWebView?.navigationDelegate = self
        self.view.addSubview(wkWebView!)
    }
    
    
    func initTableView(){
        myQuestionList = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
               myQuestionList.delegate = self
               myQuestionList.dataSource = self
               self.myQuestionList.register(UINib(nibName: "FeedsTableViewCell", bundle: nil), forCellReuseIdentifier: "Feeds_Table_View_Cell")
               self.view.addSubview(myQuestionList!)
    }
    
    @objc func sayLogout(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Alert", message: "Do you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.clearcacheAndCookie()
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in
            
        }))
        self.present(alert, animated: true)
        
    }
    
    
    
    func clearcacheAndCookie(){
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        wkWebView.cleanAllCookies()
        wkWebView.refreshCookies()
        UserDefaultsModel.setObject(object: nil, forKey: SESSION_TOKEN)
        UserDefaultsModel.setObject(object: false, forKey: USER_LOGGED_IN)
        self.showLogin()
    }
    
    func showMyQuestion(){
        let logOut = UIBarButtonItem(image: UIImage(named: "logout-blue"), style: .done, target: self, action: #selector(sayLogout(sender:)))
        self.navigationController?.navigationBar.topItem?.title = "My Questions"
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = logOut
        wkWebView.isHidden = true
        myQuestionList.isHidden = false
        getMyQuestion()
    }
    
    func showLogin() {
        self.navigationController?.navigationBar.topItem?.title = "Log in"
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
        wkWebView.isHidden = false
        myQuestionList.isHidden = true
        checkAndSetTransaction()
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
    
    
    func gicheckAndSetTransaction(){
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "stackoverflow.com"
        urlComponents.path = "/oauth/dialog"
        urlComponents.setQueryItems(with: loginParams(client_id: "16698", scope: "", redirect_uri: redirectURI) as [String : AnyObject])
        let myBlog = urlComponents.url?.absoluteString ?? ""
        let url = NSURL(string: myBlog)
        let request = NSURLRequest(url: url! as URL)
        wkWebView.load(request as URLRequest)
        
    }
    
   
    
    func loginParams(client_id:String,scope: String,redirect_uri: String) -> [String: Any] {
        return [
            "client_id": client_id,
            "scope": scope,
            "redirect_uri": redirect_uri
        ]
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       
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
                saveSessionToken(accessToken: accessToken)
            }
        }
        decisionHandler(.allow)
    }
    
    func saveSessionToken(accessToken: String){
        UserDefaultsModel.setObject(object: accessToken, forKey: SESSION_TOKEN)
        UserDefaultsModel.setObject(object: true, forKey: USER_LOGGED_IN)
        if (UserDefaultsModel.getSessionToken() != ""){
            self.showMyQuestion()
        }

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


extension WKWebView {
    
    func cleanAllCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        print("All cookies deleted")
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("Cookie ::: \(record) deleted")
            }
        }
    }
    
    func refreshCookies() {
        self.configuration.processPool = WKProcessPool()
    }
}
