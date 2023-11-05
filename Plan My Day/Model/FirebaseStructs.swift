//
//  FirebaseStructs.swift
//  Plan My Day
//
//  Created by Josheta Srinivasan on 5/11/23.
//
import FirebaseFirestore

struct FirestoreAttraction: Identifiable, Codable {
    var id: String // Change id property to a String
    var attractionId: Int
    var name: String
    var location: String
    var isUSC: Bool
    var lat: Double
    var long: Double
    var hours: [String]
    var desc: String

    enum CodingKeys: String, CodingKey {
        case id
        case attractionId
        case name
        case location
        case isUSC
        case lat
        case long
        case hours
        case desc
    }

    init(id: String, attractionId: Int, name: String, location: String, isUSC: Bool, lat: Double, long: Double, hours: [String], desc: String) {
        self.id = id
        self.attractionId = attractionId
        self.name = name
        self.location = location
        self.isUSC = isUSC
        self.lat = lat
        self.long = long
        self.hours = hours
        self.desc = desc
    }
}

struct FirestoreItinerary: Identifiable, Codable {
    var id: String // Change id property to a String
    var itineraryID: Int
    var itineraryName: String
    var attractions: [String] // Store attraction IDs here
    var numberOfDays: Int
    var tourDuration: [Int]
    var plan: [[String]] // Store attraction IDs here

    enum CodingKeys: String, CodingKey {
        case id
        case itineraryID
        case itineraryName
        case attractions
        case numberOfDays
        case tourDuration
        case plan
    }

    init(id: String, itineraryID: Int, itineraryName: String, attractions: [String], numberOfDays: Int, tourDuration: [Int], plan: [[String]]) {
        self.id = id
        self.itineraryID = itineraryID
        self.itineraryName = itineraryName
        self.attractions = attractions
        self.numberOfDays = numberOfDays
        self.tourDuration = tourDuration
        self.plan = plan
    }
}
