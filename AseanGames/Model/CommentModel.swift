//
//  CommentModel.swift
//  AseanGames
//
//  Created by Calista on 3/15/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import SwiftyJSON

class CommentModel{
   
    var id : Int
    var userID : Int
    var comment : String
    var user : String
    var photo : String
    var title : String
    var createAt : String
    
    init(id : Int, userID : Int, comment : String, user : String, photo : String, title : String, createAt : String) {
        self.id = id
        self.userID = userID
        self.comment = comment
        self.user = user
        self.photo = photo
        self.title = title
        self.createAt = createAt
    }
    
    convenience init(json:JSON){
        let id = json["id"].intValue
        let userID = json["user_id"].intValue
        let comment = json["comment"].stringValue
        let user = json["user"].stringValue
        let photo = json["photo"].stringValue
        let title = json["title"].stringValue
        let createAt = json["created_at"].stringValue
        
        self.init(id: id, userID: userID, comment: comment, user: user, photo: photo, title: title, createAt: createAt)
        
    }
}

