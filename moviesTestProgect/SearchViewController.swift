//
//  SearchViewController.swift
//  moviesTestProgect
//
//  Created by Pavlo Kharambura on 8/1/17.
//  Copyright © 2017 Pavlo Kharambura. All rights reserved.
//

import UIKit
import AFNetworking
import SystemConfiguration

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var mySearchBar: UISearchBar!
    @IBOutlet weak var tableView:   UITableView!
    
    fileprivate var pageNumber: Int = 1
    
    var serials: [SerialsVO]?
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
        
        if let posterPath = serial?.posterPath {
            let baseUrl = "http://image.tmdb.org/t/p/w500"
            let imageURL = URL(string: baseUrl + posterPath)
            cell.titleImage.setImageWith(imageURL!)
        }
        
        let rating = "\(String(describing: serial?.voteAverage))/10"
        cell.rating.text = rating
        cell.titleLabel.text = serial?.originalName
        cell.localizedName.text = serial?.originalName
        cell.ratingStars.rating = (serial?.voteAverage)!/2
    
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
                SerialsModel.instance.loadSearchingSerials(page: pageNumber, query: text, serialsLoaded: tableView.reloadData)
                SwiftSpinner.hide()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        SwiftSpinner.show("Loading serials")
        let mySearchString = "\(String(describing: searchBar.text!))"
        searchText = mySearchString
        if let text = searchText {
            SerialsModel.instance.loadSearchingSerials(page: pageNumber, query: text, serialsLoaded: tableView.reloadData)
            SwiftSpinner.hide()
            self.view.endEditing(true)
        }
    }
    
    @IBAction func previousPage(_ sender: UIButton) {
        if pageNumber != 1 {
            pageNumber += -1
            if let text = searchText {
                SerialsModel.instance.loadSearchingSerials(page: pageNumber, query: text, serialsLoaded: tableView.reloadData)
            }
        } else {
            return
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
