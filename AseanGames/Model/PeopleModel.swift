//
//  PeopleModel.swift
//  AseanGames
//
//  Created by Calista on 3/16/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import SwiftyJSON

class PeopleModel{
    var group : [GroupModel]
    var friends : [RecipientModel]
    
    init(group : [GroupModel], friends : [RecipientModel]) {
        self.group = group
        self.friends = friends
    }
    
    convenience init(json: JSON){
        var group = [GroupModel]()
        for value in json["group"].arrayValue {
            let datas = GroupModel(json: value)
            group.append(datas)
        }
        
        var friends = [RecipientModel]()
        for value in json["friends"].arrayValue {
            let datas = RecipientModel(json: value)
            friends.append(datas)
        }
        
        self.init(group: group, friends: friends)
    }
}

class GroupModel{
    var id : Int
    var name : String
    var photo : String
    var member : Int
    var image : String
    
    init(id : Int, name : String, photo : String, member : Int, image : String){
        self.id = id
        self.name = name
        self.photo = photo
        self.member = member
        self.image = image
    }
    
    convenience init(json: JSON){
        let id = json["id"].intValue
        let name = json["name"].stringValue
        let photo = json["photo"].stringValue
        let member = json["member"].intValue
        let image = json["image"].stringValue
        
        self.init(id: id, name: name, photo: photo, member: member, image: image)
    }
}
