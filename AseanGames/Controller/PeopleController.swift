//
//  PeopleController.swift
//  AseanGames
//
//  Created by Calista on 3/16/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import Foundation
import SwiftyJSON

class PeopleController: BaseController {
    fileprivate let peopleAPI = API.People.people.ENV
    fileprivate let groupAPI = API.People.group.ENV
    fileprivate let friendsAPI = API.People.friends.ENV
    fileprivate let profileAPI = API.People.profile.ENV
    fileprivate let searchAPI = API.People.search.ENV
    
    func getPeople(onSuccess: @escaping SingleResultListener<PeopleModel>,
                         onFailed: @escaping MessageListener,
                         onComplete: @escaping MessageListener) {
        httpHelper.requestAPI(url: peopleAPI, param: nil, method: .get) {
            (success, statusCode, json) in
            if success {
                guard let data = json else {
                    onFailed("Null response from server")
                    return
                }
                let response = ResponseModel(with: data)
                
                if statusCode == 200 {
                    guard let datas = response.data else {return}
                    let home = PeopleModel(json: datas)
                    
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
                    alert.alertWith("Server Temporarily Unavailable", message: nil, topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "f52d5a"), image: nil)
                    
                    onFailed("An error occured")
                }
            }
        }
    }
    
    func getGroup(onSuccess: @escaping CollectionResultListener<GroupModel>,
                        onFailed: @escaping MessageListener,
                        onComplete: @escaping MessageListener) {
        
        let url = "\(groupAPI)?limit=20&offset=0"
        
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
                    var groups = [GroupModel]()
                    for value in datas.arrayValue {
                        let group = GroupModel(json: value)
                        groups.append(group)
                    }
                    
                    onSuccess(200, "Success fetching data", groups)
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
    
    func getFriends(onSuccess: @escaping CollectionResultListener<RecipientModel>,
                  onFailed: @escaping MessageListener,
                  onComplete: @escaping MessageListener) {
        
        httpHelper.requestAPI(url: friendsAPI, param: nil, method: .get) {
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
                    alert.alertWith("Server Temporarily Unavailable", message: nil, topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "f52d5a"), image: nil)
                    onFailed("An error occured")
                }
            }
        }
    }
    
    func getSearchGroup(keyword: String, onSuccess: @escaping CollectionResultListener<GroupModel>,
                    onFailed: @escaping MessageListener,
                    onComplete: @escaping MessageListener) {
        let url = "\(searchAPI)\(keyword)"
        
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
                    var groups = [GroupModel]()
                    for value in datas.arrayValue {
                        let group = GroupModel(json: value)
                        groups.append(group)
                    }
                    
                    onSuccess(200, "Success fetching data", groups)
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
    
    func getSearchFriends(keyword: String, onSuccess: @escaping CollectionResultListener<RecipientModel>,
                        onFailed: @escaping MessageListener,
                        onComplete: @escaping MessageListener) {
        let url = "\(searchAPI)\(keyword)"
        
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
                    alert.alertWith("Server Temporarily Unavailable", message: nil, topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "f52d5a"), image: nil)
                    onFailed("An error occured")
                }
            }
        }
    }
    
    func getDetailGroup(id: String, filter: String, onSuccess: @escaping SingleResultListener<DetailGroupModel>,
                   onFailed: @escaping MessageListener,
                   onComplete: @escaping MessageListener) {
        let url = "\(groupAPI)/\(id)?filter=\(filter)"
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
                    let detail = DetailGroupModel(json: datas)
                    
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
    
    func getFriendsProfile(id: String, onSuccess: @escaping SingleResultListener<UserModel>,
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
                    alert.alertWith("Server Temporarily Unavailable", message: nil, topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "f52d5a"), image: nil)
                    
                    onFailed("An error occured")
                }
            }
        }
    }
    
    func getFriendsGroup(id: String, onSuccess: @escaping CollectionResultListener<GroupModel>,
                  onFailed: @escaping MessageListener,
                  onComplete: @escaping MessageListener) {
        
        let url = "\(peopleAPI)/\(id)/groups"
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
                    var groups = [GroupModel]()
                    for value in datas.arrayValue {
                        let group = GroupModel(json: value)
                        groups.append(group)
                    }
                    
                    onSuccess(200, "Success fetching data", groups)
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
    
    
    func getFriendsAgenda(id: String, onSuccess: @escaping CollectionResultListener<HistoryModel>,
                    onFailed: @escaping MessageListener,
                    onComplete: @escaping MessageListener) {
        
        let url = "\(peopleAPI)/\(id)/agendas"
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
                    var agendas = [HistoryModel]()
                    for value in datas.arrayValue {
                        let agenda = HistoryModel(json: value)
                        agendas.append(agenda)
                    }
                    
                    onSuccess(200, "Success fetching data", agendas)
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
}
