//
//  ServicesApi.swift
//  QubeStackClient
//
//  Created by pratheepkumar on 21/11/19.
//  Copyright © 2019 Qube. All rights reserved.
//

import Foundation
extension Services {

static func getAllQuestion(completionHandler: @escaping responseHandler, errorHandler: @escaping responseHandler) {
    makeGETCall(urlString: StackExchangeUrl + Questions ,
                completionHandler: completionHandler,
                errorHandler: errorHandler)
}
    
}
