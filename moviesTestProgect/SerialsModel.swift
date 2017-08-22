//
//  SerialsModel.swift
//  moviesTestProgect
//
//  Created by Pavlo Kharambura on 8/22/17.
//  Copyright © 2017 Pavlo Kharambura. All rights reserved.
//

import Foundation


class SerialsModel {
    

    private (set) var serials:[SerialsVO] = []
    static var instance: SerialsModel = SerialsModel()
    
    func loadPopularSerials(page: Int, serialsLoaded: @escaping () -> Void) {
        Sender().requestPopularSerials(page: page, language: langStr!, serilasLoaded: serialsLoaded)
    }
    
    func loadTOpRatedSerials(page: Int, serialsLoaded: @escaping () -> Void) {
        Sender().requestTopRatedSerials(page: page, language: langStr!, serialsLoaded: serialsLoaded)
    }
    
    func loadNowPlayingSerials(page: Int, serialsLoaded: @escaping () -> Void) {
        Sender().requestNowPlayingSerials(page: page, language: langStr!, serialsLoaded: serialsLoaded)
    }
    
    func loadSearchingSerials(page: Int, query: String, serialsLoaded: @escaping () -> Void) {
        Sender().requestSearchSerials(page: page, language: langStr!, query: query, serialsLoaded: serialsLoaded)
    }
    
    func setSerials(serials: [SerialsVO]) {
        self.serials += serials
    }
    
}
