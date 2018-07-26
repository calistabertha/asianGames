//
//  HTTPHelper.swift
//
//
//  Created by Digital Khrisna on 3/24/17.
//  Copyright © 2017 Digital Khrisna. All rights reserved.
//

import Alamofire
import SwiftyJSON

public enum HTTPMethodHelper: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
    
    func toHTTPMethod() -> HTTPMethod {
        switch self {
        case .get:
            return HTTPMethod.get
        case .post:
            return HTTPMethod.post
        case .put:
            return HTTPMethod.put
        case .delete:
            return HTTPMethod.delete
        }
    }
}

public enum HTTPCode: Int {
    case success = 200
    case failure = 400
    case unreachable = 500
}

class HTTPHelper {
    
    static let shared = HTTPHelper()
    
    private let manager: SessionManager
    
    private let header = [
        "Content-Type" : "application/x-www-form-urlencoded"
    ]
    
    init() {
        let config = URLSessionConfiguration.default
        
        /*
        * Add or remove configuration below if needed
        */
        
        //config.requestCachePolicy = .useProtocolCachePolicy
        config.timeoutIntervalForRequest = 5
        config.urlCache = nil
        
        manager = Alamofire.SessionManager(configuration: config)
    }
    
    func request(url: String, param: Parameters?, method: HTTPMethodHelper, completion: @escaping(_ success: Bool, _ statusCode: Int, _ data: JSON?) -> Void) {
        manager.request(url, method: method.toHTTPMethod(), parameters: param, headers: self.header).responseJSON { (response) in
            if let responHeader = response.response?.statusCode {
                if responHeader >= 400 {
                    completion(false, responHeader, nil)
                } else {
                    if let json = response.result.value {
                        let data = JSON(json)
                        completion(true, responHeader, data)
                    }
                }
            }
        }
    }
    
    /*
     * Currently this method set to fileprivate
     * Set as public when API need to request with JWT header
     */
    func requestAPI(url: String, param: Parameters?, method: HTTPMethodHelper, completion: @escaping(_ success: Bool, _ statusCode: Int, _ data: JSON?) -> Void) {
        
        let token = UserDefaults.standard.getToken()
        let header = [
            "Token" : "e6416f83cffce3909c21bbd4c9b40e1b9ca286f8"
        ]
        
        manager.request(url, method: method.toHTTPMethod(), parameters: param, headers: header).responseJSON {
            (response) in
        //    self.requestHandler(response: response, url: url, param: param, method: method, completion: completion)
            
            if let responHeader = response.response?.statusCode { //statusCode = status server
                if responHeader >= 400 {
                    completion(false, responHeader, nil)
                } else {
                    if let json = response.result.value {
                        let data = JSON(json)
                        completion(true, responHeader, data)
                    }
                }
            }
        
        }
    }
    
    func requestHandler(response: DataResponse<Any>, url: String, param: Parameters?, method: HTTPMethodHelper, completion: @escaping(_ success: Bool,_ statusCode: Int, _ data: JSON?) -> Void) {
        if let data = response.result.value {
            let json = JSON(data)
            if json["status"].intValue >= 400 {
                if json["display_message"].stringValue.range(of: "token") != nil{
                    let alert = UIAlertController.init(title: "Your session has been expired. Please login again", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (action) in
                        let storyboard = UIStoryboard(name: StoryboardReferences.authentication, bundle: nil)
                        let loginViewController = storyboard.instantiateViewController(withIdentifier: ViewControllerID.Authentication.login) as! SignInViewController
                        
                        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = loginViewController
                        (UIApplication.shared.delegate as! AppDelegate).window?.makeKeyAndVisible()
                    }))
                    
                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: false, completion: nil)
                }
//                else if json["display_message"].stringValue.range(of: "File type") != nil{
//                    let alert = JDropDownAlert()
//                    alert.alertWith("File type not support!", message: "Only pdf, doc, docx, xls, xlsx, ppt, pptx, jpg, jpeg, png, tiff, bmp, gif, mp4, flv & avi were allowed!", topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "f52d5a"), image: nil)
//                    
//                }
                else{
                    print("\(json["display_message"].stringValue)")
                    let alert = JDropDownAlert()
                    alert.alertWith("", message: json["display_message"].stringValue, topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(hexString: "f52d5a"), image: nil)
                }
                
            } else {
                completion(true,200, json)
            }
        } else {
            completion(false,200, nil)
        }
    }
    
    /*
     * Use when upload file to server (JPG)
     */
    func requestFormData(url: String, param: [String : Any], completion: @escaping(_ success: Bool, _ statusCode: Int, _ data: JSON?) -> Void){
        let header = [
            "content-type": "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
            "cache-control": "no-cache"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                if value is String {
                    multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                } else {
                    multipartFormData.append((value as! Data), withName: key, fileName: "images.jpg", mimeType: "image/jpeg")
                }
            }
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold,
           to: url,
           method: .post,
           headers: header) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response)
                    if let responHeader = response.response?.statusCode {
                        if responHeader >= 400 {
                            completion(false, responHeader, nil)
                        } else {
                            if let json = response.result.value {
                                let data = JSON(json)
                                completion(true, responHeader, data)
                            }
                        }
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                completion(false, 400, nil)
            }
        }
    }
}
