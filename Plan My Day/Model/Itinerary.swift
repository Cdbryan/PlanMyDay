//
//  Itinerary.swift
//  Plan My Day
//
//  Created by Josheta Srinivasan on 1/11/23.
//

import Foundation

struct Itinerary: Identifiable, Hashable, Encodable {
    static func == (lhs: Itinerary, rhs: Itinerary) -> Bool {
        lhs.id == rhs.id;
    }
    
    // Implementing hashValue to conform to the Hashable protocol
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
    init(itineraryName: String, attractions: [Attraction], numberOfDays: Int, tourDuration: [Double], plan: [[Attraction]]){   // should be only initializer we are using!
        self.selectedAttrs = attractions
        itineraryID = 1
        self.itineraryName = itineraryName
        self.numberOfDays = numberOfDays
        self.tourDuration = tourDuration
        self.plan = plan
    }
    
    
    
    init(itineraryName: String, attractions: [Attraction], numberOfDays: Int) {
        self.selectedAttrs = attractions
        itineraryID = 1
        self.itineraryName = itineraryName
        self.numberOfDays = numberOfDays
        tourDuration = []
        plan = [[]]
    }
    
    init(attractions: [Attraction], numberOfDays: Int) { // DO NOT EDIT: josheta is using for her map view page
        self.selectedAttrs = attractions
        itineraryID = 1
        self.itineraryName = "name"
        self.numberOfDays = numberOfDays
        tourDuration = []
        plan = [[]]
    }
    
    init(plan: [[Attraction]]) {
        self.plan = plan
        itineraryID = 1
        self.selectedAttrs = []
        self.numberOfDays = 1
        tourDuration = []
        self.itineraryName = ""
    }
    
    let id = UUID().uuidString
    let itineraryID: Int
    var itineraryName: String
    var selectedAttrs: [Attraction]
    var numberOfDays: Int
    var tourDuration: [Double]
    var plan: [[Attraction]]
    


    
}
