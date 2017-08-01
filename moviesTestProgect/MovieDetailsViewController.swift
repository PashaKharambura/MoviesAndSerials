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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let title = selectedMovie["original_title"] as! String
        titleNameLabe.text = title

//        let details = selectedMovie["overview"] as! String
//        detailsLabel.text = details

        
        if let posterPath = selectedMovie["poster_path"] as? String {
            let baseUrl = "http://image.tmdb.org/t/p/w500"
            let imageURL = URL(string: baseUrl + posterPath)
            posterImage.setImageWith(imageURL!)
        }
    }

    @IBAction func goBack(_ sender: Any) {
         navigationController?.popViewController(animated: true)
    }
 
}
