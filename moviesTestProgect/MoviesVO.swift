//
//  Movies.swift
//  moviesTestProgect
//
//  Created by Pavlo Kharambura on 8/22/17.
//  Copyright © 2017 Pavlo Kharambura. All rights reserved.
//

import Foundation
import ObjectMapper

struct MoviesVO {
    var title: String?
    var originalTitle: String?
    var voteAverage: Double?
    var posterPath: String?
    var releaseDate: String?
    var overview: String?
}

extension MoviesVO: Mappable {
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        originalTitle <- map["original_title"]
        voteAverage <- map["vote_average"]
        posterPath <- map["poster_path"]
        releaseDate <- map["release_date"]
        overview <- map["overview"]
    }

}
