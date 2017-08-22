//
//  FirstViewController.swift
//  moviesTestProgect
//
//  Created by Pavlo Kharambura on 7/31/17.
//  Copyright © 2017 Pavlo Kharambura. All rights reserved.
//

import UIKit
import AFNetworking
import SystemConfiguration

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var popularButton: UIButton!
    @IBOutlet weak var topRatedBitton: UIButton!
    @IBOutlet weak var nowPlaying: UIButton!
    
    fileprivate var popularPressed:Bool     = true
    fileprivate var topRatedPressed:Bool    = true
    fileprivate var nowPlayingPressed:Bool  = true
    fileprivate var movieFilter             = "popular"
    fileprivate var pageNumber: Int         = 1
    fileprivate var lastPage: Bool          = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        SwiftSpinner.show("Loadings movies")
        MoviesModel.instance.loadPopularMovies(page: pageNumber, moviesLoaded: tableView.reloadData)
        popularButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        
    }
 
    override var preferredStatusBarStyle: UIStatusBarStyle { 
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MoviesModel.instance.movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MoviesTableViewCell
        let index = indexPath.row
        let movie = MoviesModel.instance.movies?[index]
        
        if let posterPath = movie?.posterPath {
            let baseUrl = "http://image.tmdb.org/t/p/w500"
            let imageURL = URL(string: baseUrl + posterPath)
            cell.titleImage.setImageWith(imageURL!)
        }
        
        let rating = "\(movie?.voteAverage ?? 0.0)/10"
        cell.rating.text = rating
        cell.titleLabel.text = movie?.originalTitle
        cell.localizedName.text = movie?.title
        cell.ratingStars.rating = (movie?.voteAverage)!/2
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as UIViewController
        if segue.identifier == "movie" {
            let cell = sender as! MoviesTableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let movie = MoviesModel.instance.movies![indexPath!.row]
            let detailsViewController = destinationVC as! MovieDetailsViewController
            detailsViewController.selectedMovie = movie
        }
    }

    @IBAction func showPopular(_ sender: UIButton) {
        SwiftSpinner.show("Loadings movies")
        popularButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        topRatedBitton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        nowPlaying.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        
        pageNumber = 1
        
        MoviesModel.instance.loadPopularMovies(page: pageNumber, moviesLoaded: tableView.reloadData)
        
        popularPressed = true
        topRatedPressed = false
        nowPlayingPressed = false
    }
    
    @IBAction func showTopRated(_ sender: UIButton) {
        popularButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        topRatedBitton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        nowPlaying.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        SwiftSpinner.show("Loadings movies")
        
        pageNumber = 1
        MoviesModel.instance.loadTOpRatedMovies(page: pageNumber, moviesLoaded: tableView.reloadData)
        
        popularPressed = false
        topRatedPressed = true
        nowPlayingPressed = false
    }
    
    @IBAction func showNowPlaying(_ sender: UIButton) {
        popularButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        topRatedBitton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        nowPlaying.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        SwiftSpinner.show("Loadings movies")
        
        pageNumber = 1
        MoviesModel.instance.loadNowPlayingMovies(page: pageNumber, moviesLoaded: tableView.reloadData)
        
        popularPressed = false
        topRatedPressed = false
        nowPlayingPressed = true
    }
    
    @IBAction func nextPage(_ sender: Any) {
        if MoviesModel.instance.movies?.count == 20 {
            pageNumber += 1
            SwiftSpinner.show("Loading serials")
            if popularPressed {
                MoviesModel.instance.loadPopularMovies(page: pageNumber, moviesLoaded: tableView.reloadData)
            } else if topRatedPressed {
                MoviesModel.instance.loadTOpRatedMovies(page: pageNumber, moviesLoaded: tableView.reloadData)
            } else {
                MoviesModel.instance.loadNowPlayingMovies(page: pageNumber, moviesLoaded: tableView.reloadData)
            }
        }
    }
    
    @IBAction func prevPage(_ sender: Any) {
        if pageNumber != 1 {
            pageNumber += -1
            SwiftSpinner.show("Loading serials")
            if popularPressed {
                MoviesModel.instance.loadPopularMovies(page: pageNumber, moviesLoaded: tableView.reloadData)
            } else if topRatedPressed {
                MoviesModel.instance.loadTOpRatedMovies(page: pageNumber, moviesLoaded: tableView.reloadData)
            } else {
                MoviesModel.instance.loadNowPlayingMovies(page: pageNumber, moviesLoaded: tableView.reloadData)
            }
        }
    }
    
}

