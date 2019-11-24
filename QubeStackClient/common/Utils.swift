//
//  Utils.swift
//  QubeStackClient
//
//  Created by pratheepkumar on 23/11/19.
//  Copyright © 2019 Qube. All rights reserved.
//

import Foundation


class Utils{
    
    class func getDateFromTimeStamp(timeStamp : Double) -> String {
        let date = NSDate(timeIntervalSince1970: timeStamp)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd MMM YY, hh:mm a"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
}
