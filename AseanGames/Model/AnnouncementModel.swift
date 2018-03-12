//
//  AnnouncementModel.swift
//  AseanGames
//
//  Created by Calista on 3/5/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import SwiftyJSON

class AnnouncementModel {
    var pinned : [DataAnnouncement]
    var recent : [DataAnnouncement]
    var isCreate : Bool
    
    init(pinned: [DataAnnouncement], recent: [DataAnnouncement], isCreate: Bool){
        self.pinned = pinned
        self.recent = recent
        self.isCreate = isCreate
    }
    
    convenience init(json: JSON){
        var pinned = [DataAnnouncement]()
        for value in json["pinned"].arrayValue {
            let datas = DataAnnouncement(json: value)
            pinned.append(datas)
        }
        
        var recent = [DataAnnouncement]()
        for value in json["recent"].arrayValue {
            let datas = DataAnnouncement(json: value)
            recent.append(datas)
        }
        
        let isCreate = json["create"].stringValue == "true" ? true : false
        
        self.init(pinned: pinned, recent: recent, isCreate: isCreate)
    }
}

class DataAnnouncement{
    var id : String
    var title : String
    var description : String
    var attachment : Int
    var user : String
    var assignment : String
    var photo : String
    var date : String
    var time : String
    var createAt : String
    var pinned : Bool
    
    init(id: String, title : String, description : String, attachment : Int, user : String, assignment : String, photo : String, date : String, time : String, createAt: String, pinned : Bool){
        self.id = id
        self.title = title
        self.description = description
        self.attachment = attachment
        self.user = user
        self.assignment = assignment
        self.photo = photo
        self.date = date
        self.time = time
        self.createAt = createAt
        self.pinned = pinned
    }
    
    convenience init(json: JSON){
        let id = json["id"].stringValue
        let title = json["title"].stringValue
        let description = json["description"].stringValue
        let attachment = json["attachment"].intValue
        let user = json["user"].stringValue
        let assignment = json["assignment"].stringValue
        let photo = json["photo"].stringValue
        let date = json["date"].stringValue
        let time = json["time"].stringValue
        let createAt = json["created_at"].stringValue
        let pinned = json["pinned"].stringValue == "true" ? true : false
        
        self.init(id: id, title: title, description: description, attachment: attachment, user: user, assignment: assignment, photo: photo, date: date, time: time, createAt: createAt, pinned: pinned)
    }

}

