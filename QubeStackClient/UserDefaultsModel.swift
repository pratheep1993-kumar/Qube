//
//  UserDefaultsModel.swift
//  QubeStackClient
//
//  Created by pratheepkumar on 21/11/19.
//  Copyright © 2019 Qube. All rights reserved.
//

import Foundation
class UserDefaultsModel: NSObject {

    private class func userDefaults() -> UserDefaults {
        return UserDefaults.standard
    }
    
    class func setObject (object : Any?, forKey : String) {
        userDefaults().set(object, forKey: forKey)
        userDefaults().synchronize()
    }
    
    class func removeObjectForKey(key : String) {
        userDefaults().removeObject(forKey: key)
        userDefaults().synchronize()
    }
    
    class func getSessionToken() -> String? {
        return userDefaults().string(forKey: SESSION_TOKEN)
    }

    class func isUserLoggedIn() -> Bool? {
        return userDefaults().bool(forKey: USER_LOGGED_IN)
    }

    
}
