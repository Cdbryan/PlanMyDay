//
//  Attraction.swift
//  Plan My Day
//
//  Created by Josheta Srinivasan on 1/11/23.
//

import Foundation

struct Attraction: Identifiable, Encodable {
    let id = UUID().uuidString
    let attractionId: Int
    let name: String
    let location: String
    let isUSC: Bool
    let lat: Double
    let long: Double
    var hours: [String]
    var desc: String
    
//    func toDictionary() -> [String: Any] {
//            var dictionary: [String: Any] = [
//                "attractionId": attractionId,
//                "name": name,
//                "location": location,
//                "isUSC": isUSC,
//                "lat": lat,
//                "long": long,
//                "hours" : hours,
//                "desc" : desc
//                // Add other fields as needed
//            ]
//
//            return dictionary
//        }
//    

    static let attractionList = [
        Attraction(attractionId: 1, name: "USC Village", location: "USC", isUSC: true, lat: 34.0268515, long: -118.2878486, hours: ["9:00 AM - 10:00 PM"], desc: "The USC Village provides our frehmen and sophomore Trojans a built-in community from the moment they arrive, fostering the success of USC students during their time at the university. It features a range of shops, amenities and dining options, open to USC’s community and neighbors."),
        Attraction(attractionId: 2, name: "Equad", location: "USC", isUSC: true, lat: 34.021007, long: -118.2891249, hours: ["9:00 AM - 10:00 PM"], desc: "The Engineering Quad is the heart of the Viterbi School of Engineering. It has many new lounge areas and tables to eat and do work on a nice day in LA."),
        Attraction(attractionId: 3, name: "School of Cinematic Arts", location: "USC", isUSC: true,  lat: 34.0240968, long: -118.2886852, hours: ["9:00 AM - 10:00 PM"], desc: "The School of Cinematic Arts is divided into seven divisions that work together to train the leaders, scholars and media makers of tomorrow. It is by far, one of the prettiest buildings on campus with a Coffee Bean located insdie."),
        Attraction(attractionId: 4, name: "LA Memorial Coliseum", location: "USC", isUSC: true, lat: 34.0136691, long: -118.2904104, hours: ["9:00 AM - 10:00 PM"], desc: "The home of the USC Trojans and also known as the Greatest Stadium in the World. It serves as a living memorial to all who served in the U.S. Armed Forces during World War I. The Coliseum has been a civic treasure for generations of Angelenos."),
        Attraction(attractionId: 5, name: "Marshall School of Business", location: "USC", isUSC: true, lat: 34.0188441, long: -118.2883342, hours: ["9:00 AM - 10:00 PM"], desc: "USC Marshall School of Business is one of the world's leading global undergraduate business programs. It is one of the most popular buildings on campus for business and non-business majors alike."),
        //from doheny
        Attraction(attractionId: 6, name: "Doheny Memorial Library", location: "USC", isUSC: true, lat: 34.02028876802906, long: -118.2837041324907, hours: ["9:00 AM - 10:00 PM"], desc: "Doheny Jr. Memorial Library has served as an intellectual center and cultural treasure for generations of students, faculty and staff since it opened in 1932."),
        Attraction(attractionId: 7, name: "Fraternity Row", location: "USC", isUSC: true, lat: 34.0269884061183, long: -118.27868851241027, hours: ["Open 24 Hours"], desc: " An area that is home to most of USC's fraternities and sororities."),
        Attraction(attractionId: 8, name: "Tommy Trojan", location: "USC", isUSC: true, lat: 34.02070415232641, long: -118.28545753249075, hours: ["9:00 AM - 10:00 PM"], desc: "Tommy Trojan, officially known as the Trojan Shrine, is one of the most recognizable figures of school pride at the University of Southern California."),
        Attraction(attractionId: 9, name: "S! USC Village", location: "USC", isUSC: false, lat: 34.0268515, long: -118.2878486, hours: ["9:00 AM - 10:00 PM"], desc: "The USC Village provides our frehmen and sophomore Trojans a built-in community from the moment they arrive, fostering the success of USC students during their time at the university. It features a range of shops, amenities and dining options, open to USC’s community and neighbors."),
        Attraction(attractionId: 10, name: "S! Equad", location: "USC", isUSC: false, lat: 34.021007, long: -118.2891249, hours: ["9:00 AM - 10:00 PM"], desc: "The Engineering Quad is the heart of the Viterbi School of Engineering. It has many new lounge areas and tables to eat and do work on a nice day in LA."),
        Attraction(attractionId: 11, name: "S! School of Cinematic Arts", location: "USC", isUSC: false,  lat: 34.0240968, long: -118.2886852, hours: ["9:00 AM - 10:00 PM"], desc: "The School of Cinematic Arts is divided into seven divisions that work together to train the leaders, scholars and media makers of tomorrow. It is by far, one of the prettiest buildings on campus with a Coffee Bean located insdie."),
        Attraction(attractionId: 12, name: "S! LA Memorial Coliseum", location: "USC", isUSC: false, lat: 34.0136691, long: -118.2904104, hours: ["9:00 AM - 10:00 PM"], desc: "The home of the USC Trojans and also known as the Greatest Stadium in the World. It serves as a living memorial to all who served in the U.S. Armed Forces during World War I. The Coliseum has been a civic treasure for generations of Angelenos."),
        Attraction(attractionId: 13, name: "S! Marshall School of Business", location: "USC", isUSC: false, lat: 34.0188441, long: -118.2883342, hours: ["9:00 AM - 10:00 PM"], desc: "USC Marshall School of Business is one of the world's leading global undergraduate business programs. It is one of the most popular buildings on campus for business and non-business majors alike."),
        //from doheny
        Attraction(attractionId: 14, name: "S! Doheny Memorial Library", location: "USC", isUSC: false, lat: 34.02028876802906, long: -118.2837041324907, hours: ["9:00 AM - 10:00 PM"], desc: "Doheny Jr. Memorial Library has served as an intellectual center and cultural treasure for generations of students, faculty and staff since it opened in 1932."),
        Attraction(attractionId: 15, name: "S! Fraternity Row", location: "USC", isUSC: false, lat: 34.0269884061183, long: -118.27868851241027, hours: ["Open 24 Hours"], desc: " An area that is home to most of USC's fraternities and sororities."),
        Attraction(attractionId: 16, name: "S! Tommy Trojan", location: "USC", isUSC: false, lat: 34.02070415232641, long: -118.28545753249075, hours: ["9:00 AM - 10:00 PM"], desc: "Tommy Trojan, officially known as the Trojan Shrine, is one of the most recognizable figures of school pride at the University of Southern California.")
    ]
    
    
}
