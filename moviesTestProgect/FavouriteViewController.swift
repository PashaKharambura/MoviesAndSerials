//
//  FavouriteViewController.swift
//  moviesTestProgect
//
//  Created by Pavlo Kharambura on 8/1/17.
//  Copyright © 2017 Pavlo Kharambura. All rights reserved.
//

import UIKit
import AFNetworking

class FavouriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var favouriteItems: [Movie]?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { // когда создавать а когда оверрайдить переменную
        return .lightContent
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell") as! FavouriteTableViewCell
        let index = indexPath.row
        if favouriteItems?.count != 0 {
            let item = favouriteItems?[index]
            
            if let imageUrl = URL(string: (item?.url)!) {
            cell.titleImage.setImageWith(imageUrl)
            }
            cell.titleLabel.text = item?.title
            cell.localizedName.text = item?.title
            let rating = item?.rating
            cell.rating.text = "\(String(describing: rating!))"
            cell.ratingStars.rating = rating!
            
            return cell
        }
        return cell
    }

    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
    }
    
    func getData() {
        do {
            favouriteItems = try context.fetch(Movie.fetchRequest())
        }
        catch {
            print("Fetching Failed")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = favouriteItems?[indexPath.row]
            context.delete(task!)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                favouriteItems = try context.fetch(Movie.fetchRequest())
            }
            catch {
                print("Fetching Failed")
            }
        }
        tableView.reloadData()
    }
}
