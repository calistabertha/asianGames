//
//  Movie.swift
//  ProjectStructure
//
//  Created by Digital Khrisna on 6/19/17.
//  Copyright © 2017 codigo. All rights reserved.
//

import SwiftyJSON

class Movie {
    var posterPath: String
    var isAdult: Bool
    var overview: String
    var releaseDate: String
    var genreIds: [Genre]
    var id: String
    var originalTitle: String
    var originalLanguage: String
    var title: String
    var backdropPath: String
    var popularity: Double
    var voteCount: Int
    var isVideo: Bool
    var voteAverage: Double
    
    init(posterPath: String, isAdult: Bool, overview: String, releaseDate: String, genreIds: [Genre], id: String, originalTitle: String, originalLanguage: String, title: String, backdropPath: String, popularity: Double, voteCount: Int, isVideo: Bool, voteAverage: Double) {
        self.posterPath = posterPath
        self.isAdult = isAdult
        self.overview = overview
        self.releaseDate = releaseDate
        self.genreIds = genreIds
        self.id = id
        self.originalTitle = originalTitle
        self.originalLanguage = originalLanguage
        self.title = title
        self.backdropPath = backdropPath
        self.popularity = popularity
        self.voteCount = voteCount
        self.isVideo = isVideo
        self.voteAverage = voteAverage
    }
    
    convenience init(json: JSON){
        let posterPath = json["poster_path"].stringValue
        let isAdult = json["adult"].boolValue
        let overview = json["overview"].stringValue
        let releaseDate = json["release_date"].stringValue
        let id = json["id"].stringValue
        let originalTitle = json["original_title"].stringValue
        let originalLanguage = json["original_language"].stringValue
        let title = json["title"].stringValue
        let backdropPath = json["backdrop_path"].stringValue
        let popularity = json["popularity"].doubleValue
        let voteCount = json["vote_count"].intValue
        let isVideo = json["video"].boolValue
        let voteAverage = json["vote_average"].doubleValue
        
        var genres = [Genre]()
        for value in json["genre_ids"].arrayValue {
            let genre = Genre(json: value)
            genres.append(genre)
        }
        
        self.init(posterPath: posterPath, isAdult: isAdult, overview: overview, releaseDate: releaseDate, genreIds: genres, id: id, originalTitle: originalTitle, originalLanguage: originalLanguage, title: title, backdropPath: backdropPath, popularity: popularity, voteCount: voteCount, isVideo: isVideo, voteAverage: voteAverage)
    }
}
