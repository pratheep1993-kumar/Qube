//
//  Services.swift
//  QubeStackClient
//
//  Created by pratheepkumar on 20/11/19.
//  Copyright © 2019 Qube. All rights reserved.
//

import Alamofire
import Foundation
import NVActivityIndicatorView
import ObjectMapper
import SwiftyJSON
import SystemConfiguration

typealias responseHandler = (DataResponse<Any>) -> Void
typealias downloadResponseHandler = (DownloadResponse<Data>) -> Void
typealias progressHandler = (Progress) -> Void
typealias failureHandler = () -> Void

let downloadDestination = DownloadRequest.suggestedDownloadDestination()

/**

 Services Class manage the all Web servies stuff.
 */
class Connectivity {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == false {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    class func checkConnection(sender: UIViewController) {
        if Connectivity.isConnectedToNetwork() == true {
            print("Connected to the internet")
            //  Do something
        } else {
            print("No internet connection")
            let alertController = UIAlertController(title: "No Internet Available", message: "", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default) { (_: UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            sender.present(alertController, animated: true, completion: nil)
            //  Do something
        }
    }
}

extension UIApplication {
    var visibleViewController: UIViewController? {
        guard let rootViewController = keyWindow?.rootViewController else {
            return nil
        }

        return getVisibleViewController(rootViewController)
    }

    private func getVisibleViewController(_ rootViewController: UIViewController) -> UIViewController? {
        if let presentedViewController = rootViewController.presentedViewController {
            return getVisibleViewController(presentedViewController)
        }

        if let navigationController = rootViewController as? UINavigationController {
            return navigationController.visibleViewController
        }

        if let tabBarController = rootViewController as? UITabBarController {
            return tabBarController.selectedViewController
        }

        return rootViewController
    }
}

class Services {
    var activityIndicator: NVActivityIndicatorView?

    static func getHeaders() -> [String: String] {
            return ["Content-Type": "application/json"]
    }

    static func printDetails() {
        print(getHeaders())
        if let cookie = HTTPCookieStorage.shared.cookies {
        }
    }

    static func makeGETCall(urlString: String, parameters: [String: AnyObject]? = nil,
                            showIndicator: Bool? = true,
                            checkNetworkConnection: Bool? = true,
                            completionHandler: @escaping responseHandler,
                            errorHandler: responseHandler? = nil) {
        print(printDetails())
        print(urlString)
//        var indicatorView: IndicatorView?
//        if showIndicator == true {
//            indicatorView = IndicatorView.startAnimating()
//        }
        Alamofire.request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, parameters: parameters)
            .responseJSON(completionHandler: { response in
                if let resultValue = response.result.value {
                    print("Response", JSON(resultValue), response.response?.statusCode ?? 0)
                }
                switch response.result {
                case .success:
                    successHandler(response: response, completionHandler: completionHandler, errorHandler: errorHandler)
                case let .failure(error):
                    failureHandler(response: response, errorHandler: errorHandler, checkNetworkConnection: checkNetworkConnection, error: error)
                }
                if showIndicator == true {
                  //  indicatorView?.stopAnimating()
                }
            })
    }

    static func makePOSTCall(urlString: String, parameters: [String: AnyObject],
                             showIndicator: Bool? = true,
                             completionHandler: @escaping responseHandler,
                             errorHandler: responseHandler? = nil) {
        print(printDetails())
        print(urlString)
        print(printJson(params: parameters))
//        var indicatorView: IndicatorView?
//        if showIndicator == true {
//            indicatorView = IndicatorView.startAnimating()
//        }
        let serviceManager = Alamofire.SessionManager.default
        serviceManager.session.configuration.timeoutIntervalForRequest = 120
        Alamofire.request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: getHeaders())
            .responseJSON(completionHandler: { response in
                if let resultValue = response.result.value {
                    print("Response", JSON(resultValue), response.response?.statusCode ?? 0)
                }
                switch response.result {
                case .success:
                    successHandler(response: response, completionHandler: completionHandler, errorHandler: errorHandler)
                case let .failure(error):
                    failureHandler(response: response, errorHandler: errorHandler, error: error)
                }
                if showIndicator == true {
                    //indicatorView?.stopAnimating()
                }
            })
    }

