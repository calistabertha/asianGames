//
//  AgendaController.swift
//  AseanGames
//
//  Created by Calista on 3/8/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import Foundation
import SwiftyJSON

class AgendaController: BaseController {
     fileprivate let homeAPI = API.Agenda.home.ENV
    
    func getAgenda(onSuccess: @escaping SingleResultListener<AgendaModel>,
                         onFailed: @escaping MessageListener,
                         onComplete: @escaping MessageListener) {
        httpHelper.requestAPI(url: homeAPI, param: nil, method: .get) {
            (success, statusCode, json) in
            if success {
                guard let data = json else {
                    onFailed("Null response from server")
                    return
                }
                let response = ResponseModel(with: data)
                
                if statusCode == 200 {
                    guard let datas = response.data else {return}
                    let home = AgendaModel(json: datas)
                    
                    onSuccess(200, "Success fetching data", home)
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
