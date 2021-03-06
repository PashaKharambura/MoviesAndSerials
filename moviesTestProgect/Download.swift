//
//  Download.swift
//  moviesTestProgect
//
//  Created by Pavlo Kharambura on 8/22/17.
//  Copyright © 2017 Pavlo Kharambura. All rights reserved.
//

import Foundation
import SDWebImage
import Alamofire
import AlamofireObjectMapper

let apiKey = "55580621b06134aae72c3266c0fed8bf"
let popularMovieUrl = "https://api.themoviedb.org/3/movie/popular?api_key="
let topRatedMovieUrl = "https://api.themoviedb.org/3/movie/top_rated?api_key="
let nowPlayingMovieUrl = "https://api.themoviedb.org/3/movie/now_playing?api_key="
let searchMovieUrl = "https://api.themoviedb.org/3/search/movie?api_key="
let popularSerialUrl = "https://api.themoviedb.org/3/tv/popular?api_key="
let topRatedSerialsUrl = "https://api.themoviedb.org/3/tv/top_rated?api_key="
let nowPlayingSerialsUrl = "https://api.themoviedb.org/3/tv/airing_today?api_key="
let searchSerialsUrl = "https://api.themoviedb.org/3/search/tv?api_key="

public let langStr = Locale.current.languageCode


class Sender {

    func requestPopularMovies(page: Int, language: String, moviesLoaded: @escaping () -> Void) {
       
        let params = [
            "page" : page,
            "language" : language
        ] as [String : Any]
        
        Alamofire.request("\(popularMovieUrl)\(apiKey)", parameters: params).responseArray(queue: nil, keyPath: "results", context: nil) {
            (response: DataResponse<[MoviesVO]>) in
            switch response.result {
            case .success(let result):
                MoviesModel.instance.setMovies(movies: result)
                moviesLoaded()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        SwiftSpinner.hide()
    }
    
    func requestTopRatedMovies(page: Int, language: String, moviesLoaded: @escaping () -> Void) {
        
        let params = [
            "page" : page,
            "language" : language
            ] as [String : Any]
        
        Alamofire.request("\(topRatedMovieUrl)\(apiKey)", parameters: params).responseArray(queue: nil, keyPath: "results", context: nil) {
            (response: DataResponse<[MoviesVO]>) in
            switch response.result {
            case .success(let result):
                MoviesModel.instance.setMovies(movies: result)
                moviesLoaded()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        SwiftSpinner.hide()
    }
    
    func requestNowPlayingMovies(page: Int, language: String, moviesLoaded: @escaping () -> Void) {
        
        let params = [
            "page" : page,
            "language" : language
            ] as [String : Any]
        
        Alamofire.request("\(nowPlayingMovieUrl)\(apiKey)", parameters: params).responseArray(queue: nil, keyPath: "results", context: nil) {
            (response: DataResponse<[MoviesVO]>) in
            switch response.result {
            case .success(let result):
                MoviesModel.instance.setMovies(movies: result)
                moviesLoaded()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        SwiftSpinner.hide()
    }
    
    func requestSearchMovies(page: Int, language: String, query:String, moviesLoaded: @escaping () -> Void) {
        let newQuery = query.replacingOccurrences(of: " ", with: "+")
        let params = [
            "query" : newQuery,
            "page" : page,
            "language" : language
            ] as [String : Any]
        
        Alamofire.request("\(searchMovieUrl)\(apiKey)", parameters: params).responseArray(queue: nil, keyPath: "results", context: nil) {
            (response: DataResponse<[MoviesVO]>) in
            switch response.result {
            case .success(let result):
                MoviesModel.instance.setMovies(movies: result)
                moviesLoaded()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        SwiftSpinner.hide()
    }
    
    //MARK: serials
    
    func requestPopularSerials(page: Int, language: String, serilasLoaded: @escaping () -> Void) {
        
        let params = [
            "page" : page,
            "language" : language
            ] as [String : Any]
        
        Alamofire.request("\(popularSerialUrl)\(apiKey)", parameters: params).responseArray(queue: nil, keyPath: "results", context: nil) { (response: DataResponse<[SerialsVO]>) in
            switch response.result {
            case .success(let result):
                SerialsModel.instance.setSerials(serials: result)
                serilasLoaded()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        SwiftSpinner.hide()

    }
    
    func requestTopRatedSerials(page: Int, language: String, serialsLoaded: @escaping () -> Void) {
        
        let params = [
            "page" : page,
            "language" : language
            ] as [String : Any]
        
        Alamofire.request("\(topRatedSerialsUrl)\(apiKey)", parameters: params).responseArray(queue: nil, keyPath: "results", context: nil) {
            (response: DataResponse<[SerialsVO]>) in
            switch response.result {
            case .success(let result):
                SerialsModel.instance.setSerials(serials: result)
                serialsLoaded()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        SwiftSpinner.hide()

    }
    
    func requestNowPlayingSerials(page: Int, language: String, serialsLoaded: @escaping () -> Void) {
        
        let params = [
            "page" : page,
            "language" : language
            ] as [String : Any]
        
        Alamofire.request("\(nowPlayingSerialsUrl)\(apiKey)", parameters: params).responseArray(queue: nil, keyPath: "results", context: nil) {
            (response: DataResponse<[SerialsVO]>) in
            switch response.result {
            case .success(let result):
                SerialsModel.instance.setSerials(serials: result)
                serialsLoaded()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        SwiftSpinner.hide()

    }
    
    func requestSearchSerials(page: Int, language: String, query:String, serialsLoaded: @escaping () -> Void) {
        
        let newQuery = query.replacingOccurrences(of: " ", with: "+")
        let params = [
            "query" : newQuery,
            "page" : page,
            "language" : language
            ] as [String : Any]
        
        Alamofire.request("\(searchSerialsUrl)\(apiKey)", parameters: params).responseArray(queue: nil, keyPath: "results", context: nil) {
            (response: DataResponse<[SerialsVO]>) in
            switch response.result {
            case .success(let result):
                SerialsModel.instance.setSerials(serials: result)
                serialsLoaded()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        SwiftSpinner.hide()

    }
 
    
}
