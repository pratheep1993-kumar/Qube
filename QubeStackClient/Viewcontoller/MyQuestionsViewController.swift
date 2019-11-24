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
import JGProgressHUD
class MyQuestionsViewController: UIViewController,WKNavigationDelegate{
    
    var myQuestionList: UITableView!
    var wkWebView : WKWebView!
    var listQuestion: [Items] = [Items]()
    let redirectURI : String = "https://stackoverflow.com/oauth/login_success"
    let replaceURI : String =  "https://stackoverflow.com/oauth/login_success#"
    
    
    override func viewDidLoad() {
        initWebView()
        initTableView()
        if UserDefaultsModel.isUserLoggedIn() ?? false {
            wkWebView.isHidden = true
            myQuestionList.isHidden = false
            showMyQuestion()
        }else{
            wkWebView.isHidden = false
            myQuestionList.isHidden = true
            checkAndSetTransaction()
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
        myQuestionList.allowsSelection = false
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
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        UserDefaultsModel.setObject(object: nil, forKey: SESSION_TOKEN)
        UserDefaultsModel.setObject(object: false, forKey: USER_LOGGED_IN)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                self.showLogin()
            }
        }
        
        
    }
    
    func showMyQuestion(){
        wkWebView.isHidden = true
        myQuestionList.isHidden = false
        getMyQuestion()
        self.setLoginNavigation()
    }
    
    func showLogin() {
        wkWebView.isHidden = false
        myQuestionList.isHidden = true
        //        wkWebView.cleanAllCookies()
        //        wkWebView.refreshCookies()
        checkAndSetTransaction()
        self.setLogOutNavigation()
    }
    
    
    func getMyQuestion() {
        let progress = JGProgressHUD(style: .dark)
        progress.show(in: self.view)
        let param = Parameters.getMyQuestion(page: "1", sort: "activity", site: "stackoverflow",sessionToken: UserDefaultsModel.getSessionToken() ?? "")
        Services.getMyQuestion(parameters: param as [String: AnyObject],completionHandler: { response in
            progress.dismiss()
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
        if (UserDefaultsModel.isUserLoggedIn() ?? false){
            setLoginNavigation()
        }else{
            setLogOutNavigation()
        }
        
    }
    
    func setLogOutNavigation(){
        self.navigationController?.navigationBar.topItem?.title = "Log in"
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
    }
    
    func setLoginNavigation(){
        let logOut = UIBarButtonItem(image: UIImage(named: "logout-blue"), style: .done, target: self, action: #selector(sayLogout(sender:)))
        self.navigationController?.navigationBar.topItem?.title = "My Questions"
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = logOut
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
            if urlStr.contains("access_token"){
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
        if (UserDefaultsModel.getSessionToken() != nil){
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
        cell.tagList.removeAllTags()
        cell.tagList.addTags(listQuestion[indexPath.row].tags ?? [""])
        cell.tagList.delegate = self
        cell.timeStamp.text = Utils.getDateFromTimeStamp(timeStamp: Double(listQuestion[indexPath.row].creationDate ?? 0))
        cell.upCount.text = "\(String(describing: listQuestion[indexPath.row].score))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
}

extension MyQuestionsViewController : TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        let tagViewController = self.storyboard?.instantiateViewController(withIdentifier: "TagViewController") as! TagViewController
        tagViewController.tagName = title
        self.navigationController?.pushViewController(tagViewController, animated: true)
    }
}
