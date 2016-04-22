//
//  ReviewHandler.swift
//  williams-dining
//
//  Created by Nathan Andersen on 7/1/16.
//  Copyright © 2016 Andersen Labs. All rights reserved.
//

import Foundation

let noRating = -1
let httpGet = "GET"
let httpPost = "POST"
let session = URLSession.shared

protocol Form {
    func makeUrlStr() -> URL
}

extension Form {
    func submit() -> () {
        var urlRequest = URLRequest(url: makeUrlStr())
        urlRequest.httpMethod = httpPost

        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            guard error == nil else {
                print(error!)
                print("There was an actual error, seen above ^.")
                //                    completionHandler(true)
                return
            }
            guard (response as! HTTPURLResponse).statusCode == 200 else {
                print("The following status code is no good.")
                print((response as! HTTPURLResponse).statusCode)
                //                    completionHandler(true)
                return
            }

            print(data)
            print(response)
            print(error)
            /*                if let jsonObject: AnyObject = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject? {
             print(jsonObject)
             print("object finished")
             //                    completionHandler(false)
             } else {
             print("Couldn't handle the data...")
             //                    completionHandler(true)
             }*/
        })
        task.resume()
    }
}

func makeUrlParam(header: String, value: String) -> String {
    // Clean the parameters.
    return header.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! + "=" + value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
}

class SuggestionForm: Form {
    func makeUrlStr() -> URL {
        let baseUrl = "https://docs.google.com/forms/d/1kD-o6RNme9cRQIUmEMZBxEp85Lr4NEqYFeYXePtuF2Q/formResponse"
        let suggestionId = "entry.86261122"

        let urlStr = baseUrl + "?" + makeUrlParam(header: suggestionId, value: suggestion)
        print(urlStr)
        return URL(string: urlStr)!
    }

    var suggestion: String
    init(suggestion: String) {
        self.suggestion = suggestion
    }

}

class RatingsForm: Form {
    func makeUrlStr() -> URL {
        let baseUrl = "https://docs.google.com/forms/d/1EIxma2MzaiR9FVTp2-U5lf7cbmfm_2B9TdO5BhTxCJw/formResponse"
        let diningHallId = "entry.780729312"
        let mealTimeId = "entry.1699736037"
        let foodId = "entry.183560090"
        let ratingId = "entry.1195923814"

        let urlStr = baseUrl + "?" + makeUrlParam(header: diningHallId, value: diningHall.stringValue()) +
                                    "&" + makeUrlParam(header: mealTimeId, value: mealTime.stringValue()) +
                                    "&" + makeUrlParam(header: foodId, value: foodName) +
                                    "&" + makeUrlParam(header: ratingId, value: String(rating))
        print(urlStr)
        return URL(string: urlStr)!


    }
    var diningHall: DiningHall
    var mealTime: MealTime
    var foodName: String
    var rating: Int
    init(diningHall: DiningHall, mealTime: MealTime, foodName: String, rating: Int) {
        self.diningHall = diningHall
        self.mealTime = mealTime
        self.foodName = foodName
        self.rating = rating
    }


}



public class ReviewHandler {

    private static let baseUrl = "http://dining.stage.williams.edu/gravityformsapi"
    private static let valueHeaderKey = "input_values"
    private static let diningHallKey = "dining_hall"
    private static let mealTimeKey = "meal_time"
    private static let fieldId = 1
    private static let formId = 20

    private static var ratings: [String:Int] = [String:Int]()

    internal static func addRating(name: String, rating: Int) {
        ratings[name] = rating
    }

    internal static func removeRating(name: String) {
        ratings.removeValue(forKey: name)
    }

    internal static func clearRatings() {
        ratings = [String:Int]()
    }

    internal static func ratingForName(name: String) -> Int {
        if let rating = ratings[name] {
            return rating
        } else {
            return noRating
        }
    }


    internal static func submitReviews(diningHall: DiningHall, mealTime: MealTime, suggestion: String, completion: @escaping (_ userProvidedFeedback: Bool, _ serverError: Bool) -> ()) {

        var isFeedback = false

        if suggestion != suggestionBoxPlaceholder && suggestion != "" {
            // submit a suggestion
            isFeedback = true

            let suggestion = SuggestionForm(suggestion: suggestion)
            suggestion.submit()
        }

        ratings.forEach({
            (food,rating) in
            isFeedback = true
            let rating = RatingsForm(diningHall: diningHall, mealTime: mealTime, foodName: food, rating: rating)
            rating.submit()
            // submit a review for each
        })


        // Todo: Appropriately handle the copmletion
        completion(isFeedback,false)
    }

}
