//
//  RecipientModel.swift
//  AseanGames
//
//  Created by Calista on 3/7/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import SwiftyJSON

class RecipientModel {
    var id : String
    var name : String
    var title : String
    var photo : String
    var isSelected: Bool = false
    
    init(id : String, name : String, title : String, photo : String) {
        self.id = id
        self.name = name
        self.title = title
        self.photo = photo
    }
    
    convenience init(json: JSON){
        let id = json["id"].stringValue
        let name = json["name"].stringValue
        let title = json["title"].stringValue
        let photo = json["photo"].stringValue
        
        self.init(id: id ,name: name, title: title, photo: photo)
    }
}
