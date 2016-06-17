//
//  GZ_StationTableViewCell.swift
//  Tutu iOS Test
//
//  Created by George Zinyakov on 6/15/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import UIKit

class GZ_StationTableViewCell: UITableViewCell {

    @IBOutlet weak var stationTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureSelfWithData ( title : String )
    {
        stationTitleLabel.text = title
    }
    
    override func prepareForReuse()
    {
        stationTitleLabel.text = ""
    }

}
