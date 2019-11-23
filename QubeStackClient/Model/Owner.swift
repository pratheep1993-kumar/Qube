//
//  Owner.swift
//  QubeStackClient
//
//  Created by pratheepkumar on 21/11/19.
//  Copyright © 2019 Qube. All rights reserved.
//

import Foundation
import ObjectMapper

class Owner: Mappable{
    
    var reputation: Int?
    var user_id: Int?
    var user_type: Int?
    var profile_image: String?
    var display_name: String?
    var link: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        reputation <- map["reputation"]
        user_id <- map["user_id"]
        user_type <- map["user_type"]
        profile_image <- map["profile_image"]
        display_name <- map["display_name"]
        link <- map["link"]
    }
    
    
}
