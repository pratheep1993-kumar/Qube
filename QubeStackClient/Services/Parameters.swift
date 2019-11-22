//
//  Parameters.swift
//  QubeStackClient
//
//  Created by pratheepkumar on 21/11/19.
//  Copyright © 2019 Qube. All rights reserved.
//

import Foundation


class Parameters{
    
    class func getQuestion(page: String,
                           pagesize: String,order: String
        ,sort: String,site: String,fromdate: String,todate: String) -> [String: Any] {
        return [
            "page": page,
            "pagesize": pagesize,
            "order": order,
            "sort": sort,
            "site": site,
            "fromdate": fromdate,
            "todate": todate,
            "key": "eoaW7zQs70UEV*FE5jTutg(("
        ]
    }
    
    class func getMyQuestion(page: String,
                             pagesize: String,order: String
        ,sort: String,site: String,fromdate: String,todate: String,sessionToken: String) -> [String: Any] {
        return [
            "page": page,
            "pagesize": pagesize,
            "order": order,
            "sort": sort,
            "site": site,
            "key": "eoaW7zQs70UEV*FE5jTutg((",
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




