//
//  Attraction.swift
//  Plan My Day
//
//  Created by Josheta Srinivasan on 1/11/23.
//

import Foundation

struct Attraction: Identifiable {
    let id = UUID()
    let attractionId: Int
    let name: String
    let location: String
    let isUSC: Bool
    let lat: Double
    let long: Double
    var hours: [String]
    var desc: String
    
    
    static let attractionList = [
        Attraction(attractionId: 1, name: "USC Village", location: "USC", isUSC: true, lat: 34.0268515, long: -118.2878486, hours: ["9:00 AM - 5:00 PM"], desc: "village"),
        Attraction(attractionId: 2, name: "Equad", location: "USC", isUSC: true, lat: 34.021007, long: -118.2891249, hours: ["Open 24 Hours"], desc: "village"),
        Attraction(attractionId: 3, name: "School of Cinematic Arts", location: "USC", isUSC: true,  lat: 34.0240968, long: -118.2886852, hours: ["Open 24 Hours"], desc: "village"),
        Attraction(attractionId: 4, name: "LA Memorial Colosseum", location: "USC", isUSC: true, lat: 34.0136691, long: -118.2904104, hours: ["Open 24 Hours"], desc: "village"),
        Attraction(attractionId: 5, name: "Marshall School of Business", location: "USC", isUSC: true, lat: 34.0188441, long: -118.2883342, hours: ["Open 24 Hours"], desc: "village"),
        
//        Attraction(attractionId: 6, name: "Doheny Library", location: "USC", isUSC: true, hours: ["Open 24 Hours"], desc: "village"),
//        Attraction(attractionId: 7, name: "Greek Row", location: "USC", isUSC: true, hours: ["Open 24 Hours"], desc: "village"),
//        Attraction(attractionId: 8, name: "Tommy Trojan", location: "USC", isUSC: true, hours: ["Open 24 Hours"], desc: "village"),
//        Attraction(attractionId: 9, name: "Crypto Center", location: "Los Angeles", isUSC: false, hours: ["Open 24 Hours"], desc: "village"),
//        Attraction(attractionId: 10, name: "FIDM Museum", location: "Los Angeles", isUSC: false, hours: ["Open 24 Hours"], desc: "village"),
//        Attraction(attractionId: 11, name: "Santa Monica Pier", location: "Los Angeles", isUSC: false, hours: ["Open 24 Hours"], desc: "village"),
//        Attraction(attractionId: 12, name: "Natural History Museum", location: "Los Angeles", isUSC: false, hours: ["Open 24 Hours"], desc: "village"),
//        Attraction(attractionId: 13, name: "Hollywood Walk of Fame", location: "Los Angeles", isUSC: false, hours: ["Open 24 Hours"], desc: "village"),
//        Attraction(attractionId: 14, name: "Hollywood Sign", location: "Los Angeles", isUSC: false, hours: ["Open 24 Hours"], desc: "village"),
//        Attraction(attractionId: 15, name: "The Getty", location: "Los Angeles", isUSC: false, hours: ["Open 24 Hours"], desc: "village"),
//        Attraction(attractionId: 16, name: "Griffith Observatory", location: "Los Angeles", isUSC: false, hours: ["Open 24 Hours"], desc: "village"),
//        Attraction(attractionId: 17, name: "Universal Studios", location: "Los Angeles", isUSC: false, hours: ["Open 24 Hours"], desc: "village"),
//        Attraction(attractionId: 18, name: "The Grove", location: "Los Angeles", isUSC: false, hours: ["Open 24 Hours"], desc: "village"),
//        Attraction(attractionId: 19, name: "Grand Central Market", location: "Los Angeles", isUSC: false, hours: ["Open 24 Hours"], desc: "village"),
//        Attraction(attractionId: 20, name: "Peterson Automative Museum", location: "Los Angeles", isUSC: false, hours: ["Open 24 Hours"], desc: "village"),
    ]
    
    
}
