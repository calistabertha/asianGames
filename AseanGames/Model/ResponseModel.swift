//
//  ResponseModel.swift
//  AseanGames
//
//  Created by Calista on 5/24/17.
//  Copyright © 2017 codigo. All rights reserved.
//

import SwiftyJSON

class ResponseModel {
    var status: Int
    var displayMessage: String
    var message: String
    var data: JSON?
    
    init(status: Int, displayMessage: String, message: String, data: JSON?) {
        self.status = status
        self.displayMessage = displayMessage
        self.message = message
        self.data = data
    }
    
    convenience init(without data: JSON) {
        let status = data["status"].intValue
        let message = data["message"].stringValue
        
        let display = data["display_message"].stringValue
//        var displayMessage = ""
//        if messageJSON.type == Type.string {
//            for (_, subJSON) : (String, JSON) in messageJSON {
//                if let msg = subJSON.arrayValue.first?.stringValue {
//                    displayMessage = msg
//                    break
//                }
//            }
//        } else {
//            displayMessage = messageJSON.stringValue
//        }
        
       self.init(status: status, displayMessage: display, message: message, data: nil)
    }
    
    convenience init(with data: JSON) {
        let status = data["status"].intValue
        let message = data["message"].stringValue
        let display = data["display_message"].stringValue
//
//        var messageJSON = data["display_message"]
//        var displayMessage = ""
//        if messageJSON.type == Type.string {
//            for (_, subJSON) : (String, JSON) in messageJSON {
//                if let msg = subJSON.arrayValue.first?.stringValue {
//                    displayMessage = msg
//                    break
//                }
//            }
//        } else {
//            displayMessage = messageJSON.stringValue
//        }
//
        
        let datas = data["data"]
        
        self.init(status: status, displayMessage: display, message: message, data: datas)
    }
}