    static func makePUTCall(urlString: String, parameters: [String: AnyObject],
                            showIndicator: Bool? = true,
                            completionHandler: @escaping responseHandler,
                            errorHandler: responseHandler? = nil) {
        print(printDetails())
        print(urlString)
        print(printJson(params: parameters))
//        var indicatorView: IndicatorView?
//        if showIndicator == true {
//            indicatorView = IndicatorView.startAnimating()
//        }
        Alamofire.request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                          method: .put,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: getHeaders())
            .responseJSON(completionHandler: { response in
                if let resultValue = response.result.value {
                    print("Response", JSON(resultValue), response.response?.statusCode ?? 0)
                }
                switch response.result {
                case .success:
                    successHandler(response: response, completionHandler: completionHandler, errorHandler: errorHandler)
                case let .failure(error):
                    failureHandler(response: response, errorHandler: errorHandler, error: error)
                }
                if showIndicator == true {
                   // indicatorView?.stopAnimating()
                }
            })
    }

    static func makeDELETECall(urlString: String, parameters: [String: AnyObject],
                               showIndicator: Bool? = true,
                               completionHandler: @escaping responseHandler,
                               errorHandler: responseHandler? = nil) {
        print(printDetails())
        print(urlString)
        print(printJson(params: parameters))
//        var indicatorView: IndicatorView?
//        if showIndicator == true {
//            indicatorView = IndicatorView.startAnimating()
//        }
        let serviceManager = Alamofire.SessionManager.default
        serviceManager.session.configuration.timeoutIntervalForRequest = 120
        Alamofire.request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                          method: .delete,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: getHeaders())
            .responseJSON(completionHandler: { response in
                if let resultValue = response.result.value {
                    print("Response", JSON(resultValue), response.response?.statusCode ?? 0)
                }
                switch response.result {
                case .success:
                    successHandler(response: response, completionHandler: completionHandler, errorHandler: errorHandler)
                case let .failure(error):
                    failureHandler(response: response, errorHandler: errorHandler, error: error)
                }
                if showIndicator == true {
                   // indicatorView?.stopAnimating()
                }
            })
    }

    static func printJson(params: [String: AnyObject]?) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params!, options: .prettyPrinted)
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            print(decoded)
        } catch {
            print(error.localizedDescription)
        }
    }

    static func downloadFiles(urlString: String, httpMethod: HTTPMethod? = .get, parameters: [String: AnyObject]? = nil, headers: HTTPHeaders? = nil, closure: @escaping progressHandler, completionHandler: @escaping downloadResponseHandler) {
        Alamofire.download(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                           method: httpMethod!,
                           parameters: parameters,
                           encoding: JSONEncoding.default,
                           headers: headers,
                           to: downloadDestination)
            .downloadProgress(closure: closure)
            .responseData(completionHandler: { response in
                switch response.result {
                case .success:
                    if (response.response?.statusCode)! == 201 || response.response?.statusCode == 200 {
                        completionHandler(response)
                    } else {
                        self.showErrorAlert(title: "Alert!",
                                            message: "Please try again!")
                    }
                case let .failure(error):
                    self.showErrorAlert(title: "Alert!",
                                        message: error.localizedDescription)
                }
            })
    }
}

extension Services {
    // For cookies and alerts
    static func clearCookies() {
        let manager = SessionManager(configuration: URLSessionConfiguration.default)
        manager.startRequestsImmediately = false
        if let cookieStorage = manager.session.configuration.httpCookieStorage {
            for cookie in cookieStorage.cookies ?? [] {
                cookieStorage.deleteCookie(cookie as HTTPCookie)
            }
        }
    }

    static func successHandler(response: DataResponse<Any>,
                               completionHandler: @escaping responseHandler,
                               errorHandler: responseHandler? = nil) {
        if response.response?.statusCode == 201 || response.response?.statusCode == 200 {
            completionHandler(response)
        } else {
            if isSessionNotValid(response) {
                checkTopAndClear()
            } else {
                if errorHandler != nil {
                    errorHandler!(response)
                } else {
                    errorAlert(response: response)
                }
            }
        }
    }

