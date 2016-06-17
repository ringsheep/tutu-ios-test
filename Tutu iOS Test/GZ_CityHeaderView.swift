//
//  GZ_CityHeaderView.swift
//  Tutu iOS Test
//
//  Created by George Zinyakov on 6/15/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import UIKit

class GZ_CityHeaderView: UIView {

    @IBOutlet weak var cityTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureSelfWithDataModel( title: String )
    {
        cityTitleLabel.text = title
    }

}
