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

extension String {
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map { result.range(at: $0).location != NSNotFound
                ? nsString.substring(with: result.range(at: $0))
                : ""
            }
        }
    }
    func match(_ regex: String) -> [[String]] {
        let nsString = self as NSString
        return (try? NSRegularExpression(pattern: regex, options: []))?.matches(in: self, options: [], range: NSMakeRange(0, count)).map { match in
            (0..<match.numberOfRanges).map { match.range(at: $0).location == NSNotFound ? "" : nsString.substring(with: match.range(at: $0)) }
        } ?? []
    }
}

class MyQuestionsViewController: UIViewController,WKNavigationDelegate{
    
    //@IBOutlet weak var webView: WKWebView!
    var wkWebView : WKWebView!
    var progressView : HorizontalProgressBar?
    var theBool: Bool = false
    
    let redirectURI : String = "https://stackoverflow.com/oauth/login_success"
    let replaceURI : String =  "https://stackoverflow.com/oauth/login_success#"
    let regex = "https:\\/\\/stackoverflow.com\\/oauth\\/login_success#access_token=[A-Za-z0-9!@#$%^{}|()]+&expires=[0-9]+"
    
    
    override func viewDidLoad() {
        wkWebView = WKWebView(frame: CGRect(x: 0, y: self.navigationController?.navigationBar.frame.maxY ?? 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(wkWebView!)
        wkWebView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        wkWebView?.navigationDelegate = self
        progressView = HorizontalProgressBar(frame: CGRect(x: 0, y: self.navigationController?.navigationBar.frame.maxY ?? 0, width: self.view.frame.width, height: 2))
        progressView?.pgWidth = self.view.frame.width
        progressView?.pgHeight = 4
        progressView?.barColor = BG_COLOR
        progressView?.bgColor = UIColor.clear
        self.view.addSubview(progressView!)
        funcToCallWhenStartLoadingYourWebview()
        checkAndSetTransaction()
        self.view.addSubview(wkWebView!)
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
        self.theBool = false
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
                print("bucjket \(urlStr.match(regex)))")
                let bucket = urlStr.match(regex)
                let accessToken = urlStr.replacingOccurrences(of: "https://stackoverflow.com/oauth/login_success#access_token=", with: "").replacingOccurrences(of: "&expires=86400", with: "")
                print("bucjket \(accessToken)")
//                let url = URL(string:resultValue)!
//                let sessionToken = url["#access_token"]
//                print("access_token \(String(describing: sessionToken))")

            }
        }
        UserDefaultsModel.setObject(object: "", forKey: SESSION_TOKEN)
           UserDefaultsModel.setObject(object: true, forKey: USER_LOGIGGED_IN)
            decisionHandler(.allow)
        }
    
}

extension URL {
    subscript(queryParam:String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParam })?.value
    }
}
    

