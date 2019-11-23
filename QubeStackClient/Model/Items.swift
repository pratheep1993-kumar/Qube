//
//  Items.swift
//  QubeStackClient
//
//  Created by pratheepkumar on 21/11/19.
//  Copyright © 2019 Qube. All rights reserved.
//

import Foundation
import ObjectMapper

class Items: Mappable{
    //"tags"
    var tags: [String]? = []
    var owner: Owner?
    var isAnswered: Bool?
    var viewCount: Int?
    var  answerCount: Int?
    var  score: Int?
    var  lastActivityDate: Int?
    var  creationDate: Int?
    var  questionId: Int?
    var  link: String?
    var  title: String?
    var  acceptedAnswerId: Int?
    var  lastEditDate: Int?
    var  closedDate: Int?
    var  closedReason: String?
    
    required init(map _: Map) {}
    
    func mapping(map: Map) {
        tags <- map["tags"]
        owner <- map["owner"]
        isAnswered <- map["is_answered"]
        viewCount <- map["view_count"]
        answerCount <- map["answer_count"]
        score <- map["score"]
        lastActivityDate <- map["last_activity_date"]
        creationDate  <- map["creation_date"]
        questionId  <- map["question_id"]
        link  <- map["link"]
        title  <- map["title"]
        acceptedAnswerId  <- map["accepted_answer_id"]
        lastEditDate <- map["last_edit_date"]
        closedDate  <- map["closed_date"]
        closedReason  <- map["closed_reason"]
    }
    
    
    
    
}
