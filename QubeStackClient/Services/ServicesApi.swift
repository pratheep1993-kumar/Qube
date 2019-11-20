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
    urlComponents.scheme = "https"
    urlComponents.host = "api.stackexchange.com"
    urlComponents.path = "/2.2/questions"
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


