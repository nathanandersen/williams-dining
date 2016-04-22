//
//  MenuLoader.swift
//  williams-dining
//
//  Created by Nathan Andersen on 4/30/16.
//  Copyright © 2016 Andersen Labs. All rights reserved.
//

import Foundation
import UIKit

/**
 This class queries the API for the JSON menus, then passes them to Core Data handlers.
 */
class MenuLoader {
    private static let appDelegate = UIApplication.shared.delegate as! AppDelegate

    private static let csvLink: String = "http://dining.williams.edu/files/daily-menu.csv"
    private static let csvURL: URL = URL(string: csvLink)!


    private static func convertCSVToMenuItems(stringData: String) -> [MenuItem] {
        let rows = cleanRows(stringData: stringData)
        if rows.count > 0 {

            return rows.dropFirst().dropLast().map({
                (item: String) -> MenuItem in
                let fields = cleanFields(oldString: item)

                let dhInt = Int(fields[1])
                let dhNum = NSNumber(integerLiteral: dhInt!)


                let dh = DiningHall(num: dhNum)
                let mt = MealTime(mealTime: fields[4])

                let foodString = fields[3].replacingOccurrences(of: "\"", with: "")
                let courseString = fields[2].replacingOccurrences(of: "\"", with: "")

                return MenuItem(foodString: foodString, diningHall: dh, mealTime: mt, course: courseString)
            })

        } else {
            // this is bad
            return []
        }
    }

    private static func cleanFields(oldString:String) -> [String] {
        let delimiter = "\t"
        var newString = oldString.replacingOccurrences(of: "\",\"", with: delimiter)
        newString = newString.replacingOccurrences(of: ",\"", with: delimiter)
        newString = newString.replacingOccurrences(of: "\",", with: delimiter)
        newString = newString.replacingOccurrences(of: "\"", with: "")
        return newString.components(separatedBy: delimiter)
    }

    private static func cleanRows(stringData: String) -> [String] {
        var cleanFile = stringData
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")

        return cleanFile.components(separatedBy: "\n")
    }

    internal static func fetchMenusFromAPI(completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        do {

            MenuHandler.clearCachedData()
            let favoritesNotifier = FavoritesNotifier()

            let s = try String(contentsOf: csvURL)
            let items: [MenuItem] = convertCSVToMenuItems(stringData: s)

            MenuHandler.insertItems(items: items, favoritesNotifier: favoritesNotifier, completionHandler: {
                appDelegate.saveContext()
                favoritesNotifier.sendNotifications()
                completionHandler(.newData)
            })

        } catch {
            self.appDelegate.loadingDataHadError()
        }
    }

    private static func cleanCsv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }

}
