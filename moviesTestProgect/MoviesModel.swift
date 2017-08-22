//
//  MoviesModel.swift
//  moviesTestProgect
//
//  Created by Pavlo Kharambura on 8/22/17.
//  Copyright © 2017 Pavlo Kharambura. All rights reserved.
//

import Foundation

class MoviesModel {
    
    private (set) var movies:[MoviesVO] = []
    static var instance: MoviesModel = MoviesModel()
    
    func loadPopularMovies(page: Int, moviesLoaded: @escaping () -> Void) {
        Sender().requestPopularMovies(page: page, language: langStr!, moviesLoaded: moviesLoaded)
    }
    
    func loadTOpRatedMovies(page: Int, moviesLoaded: @escaping () -> Void) {
        Sender().requestTopRatedMovies(page: page, language: langStr!, moviesLoaded: moviesLoaded)
    }
    
    func loadNowPlayingMovies(page: Int, moviesLoaded: @escaping () -> Void) {
        Sender().requestNowPlayingMovies(page: page, language: langStr!, moviesLoaded: moviesLoaded)
    }
    
    func loadSearchingMOvies(page: Int, query: String, moviesLoaded: @escaping () -> Void) {
        Sender().requestSearchMovies(page: page, language: langStr!, query: query, moviesLoaded: moviesLoaded)
    }
    
    func setMovies(movies: [MoviesVO]) {
        self.movies += movies
    }
    
}
