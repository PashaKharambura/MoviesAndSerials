//
//  SerialDetailsViewController.swift
//  moviesTestProgect
//
//  Created by Pavlo Kharambura on 7/31/17.
//  Copyright © 2017 Pavlo Kharambura. All rights reserved.
//

import UIKit
import AFNetworking


class SerialDetailsViewController: UIViewController {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleNameLabe: UILabel!
    @IBOutlet weak var detailsText: UITextView!

    var selectedSerial: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = selectedSerial["original_name"] as! String
        titleNameLabe.text = name
        
//        let details = selectedSerial["overview"] as! String
//        
//        detailsText.text = details
        
        if let posterPath = selectedSerial["poster_path"] as? String {
            let baseUrl = "http://image.tmdb.org/t/p/w500"
            let imageURL = URL(string: baseUrl + posterPath)
            posterImage.setImageWith(imageURL!)
        }
    }

    @IBAction func addToFavourite(_ sender: UIButton) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let task = Movie(context: context)
        task.title = selectedSerial["original_name"] as? String
        task.rating = selectedSerial["vote_average"] as! Double
        
        task.localName = selectedSerial["name"] as? String
        
        // Save the data to coredata
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
