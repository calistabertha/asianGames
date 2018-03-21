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
    fileprivate let historyAPI = API.Agenda.history.ENV
    
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
    
    func getHistory(onSuccess: @escaping CollectionResultListener<HistoryModel>,
                    onFailed: @escaping MessageListener,
                    onComplete: @escaping MessageListener) {
        httpHelper.requestAPI(url: historyAPI, param: nil, method: .get) {
            (success, statusCode, json) in
            if success {
                guard let data = json else {
                    onFailed("Null response from server")
                    return
                }
               // let response = ResponseModel(with: data)
                
                if statusCode == 200 {
                    var histories = [HistoryModel]()
                    for value in data["data"]["history"].arrayValue {
                        let history = HistoryModel(json: value)
                        histories.append(history)
                    }
                    
                    onSuccess(200, "Success fetching data", histories)
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
    
    func getDetail(id: String, onSuccess: @escaping SingleResultListener<DetailAgendaModel>,
                   onFailed: @escaping MessageListener,
                   onComplete: @escaping MessageListener) {
        
        let url = "\(homeAPI)/\(id)"
        
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
                    let detail = DetailAgendaModel(json: datas)
                    onSuccess(200, "Success fetching data", detail)
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
    
    func requestRespond(id: String, respond: String, onSuccess: @escaping SingleResultListener<Int>,
        onFailed: @escaping MessageListener,
        onComplete: @escaping MessageListener) {
        
        let url = "\(homeAPI)/\(id)/respond"
        let param = ["response": respond]
        
        httpHelper.requestAPI(url: url, param: param, method: .post) {
            (success, statusCode, json) in
            if success {
                guard let data = json else {
                    onFailed("Null response from server")
                    return
                }
                let response = ResponseModel(with: data)
                
                if statusCode == 200 {
                    onSuccess(200, "Success fetching data", response.status)
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
    
    func getRecipient(id: String ,onSuccess: @escaping CollectionResultListener<RSVPModel>,
                      onFailed: @escaping MessageListener,
                      onComplete: @escaping MessageListener) {
        let url = "\(homeAPI)/\(id)/attendants"
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
                    var recipients = [RSVPModel]()
                    for value in datas.arrayValue {
                        let recipient = RSVPModel(json: value)
                        recipients.append(recipient)
                    }
                    
                    onSuccess(200, "Success fetching data", recipients)
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


