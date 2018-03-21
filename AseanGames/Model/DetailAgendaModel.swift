//
//  DetailAgendaModel.swift
//  AseanGames
//
//  Created by Calista on 3/12/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import SwiftyJSON

class DetailAgendaModel{
    var id : Int
    var title : String
    var date : String
    var time : String
    var location : String
    var address : String
    var description : String
    var user : String
    var photo : String
    var assignment : String
    var createAt : String
    var attendants : [String]
    var more : Int
    var respond : Int
    var isPast : Bool
    
    init(id : Int, title : String, date : String, time : String, location : String, address : String, description : String, user : String, photo : String, assignment : String, createAt : String, more : Int, attendants : [String], respond : Int, isPast: Bool) {
        self.id = id
        self.title = title
        self.date = date
        self.time = time
        self.location = location
        self.address = address
        self.description = description
        self.user = user
        self.photo = photo
        self.assignment = assignment
        self.createAt = createAt
        self.more = more
        self.respond = respond
        self.attendants = attendants
        self.isPast = isPast
        
    }
    
    convenience init (json: JSON){
        let id = json["id"].intValue
        let title = json["title"].stringValue
        let date = json["date"].stringValue
        let time = json["time"].stringValue
        let location = json["location"].stringValue
        let address = json["address"].stringValue
        let description = json["description"].stringValue
        let user = json["user"].stringValue
        let photo = json["photo"].stringValue
        let assignment = json["assignment"].stringValue
        let createAt = json["created_at"].stringValue
        let more = json["more-attendants"].intValue
        let respond = json["respond"].intValue
        var attends : [String] = []
        if let attendats = json["attendants"].arrayObject , let att = attendats as? [String]{
            attends = att
        }
        let isPast = json["isPast"].stringValue == "true" ? true : false
        
        self.init(id: id, title: title, date: date, time: time, location: location, address: address, description: description, user: user, photo: photo, assignment: assignment, createAt: createAt, more: more, attendants: attends, respond: respond, isPast: isPast)
    }
}
