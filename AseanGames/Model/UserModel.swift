//
//  UserModel.swift
//  AseanGames
//
//  Created by Calista on 2/5/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import SwiftyJSON

class UserModel {
    var id : String
    var firstName : String
    var lastName : String
    var nickName : String
    var phone : String
    var email : String
    var photo : String
    var department : DataDepartment
    var assignment : DataAssignment
    var createdAt : DataCreated
    var updateAt : DataCreated
    var resetPassword : Int
    var isLogin : Bool
    var status : String
    
    init( id : String, firstName : String, lastName : String, nickName : String, phone : String, email : String, photo : String, department : DataDepartment, assignment : DataAssignment, createdAt : DataCreated, updateAt : DataCreated, resetPassword : Int, isLogin : Bool, status : String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.nickName = nickName
        self.phone = phone
        self.email = email
        self.photo = photo
        self.department = department
        self.assignment = assignment
        self.createdAt = createdAt
        self.updateAt = updateAt
        self.resetPassword = resetPassword
        self.isLogin = isLogin
        self.status = status
    }
    
    convenience init(json: JSON){
      
        let id = json["id"].stringValue
        let firstName = json["first_name"].stringValue
        let lastName = json["last_name"].stringValue
        let nickName = json["nick_name"].stringValue
        let phone = json["phone"].stringValue
        let email = json["email"].stringValue
        let photo = json["photo"].stringValue
        let department = DataDepartment(json: json["department"]) 
        let assignment = DataAssignment(json: json["assignment"])
        let createdAt = DataCreated(json: json["created_at"])
        let updateAt = DataCreated(json: json["updated_at"])
        let resetPassword = json["reset_password"].intValue
        let isLogin = json["is_login"].intValue == 1 ? true : false
        let status = json["status"].stringValue
        
        self.init(id: id, firstName: firstName, lastName: lastName, nickName: nickName, phone: phone, email: email, photo: photo, department: department, assignment: assignment, createdAt: createdAt, updateAt: updateAt, resetPassword: resetPassword, isLogin: isLogin, status: status)
    }
}

class DataDepartment {
    var id : Int
    var name : String
    var assignmentID : Int
    
    init(id : Int, name : String, assignmentID : Int) {
        self.id = id
        self.name = name
        self.assignmentID = assignmentID
    }
    
    convenience init(json: JSON){
        let id = json["id"].intValue
        let name = json["name"].stringValue
        let assignmentID = json["assignment_id"].intValue
        
        self.init(id: id, name: name, assignmentID: assignmentID)
    }
}

class DataAssignment {
    var id : Int
    var name : String
    var categoryCode : String
    var cardType : String
    
    init(id : Int, name : String, categoryCode : String, cardType : String) {
        self.id = id
        self.name = name
        self.categoryCode = categoryCode
        self.cardType = cardType
    }
    
    convenience init(json: JSON){
        let id = json["id"].intValue
        let name = json["name"].stringValue
        let categoryCode = json["category_code"].stringValue
        let cardType = json["card_type"].stringValue
        
        self.init(id: id, name: name, categoryCode: categoryCode, cardType: cardType)
    }
}
class DataCreated{
    var date : String
    var timezoneType : Int
    var timezone : String
    
    init(date : String, timezoneType : Int, timezone : String){
        self.date = date
        self.timezoneType = timezoneType
        self.timezone = timezone
    }
    
    convenience init(json: JSON){
        let date = json["date"].stringValue
        let timezoneType = json["timezone_type"].intValue
        let timezone = json["timezone"].stringValue
        
        self.init(date: date, timezoneType: timezoneType, timezone: timezone)
    }
}
