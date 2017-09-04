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

class SerialDetailsViewController: MyViewController {
    
    @IBOutlet weak var posterImage:     UIImageView!
    @IBOutlet weak var titleNameLabe:   UILabel!
    @IBOutlet weak var releaseDate:     UILabel!
    @IBOutlet weak var voteAverage:     UILabel!
    @IBOutlet weak var starsView:       CosmosView!
    @IBOutlet weak var descriptionText: UITextView!

    var selectedSerial: SerialsVO!
    var imageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = selectedSerial.originalName
        titleNameLabe.text = title
        descriptionText.text = selectedSerial.overview
        releaseDate.text = selectedSerial.firstAirDate
        voteAverage.text = "\(selectedSerial.voteAverage ?? 0.0)"
        starsView.rating = (selectedSerial?.voteAverage)!
        if let posterPath = selectedSerial.posterPath{
            let baseUrl = "http://image.tmdb.org/t/p/w500"
            if  let imageURL = URL(string: baseUrl + posterPath) {
                posterImage.setImageWith(imageURL)
                imageUrl = "\(String(describing: imageURL))"
            }
        }
    }
    
    @IBAction func addToFavourite(_ sender: UIButton) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let task = Movie(context: context)
        task.title = selectedSerial.originalName
        task.rating = selectedSerial.voteAverage!
        task.url = imageUrl
        task.localName = selectedSerial.name
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
