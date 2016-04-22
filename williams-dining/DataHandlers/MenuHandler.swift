//
//  MenuReade
//  williams-dining
//
//  Created by Nathan Andersen on 4/28/16.
//  Copyright © 2016 Andersen Labs. All rights reserved.
//

import Foundation
import CoreData
import UIKit

/**
MenuReader statically reads the menus in from Core Data memory.
 */
public class MenuHandler: MenuHandlerProtocol {

    private static let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext

    private static let courseKey = "course"
    private static let mealTimeKey = "mealTime"
    private static let diningHallKey = "diningHall"
    private static let valueForKeyMatchesParameter = "%K == %@"

    public static func fetchByMealTimeAndDiningHall(mealTime: MealTime, diningHall: DiningHall) -> [CoreDataMenuItem] {
        return fetchByMealTimeAndDiningHall(mealTime: mealTime, diningHall: diningHall, moc: self.managedObjectContext)
    }

    public static func fetchByMealTimeAndDiningHall(mealTime: MealTime, diningHall: DiningHall, moc: NSManagedObjectContext) -> [CoreDataMenuItem] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataMenuItem")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: courseKey, ascending: true)]

        let diningHallPredicate = NSPredicate(format: valueForKeyMatchesParameter, diningHallKey, NSNumber(value: diningHall.intValue()))
        let mealTimePredicate = NSPredicate(format: valueForKeyMatchesParameter, mealTimeKey, NSNumber(value: mealTime.intValue()))

        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [diningHallPredicate,mealTimePredicate])

        if let fetchResults = try? moc.fetch(fetchRequest) as? [CoreDataMenuItem] {
            return fetchResults!.sorted(by: {(a,b) in
                if a.course == "Entrees" && b.course == "Entrees" {
                    return (a.name < b.name)
                } else if a.course == "Entrees" {
                    return true
                } else if b.course == "Entrees" {
                    return false
                } else {
                    return a.name < b.name
                }
            })
        }
        return []
    }

    public static func fetchDiningHalls(mealTime: MealTime?) -> [DiningHall] {
        return fetchDiningHalls(mealTime: mealTime, moc: self.managedObjectContext)
    }

    public static func fetchDiningHalls(mealTime: MealTime?, moc: NSManagedObjectContext) -> [DiningHall] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataMenuItem")
        if mealTime != nil {
            fetchRequest.predicate = NSPredicate(format: valueForKeyMatchesParameter, mealTimeKey, NSNumber(value: mealTime!.intValue()))
        }
        fetchRequest.propertiesToFetch = [diningHallKey]
        fetchRequest.returnsDistinctResults = true
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType

        if let fetchResults = try? moc.fetch(fetchRequest) as? [[String:Int]] {
            return fetchResults!.map({
                DiningHall(num: NSNumber(integerLiteral: $0[diningHallKey]!))
            }).sorted(by: {$0.stringValue() < $1.stringValue()})
        }
        return []
    }

    public static func fetchMealTimes(diningHall: DiningHall?) -> [MealTime] {
        return fetchMealTimes(diningHall: diningHall, moc: self.managedObjectContext)
    }

    public static func fetchMealTimes(diningHall: DiningHall?, moc: NSManagedObjectContext) -> [MealTime] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataMenuItem")
        if diningHall != nil {
            fetchRequest.predicate = NSPredicate(format: valueForKeyMatchesParameter, diningHallKey, NSNumber(integerLiteral: diningHall!.intValue()))
        }
        fetchRequest.propertiesToFetch = [mealTimeKey]
        fetchRequest.returnsDistinctResults = true
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType

        if let fetchResults = try? moc.fetch(fetchRequest) as? [[String:Int]] {
            return fetchResults!.map({
                MealTime(num: NSNumber(integerLiteral: $0[mealTimeKey]!))
            }).sorted(by: {$0.intValue() < $1.intValue()})
        }
        return []
    }

    /**
     Clears the data stored in CoreData for new menu-space.
     */
    internal static func clearCachedData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataMenuItem")
        fetchRequest.includesPropertyValues = false
        if let fetchResults = try? managedObjectContext.fetch(fetchRequest) as? [CoreDataMenuItem] {
            for item in fetchResults! {
                managedObjectContext.delete(item)
            }
        }
        do {
            try managedObjectContext.save()
        } catch {
            print("While clearing the menus, the save failed")
        }
    }

    internal static func insertItems(items: [MenuItem], favoritesNotifier: FavoritesNotifier, completionHandler: () -> ()) {
        print("Trying to insert items")
        let insertIntoMOC: (MenuItem) -> () = {
            (item: MenuItem) in
            item.printOut()

            _ = CoreDataMenuItem.createInManagedObjectContext(moc: self.managedObjectContext, menuItem: item)
            if FavoritesHandler.isAFavoriteFood(name: item.name) {
                favoritesNotifier.addToFavoritesList(item: item)
            }
        }
        items.forEach(insertIntoMOC)
        print("Inserted all items")
        completionHandler()
    }
}
