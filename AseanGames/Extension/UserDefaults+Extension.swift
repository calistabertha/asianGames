//
//  UserDefaults+Extension.swift
//  ZULU
//
//  Created by codigo on 5/29/17.
//  Copyright © 2017 Calista. All rights reserved.
//

import SwiftyJSON

extension UserDefaults {
    func setUserProfile(json: JSON) -> Void {
        if let data = json.rawString() {
            UserDefaults.standard.setValue(data, forKey: "USER_PROFILE")
        }
    }
    
    func removeUserProfile() -> Void {
        UserDefaults.standard.setValue(nil, forKey: "USER_PROFILE")
    }
    
    func getUserProfile() -> UserModel? {
        if let data = UserDefaults.standard.value(forKey: "USER_PROFILE") as? String {
            let jsonResult = JSON.init(parseJSON: data)
            return UserModel(json: jsonResult)
        }
        return nil
    }
    
    func setToken(token: String) {
        UserDefaults.standard.setValue(token, forKey: "USER_TOKEN")
    }
    
    func getToken() -> String {
        /*if let user = self.getUserProfile() {
            return user.userToken
        }*/
        if let token = UserDefaults.standard.value(forKey: "USER_TOKEN") as? String {
            return token
        }
        
        return ""
    }
    
   /* func getRefreshToken() -> String {
        if let user = self.getUserProfile() {
            return user.refreshToken
        }
        
        return ""
    } */
    
    func getID() -> String {
        if let user = self.getUserProfile() {
            return user.id
        }
        
        return ""
    }
}
