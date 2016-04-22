//
//  FoodItemViewCell.swift
//  williams-dining
//
//  Created by Nathan Andersen on 4/30/16.
//  Copyright © 2016 Andersen Labs. All rights reserved.
//

import Foundation
import UIKit

class FoodItemViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var veganLabel: UILabel!
    @IBOutlet var glutenFreeLabel: UILabel!

    internal func drawColors() {
        self.veganLabel.backgroundColor = Style.defaultColor
        self.glutenFreeLabel.backgroundColor = Style.defaultColor


        self.veganLabel.textColor = Style.secondaryColor
        self.glutenFreeLabel.textColor = Style.secondaryColor

    }


}
