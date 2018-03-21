//
//  DetailGroupModel.swift
//  AseanGames
//
//  Created by Calista on 3/16/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import SwiftyJSON

class DetailGroupModel{
    var group : GroupModel
    var friends : [RecipientModel]
    var announcement : [DataAnnouncement]
    
    init(group : GroupModel, friends : [RecipientModel], announcement : [DataAnnouncement]) {
        self.group = group
        self.friends = friends
        self.announcement = announcement
    }
    
    convenience init (json: JSON){
       let group = GroupModel(json: json["group"])
        
        var friends = [RecipientModel]()
        for value in json["friends"].arrayValue {
            let datas = RecipientModel(json: value)
            friends.append(datas)
        }
        
        var announcement = [DataAnnouncement]()
        for value in json["announcements"].arrayValue {
            let datas = DataAnnouncement(json: value)
            announcement.append(datas)
        }
        
        self.init(group: group, friends: friends, announcement: announcement)
    }
}
