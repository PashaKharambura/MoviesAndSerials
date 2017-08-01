//
//  SecondSearchTableViewCell.swift
//  moviesTestProgect
//
//  Created by Pavlo Kharambura on 8/1/17.
//  Copyright © 2017 Pavlo Kharambura. All rights reserved.
//

import UIKit
import Cosmos

class SecondSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var localizedName: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var ratingStars: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
