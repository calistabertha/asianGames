//
//  RSVPModel.swift
//  AseanGames
//
//  Created by Calista on 3/14/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import SwiftyJSON

class RSVPModel {
    var name : String
    var title : String
    var photo : String
    var response : Int
    
    init(name : String, title : String, photo : String, response: Int) {
        self.name = name
        self.title = title
        self.photo = photo
        self.response = response
    }
    
    convenience init(json: JSON){
        let name = json["name"].stringValue
        let title = json["title"].stringValue
        let photo = json["photo"].stringValue
        let response = json["response"].intValue
        
        self.init(name: name, title: title, photo: photo, response: response)
    }
}

