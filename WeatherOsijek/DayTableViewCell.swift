//
//  DayTableViewCell.swift
//  WeatherOsijek
//
//  Created by COBE Osijek on 19/07/2017.
//  Copyright © 2017 COBE Osijek. All rights reserved.
//

import UIKit

class DayTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherCellImage: UIImageView!
    @IBOutlet weak var weatherCellLabel: UILabel!
    @IBOutlet weak var weatherCellTemp: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
