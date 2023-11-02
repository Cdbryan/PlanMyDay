//
//  Itinerary.swift
//  Plan My Day
//
//  Created by Josheta Srinivasan on 1/11/23.
//

import Foundation

struct Itinerary: Identifiable, Hashable {
    static func == (lhs: Itinerary, rhs: Itinerary) -> Bool {
        lhs.id == rhs.id;
    }
    
    // Implementing hashValue to conform to the Hashable protocol
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(attractions: [Attraction], numberOfDays: Int) {
        self.selectedAttrs = attractions
        itineraryID = 1
        self.numberOfDays = numberOfDays
        tourDuration = []
        plan = [[]]
    }
    
    
    let id = UUID()
    let itineraryID: Int
    var selectedAttrs: [Attraction]
    var numberOfDays: Int
    var tourDuration: [Int]
    var plan: [[Attraction]]
}
