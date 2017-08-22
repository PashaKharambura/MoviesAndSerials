//
//  SecondSearchViewController.swift
//  moviesTestProgect
//
//  Created by Pavlo Kharambura on 8/1/17.
//  Copyright © 2017 Pavlo Kharambura. All rights reserved.
//

import UIKit
import AFNetworking
import SystemConfiguration

class SecondSearchViewController: MyViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var mySearchBar: UISearchBar!
    @IBOutlet weak var tableView:   UITableView!
    
    fileprivate var pageNumber = 1
    
    var searchText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MoviesModel.instance.setMovies(movies: [])

        tableView.dataSource = self
        tableView.delegate = self
        mySearchBar.delegate = self
        mySearchBar.returnKeyType = UIReturnKeyType.done
        mySearchBar.becomeFirstResponder()
        
        if Reachability.isConnectedToNetwork() == false {
            AlertDialog.showAlert("Error", message: "Check your internet connection", viewController: self)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MoviesModel.instance.movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieSearchCell") as! SecondSearchTableViewCell
        let index = indexPath.row
        let movie = MoviesModel.instance.movies?[index]
        
        if let posterPath = movie?.posterPath {
            let baseUrl = "http://image.tmdb.org/t/p/w500"
            let imageURL = URL(string: baseUrl + posterPath)
            cell.titleImage.setImageWith(imageURL!)
        }
        
        let rating = "\( movie?.voteAverage ?? 0.0)/10"
        cell.rating.text = rating
        cell.titleLabel.text = movie?.originalTitle
        cell.localizedName.text = movie?.originalTitle
        cell.ratingStars.rating = (movie?.voteAverage)!/2
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as UIViewController
        if segue.identifier == "movieSearch" {
            let cell = sender as! SecondSearchTableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let movie = MoviesModel.instance.movies![indexPath!.row]
            let detailsViewController = destinationVC as! MovieDetailsViewController
            detailsViewController.selectedMovie = movie
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        SwiftSpinner.show("Loading films")
        let mySearchString = "\(String(describing: searchBar.text!))"
        searchText = mySearchString
        if let text = searchText {
            MoviesModel.instance.loadSearchingMOvies(page: pageNumber, query: text , moviesLoaded: tableView.reloadData)
            self.view.endEditing(true)
        }
    }
    
    @IBAction func nextPage(_ sender: Any) {
        if MoviesModel.instance.movies?.count == 20 {
            pageNumber += 1
            SwiftSpinner.show("Loading movies")
            if let text = searchText {
                MoviesModel.instance.loadSearchingMOvies(page: pageNumber, query: text, moviesLoaded: tableView.reloadData)
            }
        }
    }
    
    @IBAction func previousPage(_ sender: UIButton) {
        if pageNumber != 1 {
            pageNumber += -1
            if let text = searchText {
                MoviesModel.instance.loadSearchingMOvies(page: pageNumber, query: text, moviesLoaded: tableView.reloadData)
            }
        } else {
            return
        }
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
