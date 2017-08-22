//
//  SecondViewController.swift
//  moviesTestProgect
//
//  Created by Pavlo Kharambura on 7/31/17.
//  Copyright © 2017 Pavlo Kharambura. All rights reserved.
//

import UIKit
import AFNetworking
import SystemConfiguration


class SerialsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var popularButton: UIButton!
    @IBOutlet weak var topRatedBitton: UIButton!
    @IBOutlet weak var nowPlaying: UIButton!
    
    fileprivate var popularPressed:Bool     = true
    fileprivate var topRatedPressed:Bool    = true
    fileprivate var nowPlayingPressed:Bool  = true
    fileprivate var serialFilter            = "popular"
    fileprivate var pageNumber: Int         = 1
    
    var serials: [SerialsVO]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        SwiftSpinner.show("Loading serials")
        SerialsModel.instance.loadPopularSerials(page: pageNumber, serialsLoaded: tableView.reloadData)
        SwiftSpinner.hide()
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
        return serials?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SerialCell") as! SerialsTableViewCell
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
        cell.localizedName.text = "(\(String(describing: serial?.name)))"
        cell.ratingStars.rating = (serial?.voteAverage)!/2
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as UIViewController
        if segue.identifier == "serial" {
            let cell = sender as! SerialsTableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let serial = serials![indexPath!.row]
            let detailsViewController = destinationVC as! SerialDetailsViewController
            detailsViewController.selectedSerial = serial
        }
    }
    
    @IBAction func showPopular(_ sender: UIButton) {
        pageNumber = 1
        
        popularButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        topRatedBitton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        nowPlaying.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        
        SwiftSpinner.show("Loading serials")
        SerialsModel.instance.loadPopularSerials(page: pageNumber, serialsLoaded: tableView.reloadData)
        SwiftSpinner.hide()
        
        popularPressed = true
        topRatedPressed = false
        nowPlayingPressed = false
    }
    
    @IBAction func showTopRated(_ sender: UIButton) {
        pageNumber = 1

        popularButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        topRatedBitton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        nowPlaying.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        
        SwiftSpinner.show("Loading serials")
        SerialsModel.instance.loadTOpRatedSerials(page: pageNumber, serialsLoaded: tableView.reloadData)
        SwiftSpinner.hide()
        
        popularPressed = false
        topRatedPressed = true
        nowPlayingPressed = false
    }
    
    @IBAction func showNowPlaying(_ sender: UIButton) {
        pageNumber = 1

        popularButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        topRatedBitton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        nowPlaying.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        
        SwiftSpinner.show("Loading serials")
        SerialsModel.instance.loadNowPlayingSerials(page: pageNumber, serialsLoaded: tableView.reloadData)
        SwiftSpinner.hide()

        popularPressed = false
        topRatedPressed = false
        nowPlayingPressed = true
    }
    
    @IBAction func nextPage(_ sender: Any) {
        if serials?.count == 20 {
            pageNumber += 1
            SwiftSpinner.show("Loading serials")
            if popularPressed {
                SerialsModel.instance.loadPopularSerials(page: pageNumber, serialsLoaded: tableView.reloadData)
            } else if topRatedPressed {
                SerialsModel.instance.loadTOpRatedSerials(page: pageNumber, serialsLoaded: tableView.reloadData)
            } else {
                SerialsModel.instance.loadNowPlayingSerials(page: pageNumber, serialsLoaded: tableView.reloadData)

            }
        }
    }

    @IBAction func prevPage(_ sender: Any) {
        if pageNumber != 1 {
            pageNumber += -1
            SwiftSpinner.show("Loading serials")
            if popularPressed {
                serialFilter = "popular"
                SerialsModel.instance.loadPopularSerials(page: pageNumber, serialsLoaded: tableView.reloadData)

            } else if topRatedPressed {
                serialFilter = "top_rated"
                SerialsModel.instance.loadTOpRatedSerials(page: pageNumber, serialsLoaded: tableView.reloadData)

            } else {
                serialFilter = "airing_today"
                SerialsModel.instance.loadNowPlayingSerials(page: pageNumber, serialsLoaded: tableView.reloadData)

            }
        }
    }
}
