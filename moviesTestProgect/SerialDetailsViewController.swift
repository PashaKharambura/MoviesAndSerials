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

class SerialDetailsViewController: UIViewController {
    
    @IBOutlet weak var posterImage:     UIImageView!
    @IBOutlet weak var titleNameLabe:   UILabel!
    @IBOutlet weak var releaseDate:     UILabel!
    @IBOutlet weak var voteAverage:     UILabel!
    @IBOutlet weak var starsView:       CosmosView!
    @IBOutlet weak var descriptionText: UITextView!

    var selectedSerial: NSDictionary!
    var imageUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = selectedSerial["original_name"] as! String
        titleNameLabe.text = title
        descriptionText.text = selectedSerial["overview"] as! String
        releaseDate.text = selectedSerial["first_air_date"] as? String
        voteAverage.text = "\(selectedSerial["vote_average"] as! Double)"
        starsView.rating = selectedSerial?["vote_average"] as! Double
        if let posterPath = selectedSerial["poster_path"] as? String {
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
        task.title = selectedSerial["original_name"] as? String
        task.rating = selectedSerial["vote_average"] as! Double
        task.url = imageUrl
        task.localName = selectedSerial["name"] as? String
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
