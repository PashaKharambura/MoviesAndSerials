//
//  SerialDetailsViewController.swift
//  moviesTestProgect
//
//  Created by Pavlo Kharambura on 7/31/17.
//  Copyright © 2017 Pavlo Kharambura. All rights reserved.
//

import UIKit
import AFNetworking


class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleNameLabe: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!

    
    var selectedMovie: NSDictionary!
    var imageUrl: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        let title = selectedMovie["original_title"] as! String
        titleNameLabe.text = title

//        let details = selectedMovie["overview"] as! String
//        detailsLabel.text = details

        
        if let posterPath = selectedMovie["poster_path"] as? String {
            let baseUrl = "http://image.tmdb.org/t/p/w500"
                if  let imageURL = URL(string: baseUrl + posterPath) {
                posterImage.setImageWith(imageURL)
                imageUrl = "\(String(describing: imageURL))"
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { // когда создавать а когда оверрайдить переменную
        return .lightContent
    }
    
    @IBAction func addToFavourite(_ sender: UIButton) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let task = Movie(context: context)
        task.title = selectedMovie["original_title"] as? String
        task.rating = selectedMovie["vote_average"] as! Double
        task.url = imageUrl
        task.localName = selectedMovie["title"] as? String
        
        // Save the data to coredata
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goBack(_ sender: Any) {
         navigationController?.popViewController(animated: true)
    }
 
}
