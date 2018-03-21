//
//  HistoryModel.swift
//  AseanGames
//
//  Created by Calista on 3/12/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import SwiftyJSON

class HistoryModel{
    var date : String
    var agendas : [DataAgenda]
    
    init(date: String, agendas: [DataAgenda]) {
        self.date = date
        self.agendas = agendas
    }
    
    convenience init(json: JSON){
        let date = json["date"].stringValue
        var agendas = [DataAgenda]()
        for value in json["agendas"].arrayValue {
            let datas = DataAgenda(json: value)
            agendas.append(datas)
        }
        
        self.init(date: date, agendas: agendas)
    }

}

