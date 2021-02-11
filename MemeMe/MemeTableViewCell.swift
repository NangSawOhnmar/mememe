//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by nang saw on 04/01/2021.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var memeLabel: UILabel!
    @IBOutlet weak var memeImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
