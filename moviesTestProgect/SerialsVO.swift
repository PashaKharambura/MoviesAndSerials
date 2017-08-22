//
//  Serials.swift
//  moviesTestProgect
//
//  Created by Pavlo Kharambura on 8/22/17.
//  Copyright © 2017 Pavlo Kharambura. All rights reserved.
//

import Foundation
import ObjectMapper

struct SerialsVO {
    var name: String?
    var originalName: String?
    var voteAverage: Double?
    var posterPath: String?
    var firstAirDate: String?
    var overview: String?
    var voteCount: Int?
    var id: Int?
    var popularity: Double?
    var gendreIds: [Int]?
    var originalLanguage: String?
    var backdropPath: String?
    var originCountry: [String]?
}

extension SerialsVO: Mappable {
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        originalName <- map["original_name"]
        voteAverage <- map["vote_average"]
        posterPath <- map["poster_path"]
        firstAirDate <- map["first_air_date"]
        overview <- map["overview"]
        voteCount <- map["vote_count"]
        id <- map["id"]
        popularity <- map["popularity"]
        gendreIds <- map["genre_ids"]
        originalLanguage <- map["original_language"]
        backdropPath <- map["backdrop_path"]
        originCountry <- map["origin_country"]
    }
    
}
