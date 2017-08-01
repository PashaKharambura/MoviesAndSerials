//
//  FirstViewController.swift
//  moviesTestProgect
//
//  Created by Pavlo Kharambura on 7/31/17.
//  Copyright © 2017 Pavlo Kharambura. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var popularPressed:Bool = true
    fileprivate var topRatedPressed:Bool = true
    fileprivate var nowPlayingPressed:Bool = true
    fileprivate var movieFilter = "popular"
    fileprivate var pageNumber: Int = 1
    fileprivate var lastPage: Bool = false
    

    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        SwiftSpinner.show("Loadings movies")
        fetchRequest(filter: movieFilter, page: pageNumber)
    }
 
    override var preferredStatusBarStyle: UIStatusBarStyle { // когда создавать а когда оверрайдить переменную
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MoviesTableViewCell
        let index = indexPath.row
        let movie = movies?[index]
            if let posterPath = movie?["poster_path"] as? String {
                let baseUrl = "http://image.tmdb.org/t/p/w500"
                let imageURL = URL(string: baseUrl + posterPath)
                cell.titleImage.setImageWith(imageURL!)
            }
        cell.titleLabel.text = movie?["original_title"] as? String
        cell.localizedName.text = movie?["title"] as? String
        let rating = "\(String(describing: movie?["vote_average"] as! Double))/10"
        cell.rating.text = rating
        cell.ratingStars.rating = movie?["vote_average"] as! Double
        return cell
    }
    
    fileprivate  func fetchRequest(filter: String, page: Int) {
        
        let apiKey = "55580621b06134aae72c3266c0fed8bf"
        if let url = URL(string:"https://api.themoviedb.org/3/movie/\(filter)?api_key=\(apiKey)&page=\(page)&language=\(langStr!)") {
       
        let request = URLRequest(url: url)
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate:nil, delegateQueue:OperationQueue.main)
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(
                    with: data, options:[]) as? NSDictionary {
                    self.movies = responseDictionary["results"] as? [NSDictionary]
                    self.tableView.reloadData()
                    SwiftSpinner.hide()
                    print("\(responseDictionary)")

                }
            }
        })
        task.resume()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as UIViewController
        if segue.identifier == "movie" {
            destinationVC.title = "Movie Details"
            let cell = sender as! MoviesTableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let movie = movies![indexPath!.row]
            let detailsViewController = destinationVC as! MovieDetailsViewController
            detailsViewController.selectedMovie = movie
            
        }
    }

    @IBAction func showPopular(_ sender: UIButton) {
        SwiftSpinner.show("Loadings movies")
        pageNumber = 1
        movieFilter = "popular"
        fetchRequest(filter: movieFilter, page: pageNumber)
        popularPressed = true
        topRatedPressed = false
        nowPlayingPressed = false
    }
    @IBAction func showTopRated(_ sender: UIButton) {
        SwiftSpinner.show("Loadings movies")
        pageNumber = 1
        movieFilter = "top_rated"
        fetchRequest(filter: movieFilter, page: pageNumber)
        popularPressed = false
        topRatedPressed = true
        nowPlayingPressed = false
    }
    @IBAction func showNowPlaying(_ sender: UIButton) {
        SwiftSpinner.show("Loadings movies")
        pageNumber = 1
        movieFilter = "now_playing"
        fetchRequest(filter: movieFilter, page: pageNumber)
        popularPressed = false
        topRatedPressed = false
        nowPlayingPressed = true
    }
    
    @IBAction func nextPage(_ sender: Any) {
        if movies?.count == 20 {
            pageNumber += 1
            SwiftSpinner.show("Loading serials")
            if popularPressed {
                movieFilter = "popular"
            } else if topRatedPressed {
                movieFilter = "top_rated"
            } else {
                movieFilter = "now_playing"
            }
            fetchRequest(filter: movieFilter, page: pageNumber)
        }
    }
    
    @IBAction func prevPage(_ sender: Any) {
        if pageNumber != 1 {
            pageNumber += -1
            SwiftSpinner.show("Loading serials")
            if popularPressed {
                movieFilter = "popular"
            } else if topRatedPressed {
                movieFilter = "top_rated"
            } else {
                movieFilter = "now_playing"
            }
            fetchRequest(filter: movieFilter, page: pageNumber)
        }
    }
    
}

