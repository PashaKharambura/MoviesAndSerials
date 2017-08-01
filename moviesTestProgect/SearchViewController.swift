//
//  SearchViewController.swift
//  moviesTestProgect
//
//  Created by Pavlo Kharambura on 8/1/17.
//  Copyright © 2017 Pavlo Kharambura. All rights reserved.
//

import UIKit
import AFNetworking

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var mySearchBar: UISearchBar!
    @IBOutlet weak var tableView:   UITableView!
    
    fileprivate var pageNumber: Int = 1
    
    var serials: [NSDictionary]?
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
        return serials?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! SearchTableViewCell
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
        cell.localizedName.text = serial?["original_name"] as? String
        cell.ratingStars.rating = (serial?["vote_average"] as! Double)/2
    
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as UIViewController
        if segue.identifier == "searchSegue" {
            let cell = sender as! SearchTableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let serial = serials![indexPath!.row]
            let detailsViewController = destinationVC as! SerialDetailsViewController
            detailsViewController.selectedSerial = serial
        }
    }
    
    @IBAction func nextPage(_ sender: Any) {
        if serials?.count == 20 {
            pageNumber += 1
            SwiftSpinner.show("Loading serials")
            if let text = searchText {
                fetchRequest(query: text, page: pageNumber)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        SwiftSpinner.show("Loading serials")
        let mySearchString = "\(String(describing: searchBar.text!))"
        searchText = mySearchString
        fetchRequest(query: mySearchString, page: pageNumber)
        print("searchText \(mySearchString)")
        self.view.endEditing(true)
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
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func fetchRequest(query:String, page: Int) {

        let newQuery = query.replacingOccurrences(of: " ", with: "+")
        let apiKey = "55580621b06134aae72c3266c0fed8bf"
        if let url = URL(string:"https://api.themoviedb.org/3/search/tv?api_key=\(apiKey)&query=\(newQuery)&page=\(page)&language=\(langStr!)") {
       
            let request = URLRequest(url: url)
            
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate:nil, delegateQueue:OperationQueue.main)
            
            let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                        self.serials = responseDictionary["results"] as? [NSDictionary]
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
