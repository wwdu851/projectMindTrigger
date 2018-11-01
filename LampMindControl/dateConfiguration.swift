//
//  dateConfiguration.swift
//  LampMindControl
//
//  Created by William Du on 07/12/2016.
//  Copyright © 2016 William Du. All rights reserved.
//

import Foundation

struct dateConfiguration {
    func config(date:Date) -> Date{
        let now = Date()
        let calendar = Calendar(identifier: .gregorian)
        var dateFinished = Date()
        let secondPrecision = (calendar as NSCalendar).date(bySettingUnit: .second, value: 0, of: date, options: .matchStrictly)!
        print(now)
        if date.compare(now) == .orderedAscending{
            dateFinished = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 1, to: secondPrecision, options: NSCalendar.Options.matchStrictly)!.addingTimeInterval(-60)
        }else{
           dateFinished = secondPrecision.addingTimeInterval(-60)
        }
        
        
        return dateFinished
    }
}

