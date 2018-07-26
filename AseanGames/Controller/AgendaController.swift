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
                         onFailed: @escaping CodeMessageListener,
                         onComplete: @escaping SingleResultListener<AgendaModel>) {
        httpHelper.requestAPI(url: homeAPI, param: nil, method: .get) {
            (success, statusCode, json) in
            if success {
                guard let data = json else {
                    onFailed(400, "Null response from server")
                    return
                }
                let response = ResponseModel(with: data)
                
                if statusCode == 200 {
                    guard let datas = response.data else {
                        onFailed(202, "No data")
                        return
                    }
                    let home = AgendaModel(json: datas)
                    
                    onSuccess(200, "Success fetching data", home)
                    onComplete(200, "Fetching data completed", home)
                }
            }else{
                if statusCode >= 400 {
                    onFailed(400, "Bad request")
                } else if statusCode >= 500 {
                    onFailed(500, "Internal server error")
                } else {
                    let alert = JDropDownAlert()
                    alert.alertWith("Server Temporarily Unavailable", message: nil, topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "f52d5a"), image: nil)
                    onFailed(600, "An error occured")
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
                    alert.alertWith("Server Temporarily Unavailable", message: nil, topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "f52d5a"), image: nil)
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
                    alert.alertWith("Server Temporarily Unavailable", message: nil, topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "f52d5a"), image: nil)
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
                    alert.alertWith("Server Temporarily Unavailable", message: nil, topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "f52d5a"), image: nil)
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
                    alert.alertWith("Server Temporarily Unavailable", message: nil, topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "f52d5a"), image: nil)
                    onFailed("An error occured")
                }
            }
        }
    }
    
    func requestAgenda(title: String, description: String, location: String, guest: [String]?, group: [String]?, date: String, timeStart: String, timeEnd: String, onSuccess: @escaping SingleResultListener<String>,
                             onFailed: @escaping MessageListener,
                             onComplete: @escaping MessageListener) {
//        var groupParam:JSON = [:]
//        if let g = group {
//           groupParam["group"].arrayObject = g
//        }
//        if let g = guest {
//            groupParam["guest"].arrayObject = g
//        }
        
        var groupParam = JSON()
        var g = [String]()
        var gu = [String]()
        if group == nil {
            g = [""]
        }else {
            guard let gg = group else {return}
            g = gg
        }
        
        if guest == nil {
            gu = [""]
        }else {
            guard let gg = guest else {return}
            gu = gg
        }
        
        groupParam = ["guest":gu,"group":g]
        
        let params:[String:Any] = ["title": title,
                                      "description": description,
                                      "recipient": groupParam,
                                      "location" : location,
                                      "date": date,
                                      "time_start": "\(timeStart)",
                                      "time_end": "\(timeEnd)"]
     
        print("param \(params)")
        
        httpHelper.requestAPI(url: homeAPI, param: params, method: .post) {
            (success, statusCode, json) in
            if success {
                guard let data = json else {
                    onFailed("Null response from server")
                    return
                }
                let response = ResponseModel(with: data)
                
                if statusCode == 200 {
                    
                    onSuccess(200, "Success fetching data", response.displayMessage)
                    onComplete("Fetching data completed")
                }
            }else{
                if statusCode >= 400 {
                    onFailed("Bad request")
                } else if statusCode >= 500 {
                    onFailed("Internal server error")
                } else {
                    let alert = JDropDownAlert()
                    alert.alertWith("Server Temporarily Unavailable ", message: nil, topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "f52d5a"), image: nil)
                    onFailed("An error occured")
                }
            }
        }
    }
}


