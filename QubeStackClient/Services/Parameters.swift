//
//  Parameters.swift
//  QubeStackClient
//
//  Created by pratheepkumar on 21/11/19.
//  Copyright © 2019 Qube. All rights reserved.
//

import Foundation


class Parameters{
    
    class func getEta(page: String,
                      pagesize: String,order: String
        ,sort: String,site: String,fromdate: String,todate: String) -> [String: Any] {
           return [
               "page": page,
               "pagesize": pagesize,
                "order": order,
                 "sort": sort,
                  "site": site,
                   "fromdate": fromdate,
                   "todate": todate
           ]
       }
}




