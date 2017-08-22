//
//  SerialDetailsViewController.swift
//  moviesTestProgect
//
//  Created by Pavlo Kharambura on 7/31/17.
//  Copyright © 2017 Pavlo Kharambura. All rights reserved.
//

import UIKit
import AFNetworking
import Cosmos

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var posterImage:     UIImageView!
    @IBOutlet weak var titleNameLabe:   UILabel!
    @IBOutlet weak var releaseDate:     UILabel!
    @IBOutlet weak var voteAverage:     UILabel!
    @IBOutlet weak var starsView:       CosmosView!
    @IBOutlet weak var descriptionText: UITextView!
    
    var selectedMovie: MoviesVO!
    var imageUrl: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        let title = selectedMovie.originalTitle
        titleNameLabe.text = title
        descriptionText.text = selectedMovie.overview
        releaseDate.text = selectedMovie.releaseDate
        voteAverage.text = "\(selectedMovie.voteAverage ?? 0.0)"
        starsView.rating = (selectedMovie?.voteAverage)!
        if let posterPath = selectedMovie.posterPath {
            let baseUrl = "http://image.tmdb.org/t/p/w500"
                if  let imageURL = URL(string: baseUrl + posterPath) {
                posterImage.setImageWith(imageURL)
                imageUrl = "\(String(describing: imageURL))"
            }
        }
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func addToFavourite(_ sender: UIButton) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let task = Movie(context: context)
        task.title = selectedMovie.originalTitle
        task.rating = selectedMovie.voteAverage!
        task.url = imageUrl
        task.localName = selectedMovie.title
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goBack(_ sender: Any) {
         navigationController?.popViewController(animated: true)
    }
 
}
