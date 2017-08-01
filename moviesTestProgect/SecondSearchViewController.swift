//
//  SecondSearchViewController.swift
//  moviesTestProgect
//
//  Created by Pavlo Kharambura on 8/1/17.
//  Copyright © 2017 Pavlo Kharambura. All rights reserved.
//

import UIKit
import AFNetworking

class SecondSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var mySearchBar: UISearchBar!
    @IBOutlet weak var tableView:   UITableView!
    
    fileprivate var pageNumber: Int = 1
    
    var movies: [NSDictionary]?
    var searchText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        mySearchBar.delegate = self
        mySearchBar.returnKeyType = UIReturnKeyType.done
        mySearchBar.becomeFirstResponder()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { 
        return .lightContent
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieSearchCell") as! SecondSearchTableViewCell
        let index = indexPath.row
        let movie = movies?[index]
        
        if let posterPath = movie?["poster_path"] as? String {
            let baseUrl = "http://image.tmdb.org/t/p/w500"
            let imageURL = URL(string: baseUrl + posterPath)
            cell.titleImage.setImageWith(imageURL!)
        }
        
        let rating = "\(String(describing: movie?["vote_average"] as! Double))/10"
        cell.rating.text = rating
        cell.titleLabel.text = movie?["original_title"] as? String
        cell.localizedName.text = movie?["original_title"] as? String
        cell.ratingStars.rating = (movie?["vote_average"] as! Double)/2
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as UIViewController
        if segue.identifier == "movieSearch" {
            let cell = sender as! SecondSearchTableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let movie = movies![indexPath!.row]
            let detailsViewController = destinationVC as! MovieDetailsViewController
            detailsViewController.selectedMovie = movie
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        SwiftSpinner.show("Loading films")
        let mySearchString = "\(String(describing: searchBar.text!))"
        searchText = mySearchString
        fetchRequest(query: mySearchString, page: pageNumber)
        print("searchText \(mySearchString)")
        self.view.endEditing(true)
    }
    
    @IBAction func nextPage(_ sender: Any) {
        if movies?.count == 20 {
            pageNumber += 1
            SwiftSpinner.show("Loading movies")
            if let text = searchText {
                fetchRequest(query: text, page: pageNumber)
            }
        }
    }
    
    @IBAction func previousPage(_ sender: UIButton) {
        if pageNumber != 1 {
            pageNumber += -1
            if let text = searchText {
                fetchRequest(query: text, page: pageNumber)
            }
        } else {
            return
        }
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func fetchRequest(query:String, page: Int) {
        
        let newQuery = query.replacingOccurrences(of: " ", with: "+")
        let apiKey = "55580621b06134aae72c3266c0fed8bf"
        
        if let url = URL(string:"https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(newQuery)&page=\(page)&language=\(langStr!)") {
 
            let request = URLRequest(url: url)
            
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate:nil, delegateQueue:OperationQueue.main)
            
            let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                        self.movies = responseDictionary["results"] as? [NSDictionary]
                        print("\(responseDictionary)")

                        self.tableView.reloadData()
                        SwiftSpinner.hide()
                    }
                }
            })
        task.resume()
        }
    }
    
}
