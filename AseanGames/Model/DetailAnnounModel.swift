//
//  DetailAnnounModel.swift
//  AseanGames
//
//  Created by Calista on 3/7/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import SwiftyJSON

class DetailAnnounModel {
    var recipient : DataRecipient
    var id : Int
    var title : String
    var description : String
    var attachment : Int
    var date : String
    var user : String
    var assigment : String
    var photo : String
    var time : String
    var creatAt : String
    var isPast : Bool

    init(recipient : DataRecipient, id : Int, title : String, description : String, attachment : Int, date : String, user : String, assigment : String, photo : String, time : String, creatAt : String, isPast : Bool) {
        self.recipient = recipient
        self.id = id
        self.title = title
        self.description = description
        self.attachment = attachment
        self.date = date
        self.user = user
        self.assigment = assigment
        self.photo = photo
        self.time = time
        self.creatAt = creatAt
        self.isPast = isPast
    }
    
    convenience init(json: JSON){
        let recipient = DataRecipient(json: json["recipient"])
        let id = json["id"].intValue
        let title = json["title"].stringValue
        let description = json["description"].stringValue
        let attachment = json["attachment"].intValue
        let date = json["date"].stringValue
        let user = json["user"].stringValue
        let assigment = json["assignment"].stringValue
        let photo = json["photo"].stringValue
        let time = json["time"].stringValue
        let creatAt = json["created_at"].stringValue
        let isPast = json["isPast"].stringValue  == "true" ? true : false
        
        self.init(recipient: recipient, id: id, title: title, description: description, attachment: attachment, date: date, user: user, assigment: assigment, photo: photo, time: time, creatAt: creatAt, isPast: isPast)
    }
}

class DataRecipient{
    
    var image : [DataImage]
    var more : Int
    
    init(image : [DataImage], more : Int){
        self.image = image
        self.more = more
    }
    
    convenience init(json: JSON){
        var image = [DataImage]()
        for value in json["image"].arrayValue {
            let datas = DataImage(json: value)
            image.append(datas)
        }
        let more = json["more"].intValue
        
        self.init(image: image, more: more)
    }
}

class DataImage{
    var id : Int
    var image : String
    
    init(id : Int, image : String) {
        self.id = id
        self.image = image
    }
    
    convenience init(json: JSON){
        let id = json["id"].intValue
        let image = json["image"].stringValue
        
        self.init(id: id, image: image)
    }
}
