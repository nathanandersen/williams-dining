//
//  MenuItem.swift
//  williams-dining
//
//  Created by Nathan Andersen on 6/29/16.
//  Copyright © 2016 Andersen Labs. All rights reserved.
//

import Foundation


public struct MenuItem {
    var mealTime: MealTime = .Error
    var name: String = ""
    var diningHall: DiningHall = .Error
    var course: String = ""
    var isVegan: Bool = false
    var isGlutenFree: Bool = false

    let foodNameKey = "formal_name"
    let glutenFreeKey = " GF"
    let veganKey = " V"
    let altVeganKey = " VGT"
    let mealKey = "meal"
    let courseKey = "course"
    let glutenFreeString = "gluten free"


    var foodString: String = ""



    internal func printOut() {
        print([name,course])
//        print([name,course,diningHall,mealTime])
    }


    private mutating func parseIsVegan() {
        let whereVeganKeyWouldBeIndex = foodString.index(foodString.endIndex, offsetBy: -2)
        self.isVegan = (foodString.substring(from: whereVeganKeyWouldBeIndex) == veganKey)
        if isVegan {
            foodString = foodString.substring(to: whereVeganKeyWouldBeIndex)
        } else {
            let whereVeganKeyWouldBeAltIndex = foodString.index(foodString.endIndex, offsetBy: -4)
            self.isVegan = (foodString.substring(from: whereVeganKeyWouldBeAltIndex) == altVeganKey)
            if isVegan {
                self.foodString = foodString.substring(to: whereVeganKeyWouldBeAltIndex)
            }
        }
    }

    private mutating func parseIsGlutenFree() {
        let whereGlutenFreeKeyWouldBeIndex = foodString.index(foodString.endIndex, offsetBy: -3)

        self.isGlutenFree = (foodString.substring(from: whereGlutenFreeKeyWouldBeIndex) == glutenFreeKey)

        if isGlutenFree {
            self.foodString = foodString.substring(to: whereGlutenFreeKeyWouldBeIndex)
        }

        self.isGlutenFree = self.isGlutenFree || foodString.localizedCaseInsensitiveContains(glutenFreeString)
    }


    init(foodString: String, diningHall: DiningHall, mealTime: MealTime, course: String) {
        self.foodString = foodString

        self.diningHall = diningHall
        self.mealTime = mealTime
        self.course = course

        self.parseIsVegan()
        self.parseIsGlutenFree()

        self.name = self.foodString

    }



    init(itemDict: [String:AnyObject], diningHall: DiningHall) {
        self.foodString = itemDict[foodNameKey] as! String

        self.parseIsVegan()
        self.parseIsGlutenFree()

        self.name = foodString

        self.mealTime = MealTime(mealTime: itemDict[mealKey] as! String)
        self.diningHall = diningHall
        self.course = itemDict[courseKey] as! String
    }
}
