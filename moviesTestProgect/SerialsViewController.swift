//
//  SecondViewController.swift
//  moviesTestProgect
//
//  Created by Pavlo Kharambura on 7/31/17.
//  Copyright © 2017 Pavlo Kharambura. All rights reserved.
//

import UIKit
import AFNetworking

public let langStr = Locale.current.languageCode

class SerialsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var popularPressed:Bool = true
    fileprivate var topRatedPressed:Bool = true
    fileprivate var nowPlayingPressed:Bool = true
    fileprivate var serialFilter = "popular"
    fileprivate var pageNumber: Int = 1
    var serials: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        SwiftSpinner.show("Loading serials")
        fetchRequest(filter: serialFilter, page: pageNumber)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { // когда создавать а когда оверрайдить переменную
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serials?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SerialCell") as! SerialsTableViewCell
        let index = indexPath.row
        let serial = serials?[index]
            if let posterPath = serial?["poster_path"] as? String {
                let baseUrl = "http://image.tmdb.org/t/p/w500"
                let imageURL = URL(string: baseUrl + posterPath)
                cell.titleImage.setImageWith(imageURL!)
            }
        let rating = "\(String(describing: serial?["vote_average"] as! Double))/10"
        cell.rating.text = rating
        cell.titleLabel.text = serial?["original_name"] as? String
        
        cell.localizedName.text = "(\(serial?["name"] as! String))"
        cell.ratingStars.rating = serial?["vote_average"] as! Double
        return cell
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as UIViewController
        if segue.identifier == "serial" {
            destinationVC.title = "Serial Details"

            let cell = sender as! SerialsTableViewCell
            let indexPath = tableView.indexPath(for: cell)
            
            let serial = serials![indexPath!.row]
            
            let detailsViewController = destinationVC as! SerialDetailsViewController
            detailsViewController.selectedSerial = serial
            
        }
    }
    
    @IBAction func showPopular(_ sender: UIButton) {
        pageNumber = 1
        serialFilter = "popular"
        SwiftSpinner.show("Loading serials")
        fetchRequest(filter: serialFilter, page: pageNumber)
        popularPressed = true
        topRatedPressed = false
        nowPlayingPressed = false
    }
    
    @IBAction func showTopRated(_ sender: UIButton) {
        pageNumber = 1
        serialFilter = "top_rated"
        SwiftSpinner.show("Loading serials")
        fetchRequest(filter: serialFilter, page: pageNumber)
        popularPressed = false
        topRatedPressed = true
        nowPlayingPressed = false
    }
    
    @IBAction func showNowPlaying(_ sender: UIButton) {
        pageNumber = 1
        serialFilter = "airing_today"
        SwiftSpinner.show("Loading serials")
        fetchRequest(filter: serialFilter, page: pageNumber)
        popularPressed = false
        topRatedPressed = false
        nowPlayingPressed = true
    }
    
    @IBAction func nextPage(_ sender: Any) {
        if serials?.count == 20 {
            pageNumber += 1
            SwiftSpinner.show("Loading serials")
            if popularPressed {
                serialFilter = "popular"
            } else if topRatedPressed {
                serialFilter = "top_rated"
            } else {
                serialFilter = "airing_today"
            }
            fetchRequest(filter: serialFilter, page: pageNumber)
        }
    }

    @IBAction func prevPage(_ sender: Any) {
        if pageNumber != 1 {
            pageNumber += -1
            SwiftSpinner.show("Loading serials")
            if popularPressed {
                serialFilter = "popular"
            } else if topRatedPressed {
                serialFilter = "top_rated"
            } else {
                serialFilter = "airing_today"
            }
            fetchRequest(filter: serialFilter, page: pageNumber)
        }
    }
    
    fileprivate func fetchRequest(filter: String, page: Int) {
        
        
        let apiKey = "55580621b06134aae72c3266c0fed8bf"  
        if let url = URL(string:"https://api.themoviedb.org/3/tv/\(filter)?api_key=\(apiKey)&page=\(page)&language=\(langStr!)") {

            let request = URLRequest(url: url)
            
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate:nil, delegateQueue:OperationQueue.main)
            
            let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                        self.serials = responseDictionary["results"] as? [NSDictionary]
                        self.tableView.reloadData()
                        print("\(responseDictionary)")
                        SwiftSpinner.hide()
                    }
                    
                }
            })
            task.resume()
        }
    }
}
