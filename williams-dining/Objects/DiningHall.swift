//
//  DiningHall.swift
//  williams-dining
//
//  Created by Nathan Andersen on 6/29/16.
//  Copyright © 2016 Andersen Labs. All rights reserved.
//

import Foundation

public enum DiningHall {
    case Driscoll
    case Whitmans
    case Mission
    case GrabAndGo
    case EcoCafe
    case Error


    init(num: NSNumber) {
        switch(num) {
        case 27:
            self = .Driscoll
        case 29:
            self = .Mission
        case 38:
            self = .EcoCafe
        case 209:
            self = .GrabAndGo
        case 208:
            self = .Whitmans
        default:
            self = .Error
        }
    }

    func intValue() -> Int {
        return self.getAPIValue()
    }

    static let allCases = [Driscoll,Whitmans,Mission,GrabAndGo,EcoCafe]

    func getAPIValue() -> Int {
        if self == .Driscoll {
            return 27
        } else if self == .Mission {
            return 29
        } else if self == .EcoCafe {
            return 38
        } else if self == .GrabAndGo {
            return 209
        } else if self == .Whitmans {
            return 208
        }
        return 0
    }

    func stringValue() -> String {
        if self == .Driscoll {
            return "Driscoll"
        } else if self == .Mission {
            return "Mission"
        } else if self == .EcoCafe {
            return "Eco Cafe"
        } else if self == .GrabAndGo {
            return "Grab and Go"
        } else if self == .Whitmans {
            return "Whitmans"
        }
        return ""
    }
}
