//
//  OverviewTableViewCell.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 15-03-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//

import UIKit

class OverviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
        override func prepareForReuse() {
            super.prepareForReuse()
    
            self.adressLabel.text = nil
        }
}
