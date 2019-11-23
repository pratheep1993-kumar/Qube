//
//  BaseViewController.swift
//  QubeStackClient
//
//  Created by pratheepkumar on 21/11/19.
//  Copyright © 2019 Qube. All rights reserved.
//

import Foundation
import UIKit

open class BaseViewController : UIViewController {
    
    open override func viewDidLoad() {
        
    }
    
    func setSmallTitle() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        //        self.navigationController?.navigationBar.largeTitleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.white])
    }
    
    func setLargeTitle() {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            //            self.navigationController?.navigationBar.largeTitleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.white])
        }
    }
    
    func extendedLayout() {
        if #available(iOS 11.0, *) {} else {
            self.edgesForExtendedLayout = []
        }
    }
    
    func translucentNavBar(isTranslucent : Bool) {
        // self.navigationController?.navigationBar.barTintColor = UIColor(hex: 0x1B1B1F)
        self.navigationController?.navigationBar.isTranslucent = isTranslucent
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationBar?.shadowImage = UIImage()
    }
    
    func setNavBarOrigin() {
        //        var origin = self.navigationController?.navigationBar.frame.origin
        //       // origin = CGPoint(x: 0, y: (UIDevice().iPhoneXSeries  || UIDevice().iPhoneXrSeries) ? 44 : 20)
        //        self.navigationController?.navigationBar.frame.origin = origin!
    }
    
    func setUpBackButtonItem(selector : Selector? = nil) {
        if selector != nil {
            let arrowButton = UIBarButtonItem(image: UIImage.init(named: "header_e//xit"), style: .plain, target: self, action: selector)
            self.navigationItem.leftBarButtonItem = arrowButton
        } else {
            let arrowButton = UIBarButtonItem(image: UIImage.init(named: "header_exit"), style: .plain, target: self, action: #selector(goBack))
            self.navigationItem.leftBarButtonItem = arrowButton
        }
    }
    
    func setUpBackButton(controller : AnyClass? = nil) {
        if controller != nil {
            let arrowButton = UIBarButtonItem(image: UIImage.init(named: "header_exit"), style: .plain, target: self, action: #selector(goBack( _:)))
            self.navigationItem.leftBarButtonItem = arrowButton
        } else {
            let arrowButton = UIBarButtonItem(image: UIImage.init(named: "header_exit"), style: .plain, target: self, action: #selector(goBack(_:)))
            self.navigationItem.leftBarButtonItem = arrowButton
        }
    }
    
    func setUpHomeVC(controller : AnyClass? = nil) {
        if controller != nil {
            let arrowButton = UIBarButtonItem(image: UIImage.init(named: "header_exit"), style: .plain, target: self, action: #selector(goBackToHome))
            self.navigationItem.leftBarButtonItem = arrowButton
        } else {
            let arrowButton = UIBarButtonItem(image: UIImage.init(named: "header_exit"), style: .plain, target: self, action: #selector(goBackToHome))
            self.navigationItem.leftBarButtonItem = arrowButton
        }
    }
    
    @objc func goBackToHome() {
        //        NotificationCenter.default.post(name: NSNotification.Name.init(N_LOAD_HOME_ROOT_VIEW_CONTROLLER), object: nil, userInfo: [N_IS_DIFFERENT_CITY : false])
        //        self.dismiss(animated: true, completion: nil)
    }
    
    
    func setUpRightButtonItem(image : UIImage, selector : Selector? = nil) {
        let arrowButton = UIBarButtonItem(image: image, style: .plain, target: self, action: selector)
        self.navigationItem.rightBarButtonItem = arrowButton
    }
    
    // MARK: ALL BUTTON ACTIONS
    // MARK: Perform Close Bar Button
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func goBackOnPress(_ controller : AnyClass? = nil) {
        //        if let con = controller {
        //            self.navigationController?.backToViewController(viewController: con)
        //        } else {
        //            self.navigationController?.backToViewController(viewController: UIViewController.self)
        //        }
    }
    
    @objc func goBackAnimated(animated : Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    @objc func goBack(_ controller : AnyClass? = nil) {
        if let vc = controller {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
            for aViewController in viewControllers {
                if aViewController.isKind(of: vc) {
                    self.navigationController?.popToViewController(aViewController, animated: true);
                    return
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("DEINIT CLASS", type(of: self))
    }
    
}
