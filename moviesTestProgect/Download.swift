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
public let langStr = Locale.current.languageCode


class Sender {

    func requestPopularMovies(page: Int, language: String, moviesLoaded: @escaping () -> Void) {
       
        let params = [
            "page" : page,
            "language" : language
        ] as [String : Any]
        
        Alamofire.request("https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)", parameters: params).responseArray {
            (response: DataResponse<[MoviesVO]>) in
            switch response.result {
            case .success(let result):
                MoviesModel.instance.setMovies(movies: result)
                moviesLoaded()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func requestTopRatedMovies(page: Int, language: String, moviesLoaded: @escaping () -> Void) {
        
        let params = [
            "page" : page,
            "language" : language
            ] as [String : Any]
        
        Alamofire.request("https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)", parameters: params).responseArray {
            (response: DataResponse<[MoviesVO]>) in
            switch response.result {
            case .success(let result):
                MoviesModel.instance.setMovies(movies: result)
                moviesLoaded()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func requestNowPlayingMovies(page: Int, language: String, moviesLoaded: @escaping () -> Void) {
        
        let params = [
            "page" : page,
            "language" : language
            ] as [String : Any]
        
        Alamofire.request("https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)", parameters: params).responseArray {
            (response: DataResponse<[MoviesVO]>) in
            switch response.result {
            case .success(let result):
                MoviesModel.instance.setMovies(movies: result)
                moviesLoaded()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func requestSearchMovies(page: Int, language: String, query:String, moviesLoaded: @escaping () -> Void) {
        let newQuery = query.replacingOccurrences(of: " ", with: "+")
        let params = [
            "query" : newQuery,
            "page" : page,
            "language" : language
            ] as [String : Any]
        
        Alamofire.request("https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)", parameters: params).responseArray {
            (response: DataResponse<[MoviesVO]>) in
            switch response.result {
            case .success(let result):
                MoviesModel.instance.setMovies(movies: result)
                moviesLoaded()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    //MARK: serials
    
    func requestPopularSerials(page: Int, language: String, serilasLoaded: @escaping () -> Void) {
        
        let params = [
            "page" : page,
            "language" : language
            ] as [String : Any]
        
        Alamofire.request("https://api.themoviedb.org/3/tv/popular?api_key=\(apiKey)", parameters: params).responseArray(queue: nil, keyPath: "results", context: nil) { (response: DataResponse<[SerialsVO]>) in
            switch response.result {
            case .success(let result):
                print(result)
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
        
        Alamofire.request("https://api.themoviedb.org/3/tv/top_rated?api_key=\(apiKey)", parameters: params).responseArray(queue: nil, keyPath: "results", context: nil) {
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
        
        Alamofire.request("https://api.themoviedb.org/3/tv/airing_today?api_key=\(apiKey)", parameters: params).responseArray(queue: nil, keyPath: "results", context: nil) {
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
        
        Alamofire.request("https://api.themoviedb.org/3/search/tv?api_key=\(apiKey)", parameters: params).responseArray(queue: nil, keyPath: "results", context: nil) {
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
