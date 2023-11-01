////
////  Itinerary.swift
////  Plan My Day
////
////  Created by Josheta Srinivasan on 1/11/23.
////
//
//import Foundation
//
//// add itinerary struct
//struct Itinerary: Identifiable, Hashable {
//    static func == (lhs: Itinerary, rhs: Itinerary) -> Bool {
//        lhs.id == rhs.id;
//    }
//    
//    // Implementing hashValue to conform to the Hashable protocol
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//    
//    let id = UUID()
//    let itineraryID: Int
//    var selectedAttrs: [Attraction]
//    var numberOfDays: Int
//    var tourDuration: [Int]
//    var plan: [[Attraction]]
//
//    func updateAttractions(attractions: [Attraction]){
//        self.selectedAttrs = attractions
//    }
//
//    

//    static let ItineraryList  = [
//        [
//            Attraction(attractionId: 1, name: "USC Village", location: "USC", isUSC: true, hours: ["9:00 AM - 5:00 PM"], desc: "village"),
//            Attraction(attractionId: 2, name: "Equad", location: "USC", isUSC: true, hours: ["Open 24 Hours"], desc: "village"),
//            Attraction(attractionId: 3, name: "School of Cinematic Arts", location: "USC", isUSC: true, hours: ["Open 24 Hours"], desc: "village")
//        ],
//        [
//            Attraction(attractionId: 4, name: "LA Memorial Colosseum", location: "USC", isUSC: true, hours: ["Open 24 Hours"], desc: "village"),
//            Attraction(attractionId: 5, name: "Marshall School of Business", location: "USC", isUSC: true, hours: ["Open 24 Hours"], desc: "village"),
//            Attraction(attractionId: 6, name: "Doheny Library", location: "USC", isUSC: true, hours: ["Open 24 Hours"], desc: "village")
//        ]
//    ]

