//
//  IndicatorView.swift
//  QubeStackClient
//
//  Created by pratheepkumar on 20/11/19.
//  Copyright © 2019 Qube. All rights reserved.
//

import NVActivityIndicatorView
import UIKit

class IndicatorView: UIView {
    @IBOutlet var loaderView: NVActivityIndicatorView!

    let MinStrokeLength: CGFloat = 0.05
    let MaxStrokeLength: CGFloat = 0.7
    let circleShapeLayer = CAShapeLayer()

    override func awakeFromNib() {
        isHidden = false
        loaderView.type = NVActivityIndicatorType.ballPulse
        loaderView.padding = 0
    }

    class func startAnimating() -> IndicatorView {
        let indicatorView: IndicatorView = (Bundle.main.loadNibNamed("IndicatorView",
                                                                     owner: self,
                                                                     options: nil)?.first as? IndicatorView)!
//        if topViewController() != nil {
//            indicatorView.frame = (topViewController()?.view.bounds)!
//            indicatorView.animatingStart()
//            topViewController()?.view.addSubview(indicatorView)
//        }
        return indicatorView
    }

    func animatingStart() {
        loaderView.startAnimating()
    }

    func stopAnimating() {
        loaderView.stopAnimating()
        removeFromSuperview()
    }
}

