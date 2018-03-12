//
//  BaseController.swift
//  ProjectStructure
//
//  Created by Digital Khrisna on 6/7/17.
//  Copyright © 2017 codigo. All rights reserved.
//
import Foundation

public typealias MessageListener = (String) -> Void

public typealias CodeMessageListener = (Int, String) -> Void

public typealias SingleResultListener<T> = (Int, String, T?) -> Void

public typealias CollectionResultListener<T> = (Int, String, [T]?) -> Void

protocol BaseController {
    /*
     *  Define function or properties for child
     */
}

extension BaseController {
    var httpHelper: HTTPHelper {
        return HTTPHelper.shared
    }
    
    /*
     *  Input your reuse logic on controller here
     */
}