    static func failureHandler(response: DataResponse<Any>,
                               errorHandler: responseHandler? = nil,
                               checkNetworkConnection: Bool? = true,
                               error: Error) {
        print("SERVICE Error Message : " + error.localizedDescription)
        if errorHandler != nil {
            errorHandler!(response)
        }
        if Connectivity.isConnectedToNetwork() == false, checkNetworkConnection == true {
            showErrorAlert(title: "No Internet",
                           message: "Please check your Internet Connection")
        }
    }

    static func showErrorAlert(title: String, message: String) {
//        topViewController()?.showAlertWithActions(title: title,
//                                                  message: message,
//                                                  actionCompletionHandler: { _ in
//                                                      hideLoadingIndicator()
//        })
    }

    static func errorAlert(response: DataResponse<Any>, actionHandler: OnActionHandler? = nil) {
        if let value = response.result.value {
            //            var showLogoutWindow = false
            let errorResponse = Mapper<ErrorResponseModel>().map(JSON: value as! [String: Any])
            hideLoadingIndicator()
            if checkAndClearSession(response) {
//                if let errMsg = errorResponse?.errorMessage, errMsg != "" {
//                    topViewController()?.showAlertWithActions(title: "Alert!",
//                                                              message: errMsg,
//                                                              actionCompletionHandler: actionHandler)
//                }
            }
        }
    }

    static func checkAndClearSession(_ response: DataResponse<Any>) -> Bool {
//        if UserDefaultsModel.getAuthToken() == nil {
//            return true
//        }
        if isSessionNotValid(response) {
            checkTopAndClear()
            return false
        }
        return true
    }

    static func hideLoadingIndicator() {
//        if let delegate = UIApplication.shared.delegate as? AppDelegate {
//            delegate.loadingIndicator?.isHidden = true
//        }
    }

    static func checkErrorMessage(message: String) -> Bool {
        return message.contains("invalid session; probably expired") ||
            message.contains("Permission denied for role: anonymous") ||
            message.contains("invalid authorization token") ||
            message.contains("Role is not permitted")
    }

    static func checkErrorCode(code: String) -> Bool {
        return code.contains("role-invalid") ||
            code.contains("invalid-cookies") ||
            code.contains("session-invalid")
    }

    static func isSessionNotValid(_ response: DataResponse<Any>) -> Bool {
        let authErrorResponse = Mapper<ErrorResponseModel>().map(JSON: response.result.value as! [String: Any])
        let errorMessage = authErrorResponse?.errorMessage ?? ""
        let errorCode = authErrorResponse?.errorcode ?? ""
        return checkErrorCode(code: errorCode) || checkErrorMessage(message: errorMessage)
    }

    static func checkTopAndClear() {
//        NotificationCenter.default.post(name: NSNotification.Name(N_STOP_HOME_ITEMS), object: nil)
//        let currentViewCtrl = topViewController()
//        if currentViewCtrl != nil, currentViewCtrl is UIAlertController {
//            print("Alert already presented")
//        } else {
//            if let ctrl = currentViewCtrl {
//                clearSession(currentViewCtrl: ctrl)
//            }
//        }
    }

    static func clearSession(currentViewCtrl _: UIViewController) {
//        Services.clearCookies()
//        UserDefaultsModel.setObject(object: false, forKey: USER_LOGGED_IN_KEY)
//        UserDefaultsModel.setObject(object: nil, forKey: AuthToken)
//        UserDefaults.standard.set(nil, forKey: "CartBadgeValue")
//        GeofenceManager.instance.resetData()
//        CoreDataManager.instance.deleteCart()
//        let homeStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let rootViewController = homeStoryboard.instantiateViewController(withIdentifier: "AgreeViewController")
//        let navigationController = UINavigationController(rootViewController: rootViewController)
//        appDelegateInstance.window?.rootViewController = navigationController
    }
}

