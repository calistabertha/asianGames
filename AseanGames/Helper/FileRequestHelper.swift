//
//  FileRequest.swift
//  AseanGames
//
//  Created by Fajar on 3/21/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit
import Alamofire

typealias progressFile = (_ currentUrl:Int,_ totalUrl:Int,_ isSuccess:Bool, _ error:Error?) -> Void
typealias completeFile = (_ currentUrl:Int,_ totalUrl:Int,_ isSuccess:Bool, _ error:Error?) -> Void

extension HTTPHelper {
    
    
    func downloadFile(_ url:[String], onProgress:@escaping (progressFile), onComplete:@escaping (completeFile)){
        print("Download \(url)")
        DispatchQueue.global(qos: .background).async {
            self.requestDownload(url, 0, onProgress, onComplete)
        }
    }
    
    
    fileprivate func requestDownload(_ url:[String],_ current:Int,_ onProgress:@escaping progressFile,_ onComplete:@escaping completeFile){
        let fileDestination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, in: .userDomainMask)
        download(url[current], to: fileDestination)
            .response(completionHandler: { (respon) in
                
                let code = respon.response?.statusCode
                if code == 200 , let url = respon.destinationURL {
                    do {
                    if let icloudurl = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents").appendingPathComponent("OCC") {
                            print("Check iCloud")
                            if !FileManager.default.fileExists(atPath: icloudurl.path) {
                                try FileManager.default.createDirectory(at: icloudurl, withIntermediateDirectories: true, attributes: nil)
                            }
                        let iurl = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
                            let fileCloudUrl = icloudurl.appendingPathComponent(url.lastPathComponent)
                            print("Check file Exist")
                            if FileManager.default.fileExists(atPath: fileCloudUrl.path) {
                                try FileManager.default.removeItem(at: fileCloudUrl)
                            }
                            print("Copy file \(fileCloudUrl)")
                            try FileManager.default.copyItem(at: url, to: fileCloudUrl)
                    }
                        print("remove file")
                        try FileManager.default.removeItem(at: url)
                    }catch let error{
                        print("error \(error)")
                    }
                }
                if url.count == current + 1 {
                    DispatchQueue.main.async {
                        onComplete(current + 1, url.count, code == 200, respon.error)
                    }
                }else{
                    DispatchQueue.main.async {
                       onProgress(current + 1, url.count, code == 200, respon.error)
                    }
                    DispatchQueue.global(qos: .background).async {
                        self.requestDownload(url, current + 1, onProgress, onComplete)
                    }
                }
            })
    }
    
    func uploadFile(parameter:[String:String], file:[Data], filename:[String]){
        upload(multipartFormData: { (formData) in
            for(key, value) in parameter {
                formData.append(value.data(using: .utf8)!, withName: key)
                }
            file.forEach({ (f) in
                
            })
        }, to: "") { (result) in
            
        }
    }
}


