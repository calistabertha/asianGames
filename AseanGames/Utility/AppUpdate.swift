//
//  AppUpdate.swift
//  ProjectStructure
//
//  Created by Digital Khrisna on 6/9/17.
//  Copyright © 2017 codigo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AppUpdate {
    final let appManagerURL = "http://10.4.3.239:8080/appmanager/mobile/api/v1/version"
    
    var appID: String
    
    init(appID: String) {
        self.appID = appID
    }
    
    func checkAppVersion() {
        let currentVersion = Bundle.main.releaseVersionNumber
        
        guard let curVer = currentVersion else {
            print("[CHECKAPPVERSION] -> an error occurred when try get current version of application")
            return
        }
        
        let params = ["app_id" : self.appID, "app_version" : curVer, "app_platform" : "ios"]
        
        request(self.appManagerURL, method: .get, parameters: params).responseJSON {
            (response) in
            if let json = response.result.value {
                let data = JSON(json)
                
                let availableVersion = data["metadata"]["version"].stringValue
                let isForceUpdate = data["metadata"]["force_update"].boolValue
                let linkUpdate = data["metadata"]["link_update"].stringValue
                
                let cVersion = Version.init(curVer)
                let aVersion = Version.init(availableVersion)
                
                if data["status"].intValue == 200 {
                    if self.isUpdateAvailable(current: cVersion, available: aVersion) {
                        if isForceUpdate {
                            let alert = UIAlertController.init(title: "Update Available", message: "A new version of Application is available. Please update to version " + availableVersion + " now.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: {
                                (action) in
                                if let url = URL(string: linkUpdate) {
                                    UIApplication.shared.openURL(url)
                                }
                            }))
                            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: false, completion: nil)
                        } else {
                            let alert = UIAlertController.init(title: "Update Available", message: "A new version of Application is available. Do you want update to version " + availableVersion + "?", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Skip", style: UIAlertActionStyle.default, handler: nil))
                            
                            alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default, handler: {
                                (action) in
                                if let url = URL(string: linkUpdate) {
                                    UIApplication.shared.openURL(url)
                                }
                            }))
                            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: false, completion: nil)
                        }
                    } else {
                        print("[CHECKAPPVERSION] -> App is uptodate")
                    }
                } else if data["status"].intValue == 204 {
                    print("[CHECKAPPVERSION] -> App is uptodate")
                } else {
                    print("[CHECKAPPVERSION] -> " + data["message"].stringValue)
                }
            }else{
                print("[CHECKAPPVERSION] -> Error while request app manager server")
            }
        }
    }
    
    private func isUpdateAvailable(current: Version, available: Version) -> Bool {
        if current.major < available.major {
            return true
        } else if current.minor < available.minor {
            return true
        } else if current.patch < available.patch {
            return true
        } else {
            return false
        }
    }
}

fileprivate struct Version {
    public private(set) var major: Int = 0
    public private(set) var minor: Int = 0
    public private(set) var patch: Int = 0
    
    public init(major: Int, minor: Int = 0, patch: Int = 0) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
    
    public init(_ string: String) {
        let components = string.characters.split(separator: ".").map { String($0) }
        
        if components.count > 0, let major = Int(components[0]) {
            self.major = major
        }
        
        if components.count > 1, let minor = Int(components[1]) {
            self.minor = minor
        }
        
        if components.count > 2, let patch = Int(components[2]) {
            self.patch = patch
        }
    }
}

extension Version : CustomStringConvertible {
    public var description: String {
        return "\(major).\(minor).\(patch)"
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
