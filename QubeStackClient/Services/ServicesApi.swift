//
//  ServicesApi.swift
//  QubeStackClient
//
//  Created by pratheepkumar on 21/11/19.
//  Copyright © 2019 Qube. All rights reserved.
//

import Foundation
extension Services {
    
    static func getAllQuestion(parameters: [String: AnyObject],completionHandler: @escaping responseHandler, errorHandler: @escaping responseHandler) {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "/2.2/questions"
        urlComponents.setQueryItems(with: parameters)
        makeGETCall(urlString: urlComponents.url?.absoluteString ?? "" ,
                    completionHandler: completionHandler,
                    errorHandler: errorHandler)
    }
    
    
    static func getMyQuestion(parameters: [String: AnyObject],completionHandler: @escaping responseHandler, errorHandler: @escaping responseHandler) {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "/2.2/me/questions"
        urlComponents.setQueryItems(with: parameters)
        makeGETCall(urlString: urlComponents.url?.absoluteString ?? "" ,
                    completionHandler: completionHandler,
                    errorHandler: errorHandler)
    }
    
    
    static func getTagBasedQuestion(tag: String,parameters: [String: AnyObject],completionHandler: @escaping responseHandler, errorHandler: @escaping responseHandler) {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "/2.2/tags/\(tag)/faq"
        urlComponents.setQueryItems(with: parameters)
        makeGETCall(urlString: urlComponents.url?.absoluteString ?? "" ,
                    completionHandler: completionHandler,
                    errorHandler: errorHandler)
    }
}


extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: AnyObject]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value as? String) }
    }
}


