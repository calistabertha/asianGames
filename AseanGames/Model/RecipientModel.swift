//
//  RecipientModel.swift
//  AseanGames
//
//  Created by Calista on 3/7/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import SwiftyJSON

class RecipientModel {
    var name : String
    var title : String
    var photo : String
    
    init(name : String, title : String, photo : String) {
        self.name = name
        self.title = title
        self.photo = photo
    }
    
    convenience init(json: JSON){
        let name = json["name"].stringValue
        let title = json["title"].stringValue
        let photo = json["photo"].stringValue
        
        self.init(name: name, title: title, photo: photo)
    }
}
