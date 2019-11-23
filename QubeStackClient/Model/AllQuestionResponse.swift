//
//  AllQuestionResponse.swift
//  QubeStackClient
//
//  Created by pratheepkumar on 21/11/19.
//  Copyright © 2019 Qube. All rights reserved.
//

import Foundation
import ObjectMapper

class AllQuestionResponse: Mappable {
    
    var items: [Items]?
    func mapping(map: Map) {
        items <- map["items"]
    }
    required init(map _: Map) {}
    
}
