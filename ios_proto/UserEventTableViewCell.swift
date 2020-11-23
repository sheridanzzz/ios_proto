//
//  UserEventTableViewCell.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 23/11/20.
//

import UIKit

class UserEventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var eventNameLabel: UILabel!
    
    
    @IBOutlet weak var sportNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
