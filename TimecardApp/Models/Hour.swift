//
//  Hour.swift
//  TimecardApp
//
//  Created by Damian Rozycki on 11/14/24.
//

//comment for anastasia
enum Hour: Int, CaseIterable, Identifiable {
    case h12am = 0, h1am, h2am, h3am, h4am, h5am, h6am, h7am, h8am, h9am, h10am, h11am
    case h12pm = 12, h1pm, h2pm, h3pm, h4pm, h5pm, h6pm, h7pm, h8pm, h9pm, h10pm, h11pm
    
    var id: Int { self.rawValue }
    
    var display: String {
        let hour = rawValue % 12 == 0 ? 12 : rawValue % 12
        let ampm = rawValue < 12 ? "AM" : "PM"
        return "\(hour):00 \(ampm)"
    }
}
