//
//  SettingController.swift
//  AseanGames
//
//  Created by Calista on 3/18/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import SwiftyJSON

class SettingController: BaseController{
     fileprivate let profileAPI = API.Settings.profile.ENV
    
    func getProfile(id: String, onSuccess: @escaping SingleResultListener<UserModel>,
                           onFailed: @escaping MessageListener,
                           onComplete: @escaping MessageListener) {
        let url = "\(profileAPI)/\(id)"
        httpHelper.requestAPI(url: url, param: nil, method: .get) {
            (success, statusCode, json) in
            if success {
                guard let data = json else {
                    onFailed("Null response from server")
                    return
                }
                let response = ResponseModel(with: data)
                
                if statusCode == 200 {
                    guard let datas = response.data else {return}
                    let user = UserModel(json: datas)
                    
                    onSuccess(200, "Success fetching data", user)
                    onComplete("Fetching data completed")
                }
            }else{
                if statusCode >= 400 {
                    onFailed("Bad request")
                } else if statusCode >= 500 {
                    onFailed("Internal server error")
                } else {
                    let alert = JDropDownAlert()
                    alert.alertWith("Please Check Your Connection", message: nil, topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "f52d5a"), image: nil)
                    
                    onFailed("An error occured")
                }
            }
        }
    }
}
