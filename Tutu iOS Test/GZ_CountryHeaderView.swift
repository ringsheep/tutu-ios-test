//
//  GZ_CountryHeaderView.swift
//  Tutu iOS Test
//
//  Created by George Zinyakov on 6/15/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import UIKit

class GZ_CountryHeaderView: UIView {

    @IBOutlet weak var countryTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureSelfWithDataModel( title: String )
    {
        countryTitleLabel.text = title
    }

}
