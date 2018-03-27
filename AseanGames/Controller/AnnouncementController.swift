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
    
    func getComment(id: String ,onSuccess: @escaping CollectionResultListener<CommentModel>,
                    onFailed: @escaping MessageListener,
                    onComplete: @escaping MessageListener) {
        let url = "\(homeAPI)/\(id)/comments"
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
                    var recipients = [CommentModel]()
                    for value in datas.arrayValue {
                        let recipient = CommentModel(json: value)
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
    
    func requestComment(id: String, comment: String ,onSuccess: @escaping SingleResultListener<String>,
                    onFailed: @escaping MessageListener,
                    onComplete: @escaping MessageListener) {
        let url = "\(homeAPI)/\(id)/comment"
        let params = ["comment": comment]
        httpHelper.requestAPI(url: url, param: params, method: .post) {
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
                    alert.alertWith("Please Check Your Connection", message: nil, topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "f52d5a"), image: nil)
                    onFailed("An error occured")
                }
            }
        }
    }
    
    func downloadAttachment(attachment:DataAttachment, onProgress: @escaping progressFile , onComplete: @escaping completeFile){
        HTTPHelper.shared.downloadFile(attachment.files, onProgress: onProgress, onComplete: onComplete)
    }
    
    func requestAnnouncement(title: String, description: String,files: [URL], group: [String], date: String, time: String ,onSuccess: @escaping SingleResultListener<String>,
                        onFailed: @escaping MessageListener,
                        onComplete: @escaping MessageListener) {
        var groupParam:JSON = ["type":1]
        if group.count > 0 {
            groupParam = ["type":2,"groups":group]
        }
        let params:[String:String] = ["title": "John Lennon Update For Announcement Group",
                      "description": "description description description description description description description description description description description description description description description",
                      "group": groupParam.rawString() ?? "",
                      "date": "2017-03-01",
                      "time": "12:00:00"]
        var fileParams:[String:URL] = [:]
        if files.count > 0 {
            for i in 0...files.count - 1 {
                fileParams["attachments[\(i)]"] = files[i]
            }
        }
        httpHelper.uploadFile(url: homeAPI, parameter: params, fileParameter: fileParams) { (isSuccess, code, data) in
            
        }
    }
}
