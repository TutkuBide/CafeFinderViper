//
//  CafeListCell.swift
//  ViperSample
//
//  Created by tutkubide on 25.10.2020.
//

import UIKit

class CafeListCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config( models: VenuesModel ) {
         
         nameLabel.text = models.name
         adressLabel.text = models.adress
         cityLabel.text = models.city
         countryLabel.text = models.country
         
     }

}
