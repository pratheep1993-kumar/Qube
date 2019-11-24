//
//  Parameters.swift
//  QubeStackClient
//
//  Created by pratheepkumar on 21/11/19.
//  Copyright © 2019 Qube. All rights reserved.
//

import Foundation


class Parameters{
    
    class func getQuestion(page: String,sort: String,site: String) -> [String: Any] {
        return [
            "page": page,
            "pagesize": 10,
            "order": "asc",
            "sort": sort,
            "site": site,
            "key": key
        ]
    }
    
    class func getMyQuestion(page: String
        ,sort: String,site: String,sessionToken: String) -> [String: Any] {
        return [
            "page": page,
            "pagesize": 10,
            "order": "asc",
            "sort": sort,
            "site": site,
            "key": key,
            "access_token":sessionToken
        ]
    }
    
    class func getTagBasedQuestion(page: String) -> [String: Any] {
        return [
            "page": page,
            "pagesize": 10,
            "site": "stackoverflow",
            "key": "eoaW7zQs70UEV*FE5jTutg(("
        ]
    }
}




