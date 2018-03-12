//
//  AuthenticationController.swift
//  ProjectStructure
//
//  Created by Digital Khrisna on 6/7/17.
//  Copyright © 2017 codigo. All rights reserved.
//

import Foundation
import SwiftyJSON

class MovieController: BaseController {
    
    /*
     *  Define all REST URL as properties
     */
    fileprivate let popularMovieAPI = REST.Movie.popular.ENV
    
    func getPopularMovie(onSuccess: @escaping CollectionResultListener<Movie>,
                         onFailed: @escaping MessageListener,
                         onComplete: @escaping MessageListener) {
    
        let params = [
            "api_key": Config.appKey
        ]
        
        httpHelper.request(url: popularMovieAPI, param: params, method: .get) {
            (success, statusCode, json) in
            if success {
                guard let data = json else {
                    onFailed("Null response from server")
                    return
                }
                
                if statusCode == 200 {
                    var movies = [Movie]()
                    for value in data["results"].arrayValue {
                        let movie = Movie(json: value)
                        movies.append(movie)
                    }
                    
                    onSuccess(200, "Success fetching data", movies)
                    onComplete("Fetching data completed")
                }
            }else{
                if statusCode >= 400 {
                    onFailed("Bad request")
                } else if statusCode >= 500 {
                    onFailed("Internal server error")
                } else {
                    onFailed("An error occured")
                }
            }
        }
    }
}
