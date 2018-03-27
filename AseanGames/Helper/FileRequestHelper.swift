//
//  FileRequest.swift
//  AseanGames
//
//  Created by Fajar on 3/21/18.
//  Copyright © 2018 codigo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

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
    
    func uploadFile(url:String,parameter:[String:String], fileParameter:[String:URL], completion: @escaping(_ success: Bool, _ statusCode: Int, _ data: JSON?) -> Void){
        print("print \(parameter)")
        let token = UserDefaults.standard.getToken()
        let header = [
            "authorization" : token
        ]

        upload(multipartFormData: { (formData) in
            for (key, url) in fileParameter {
                do{
                    let filename = url.lastPathComponent
                    let data = try Data(contentsOf: url)
                    print("file \(filename) \(data.count)")
                    formData.append(data, withName: key, fileName: filename, mimeType: "application/octet-stream")
                }catch let e {
                    print("error type \(e)")
                }
            }
            for(key, value) in parameter {
                formData.append(value.data(using: .utf8)!, withName: key)
            }
        }, to: url, headers:header) { (result) in
            switch result {
            case .success (let request,  _,  _):
                request.responseJSON(completionHandler: { (respon) in
                    print("respon \(respon.result.value) \(respon.result.error)")
                    self.requestHandler(response: respon, url: "", param: [:], method: .post, completion: completion)
                })
                print("success data")
                break
            
            case .failure(let error):
                print("Error data \(error)")
                break
            }
        }
    }
}


