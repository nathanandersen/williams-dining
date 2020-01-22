//
//  MealTime.swift
//  williams-dining
//
//  Created by Nathan Andersen on 6/29/16.
//  Copyright © 2016 Andersen Labs. All rights reserved.
//

import Foundation

let dessertKey = "williams' bakeshop"
let brunchKey = "brunch"
let breakfastKey = "breakfast"
let lunchKey = "lunch"
let dinnerKey = "dinner"
let specialsKey = "specials"

public enum MealTime {
    case Breakfast
    case Lunch
    case Dinner
    case Brunch
    case Dessert
    case Special
    case Error

    init(num: NSNumber) {
        switch(num) {
        case 1:
            self = .Breakfast
        case 2:
            self = .Brunch
        case 3:
            self = .Lunch
        case 4:
            self = .Dinner
        case 5:
            self = .Special
        case 6:
            self = .Dessert
        default:
            self = .Error
        }
    }

    func stringValue() -> String {
        switch(self) {
        case .Breakfast:
            return "Breakfast"
        case .Brunch:
            return "Brunch"
        case .Lunch:
            return "Lunch"
        case .Dinner:
            return "Dinner"
        case .Special:
            return "Specials"
        case .Dessert:
            return "Dessert"
        case .Error:
            return ""
        }
    }

    func intValue() -> Int {
        switch(self) {
        case .Breakfast:
            return 1
        case .Brunch:
            return 2
        case .Lunch:
            return 3
        case .Dinner:
            return 4
        case .Special:
            return 5
        case .Dessert:
            return 6
        case .Error:
            return 10
        }
    }

    static let allCases = [Breakfast,Lunch,Dinner,Special,Brunch,Dessert]

    init(mealTime: String) {
        switch(mealTime.lowercased()) {
        case breakfastKey:
            self = .Breakfast
        case lunchKey:
            self = .Lunch
        case dinnerKey:
            self = .Dinner
        case brunchKey:
            self = .Brunch
        case specialsKey:
            self = .Special
        case dessertKey:
            self = .Dessert
        case _:
            self = .Error
        }
    }
}
