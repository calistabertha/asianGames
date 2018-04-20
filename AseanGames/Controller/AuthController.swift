//
//  AuthController.swift
//  AseanGames
//
//  Created by Calista on 1/20/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import Foundation
import SwiftyJSON

class AuthController: BaseController {
    fileprivate let generateTokenAPI = API.Auth.generateToken.ENV
    fileprivate let loginAPI = API.Auth.login.ENV
    
    func getToken(onSuccess: @escaping SingleResultListener<String>,
                        onFailed: @escaping MessageListener,
                        onComplete: @escaping MessageListener) {
        
        httpHelper.request(url: generateTokenAPI, param: nil, method: .get) {
            (success, statusCode, json) in
            if success {
                guard let data = json else {
                    onFailed("Null response from server")
                    return
                }
            
                let token = data["data"]["token"].stringValue
                if statusCode == 200 {
                    UserDefaults.standard.setToken(token: token)
                    onSuccess(200, "Success fetching data", token)
                    onComplete("Fetching data completed")
                }else {
                    onSuccess(200, "Success fetching data",token) 
                }
                
            }else{
                if statusCode >= 400 {
                    onFailed("Bad request")
                } else if statusCode >= 500 {
                    onFailed("Internal server error")
                } else {
                    onFailed("An error occured")
                }
            }
        }
    }
    
    func requestLogin(email: String, password: String, onSuccess: @escaping SingleResultListener<String>,
                  onFailed: @escaping MessageListener,
                  onComplete: @escaping MessageListener) {
        
        let params = [
            "email" : email,
            "password" : password,
            "device" : "2"
            //"device_id" : UIDevice.current.identifierForVendor!.uuidString
        ]
        
        httpHelper.requestAPI(url: loginAPI, param: params, method: .post) {
            (success, statusCode, json) in
            
            if success {
                guard let data = json else {
                    onFailed("Null response from server")
                    return
                }
                 let response = ResponseModel(with: data)
                
                if statusCode == 200 {
                    guard let dataJSON = response.data else {
                        onComplete(response.displayMessage)
                        return
                    }
                    
                    UserDefaults.standard.setToken(token: dataJSON["X-Access-Token"].stringValue)
                    UserDefaults.standard.setUserProfile(json: dataJSON)
                    
//                    var users = [UserModel]()
//                    for value in (response.data?.arrayValue)! {
//                        let user = UserModel(json: value)
//                        users.append(user)
//                    }
                    
                    onSuccess(response.status, response.displayMessage, response.message)
                    onComplete(response.displayMessage)
                }
                
            }else{
                if statusCode >= 400 {
                    onFailed("Bad request")
                } else if statusCode >= 500 {
                    onFailed("Internal server error")
                } else {
                    onFailed("An error occured")
                }
            }
        }
    }
}
