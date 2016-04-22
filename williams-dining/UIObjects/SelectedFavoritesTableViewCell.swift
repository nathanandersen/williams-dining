//
//  SelectedFavoritesTableViewCell.swift
//  williams-dining
//
//  Created by Nathan Andersen on 1/8/18.
//  Copyright © 2018 Andersen Labs. All rights reserved.
//

import Foundation
import UIKit

class SelectedFavoritesTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var segmentedControl: UISegmentedControl!

    var selectedFavorite: FavoriteFood?


    @IBAction func indexChanged(_ sender: AnyObject) {
        let possibleValues: [DiningHall] = [.Driscoll, .EcoCafe, .GrabAndGo, .Mission, .Whitmans]

        // update selectedFavorite to be associated with that dining hall


    }
}
