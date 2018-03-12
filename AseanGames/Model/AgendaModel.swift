//
//  AgendaModel.swift
//  AseanGames
//
//  Created by Calista on 3/8/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import SwiftyJSON

class AgendaModel{
    var upNext : DataUpNext
    var today : [DataAgenda]
    var tomorrow : [DataAgenda]
    var isCreate : Bool
    
    init(upNext : DataUpNext, today : [DataAgenda], tomorrow : [DataAgenda], isCreate : Bool) {
        self.upNext = upNext
        self.today = today
        self.tomorrow = tomorrow
        self.isCreate = isCreate
        
    }
    
    convenience init(json: JSON){
        let upNext = DataUpNext(json: json["up-next"])
        var today = [DataAgenda]()
        for value in json["today"].arrayValue {
            let datas = DataAgenda(json: value)
            today.append(datas)
        }
        var tomorrow = [DataAgenda]()
        for value in json["tomorrow"].arrayValue {
            let datas = DataAgenda(json: value)
            tomorrow.append(datas)
        }
        
        let isCreate = json["create"].stringValue == "true" ? true : false
        
        self.init(upNext: upNext, today: today, tomorrow: tomorrow, isCreate: isCreate)
    }
}

class DataUpNext {
    var id : Int
    var title : String
    var date : String
    var time : String
    var description : String
    var location : String
    var address : String
    var user : String
    var assignment : String
    var photo : String
    // var attendants :
    var more : Int
    var response : Int
    
    init(id : Int, title : String, date : String, time : String, description : String, location : String, address : String, user : String, assignment : String, photo: String, more : Int, response : Int) {
        self.id = id
        self.title = title
        self.date = date
        self.time = time
        self.description = description
        self.location = location
        self.address = address
        self.user = user
        self.assignment = assignment
        self.more = more
        self.photo = photo
        self.response = response
    }
    
    convenience init(json: JSON){
        let id = json["id"].intValue
        let title = json["title"].stringValue
        let date = json["date"].stringValue
        let time = json["time"].stringValue
        let description = json["description"].stringValue
        let location = json["location"].stringValue
        let address = json["address"].stringValue
        let user = json["user"].stringValue
        let assignment = json["assignment"].stringValue
        let photo = json["photo"].stringValue
        // let attendants :
        let more = json["attendant-more"].intValue
        let response = json["response"].intValue
        
        self.init(id: id, title: title, date: date, time: time, description: description, location: location, address: address, user: user, assignment: assignment, photo: photo, more: more, response: response)
    }
}

class DataAgenda {
    var id : Int
    var title : String
    var location : String
    var date : String
    var timeStart : String
    var timeEnd : String
    var response : Int
    
    init(id : Int, title : String, location : String, date : String, timeStart : String, timeEnd : String, response : Int){
        self.id = id
        self.title = title
        self.location = location
        self.date = date
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.response = response
    }
    
    convenience init(json: JSON){
        let id = json["id"].intValue
        let title = json["title"].stringValue
        let location = json["location"].stringValue
        let date = json["date"].stringValue
        let timeStart = json["time_start"].stringValue
        let timeEnd = json["time_end"].stringValue
        let response = json["response"].intValue
        
        self.init(id: id, title: title, location: location, date: date, timeStart: timeStart, timeEnd: timeEnd, response: response)
    }
}
