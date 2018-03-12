//
//  AnnouncementController.swift
//  AseanGames
//
//  Created by Calista on 3/5/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import Foundation
import SwiftyJSON

class AnnouncementController: BaseController {
    fileprivate let homeAPI = API.Announcement.home.ENV
    fileprivate let historyAPI = API.Announcement.history.ENV
    fileprivate let pinnedAPI = API.Announcement.pinned.ENV
    
    func getAnnouncement(onSuccess: @escaping SingleResultListener<AnnouncementModel>,
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
                    let home = AnnouncementModel(json: datas)
                   
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
    
    func getHistory(onSuccess: @escaping CollectionResultListener<DataAnnouncement>,
                    onFailed: @escaping MessageListener,
                    onComplete: @escaping MessageListener) {
        httpHelper.requestAPI(url: historyAPI, param: nil, method: .get) {
            (success, statusCode, json) in
            if success {
                guard let data = json else {
                    onFailed("Null response from server")
                    return
                }
                let response = ResponseModel(with: data)
                
                if statusCode == 200 {
                    guard let datas = response.data else {return}
                    var histories = [DataAnnouncement]()
                    for value in datas.arrayValue {
                        let history = DataAnnouncement(json: value)
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
    
    func getPinned(onSuccess: @escaping CollectionResultListener<DataAnnouncement>,
                    onFailed: @escaping MessageListener,
                    onComplete: @escaping MessageListener) {
        httpHelper.requestAPI(url: pinnedAPI, param: nil, method: .get) {
            (success, statusCode, json) in
            if success {
                guard let data = json else {
                    onFailed("Null response from server")
                    return
                }
                let response = ResponseModel(with: data)
                
                if statusCode == 200 {
                    guard let datas = response.data else {return}
                    var histories = [DataAnnouncement]()
                    for value in datas.arrayValue {
                        let history = DataAnnouncement(json: value)
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
    
    func getDetailAnnouncement(id: String, onSuccess: @escaping SingleResultListener<DetailAnnounModel>,
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
                    let detail = DetailAnnounModel(json: datas)
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
    
    func getRecipient(id: String ,onSuccess: @escaping CollectionResultListener<RecipientModel>,
                   onFailed: @escaping MessageListener,
                   onComplete: @escaping MessageListener) {
        let url = "\(homeAPI)/\(id)/recipients"
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
                    var recipients = [RecipientModel]()
                    for value in datas.arrayValue {
                        let recipient = RecipientModel(json: value)
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
