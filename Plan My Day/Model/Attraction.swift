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
        Attraction(attractionId: 6, name: "Doheny Memorial Library", location: "USC", isUSC: true, lat: 34.02028876802906, long: -118.2837041324907, hours: ["9:00 AM - 10:00 PM"], desc: "Doheny Jr. Memorial Library has served as an intellectual center and cultural treasure for generations of students, faculty and staff since it opened in 1932."),
        Attraction(attractionId: 7, name: "Fraternity Row", location: "USC", isUSC: true, lat: 34.0269884061183, long: -118.27868851241027, hours: ["Open 24 Hours"], desc: " An area that is home to most of USC's fraternities and sororities."),
        Attraction(attractionId: 8, name: "Tommy Trojan", location: "USC", isUSC: true, lat: 34.02070415232641, long: -118.28545753249075, hours: ["9:00 AM - 10:00 PM"], desc: "Tommy Trojan, officially known as the Trojan Shrine, is one of the most recognizable figures of school pride at the University of Southern California."),
        Attraction(attractionId: 9, name: "El Matador State Beach Malibu", location: "Los Angeles", isUSC: false, lat: 34.03830929142738, long: -118.87470591899874, hours: ["8:00 AM - 8:00 PM"], desc: "El Matador Beach is one of three beaches within Robert H. Meyer Memorial State Beach. El Matador is the most popular of the three and located in Malibu."),
        Attraction(attractionId: 10, name: "LA Urban Lights", location: "Los Angeles", isUSC: false, lat: 34.06313901712488, long: -118.35924803248918, hours: ["Open 24 Hours"], desc: "This forest of city street lights, called Urban Light was created by artist Chris Burden."),
        Attraction(attractionId: 11, name: "Santa Monica Pier", location: "Los Angeles", isUSC: false, lat: 34.00858589210455, long: -118.498804750146, hours: ["Open 24 Hours"], desc: "Santa Monica Pier is a large pier at the foot of Colorado Avenue in Santa Monica, California, United States. It contains a small amusement park, concession stands, and areas for views and fishing."),
        Attraction(attractionId: 12, name: "Natural History Museum", location: "Los Angeles", isUSC: false, lat: 34.017295950852585, long: -118.2886420459823, hours: ["9:00 AM - 5:00 PM"], desc: "The Natural History Museum of Los Angeles County is the largest natural and historical museum in the western United States. Its collections include nearly 35 million specimens and artifacts and cover 4.5 billion years of history."),
        Attraction(attractionId: 13, name: "Hollywood Walk of Fame", location: "Los Angeles", isUSC: false, lat: 34.10179438412621, long: -118.32674801899633, hours: ["Open 24 Hours"], desc: "The Hollywood Walk of Fame is a historic landmark which consists of more than 2,700 five-pointed terrazzo and brass stars embedded in the sidewalks along 15 blocks of Hollywood Boulevard and three blocks of Vine Street in Hollywood, California. The stars are monuments to achievement in the entertainment industry, bearing the names of a mix of actors, directors, producers, musicians, theatrical/musical groups, fictional characters, and others."),
        Attraction(attractionId: 14, name: "Hollywood Sign", location: "Los Angeles", isUSC: false, lat: 34.134225575541016, long: -118.32156926528808, hours: ["Open 24 Hours"], desc: "The Hollywood Sign is an American landmark and cultural icon overlooking Hollywood, Los Angeles, California."),
        Attraction(attractionId: 15, name: "The Getty", location: "Los Angeles", isUSC: false, lat: 34.078204615128655, long: -118.47410613248854, hours: ["9:00 AM - 5:30 PM"], desc: "The J. Paul Getty Museum, commonly referred to as the Getty, is an art museum in Los Angeles, California housed on two campuses: the Getty Center and Getty Villa."),
        Attraction(attractionId: 16, name: "Griffith Observatory", location: "Los Angeles", isUSC: false, lat:34.11861164744516, long: -118.30044716841796, hours: ["9:00 AM - 10:00 PM"], desc: "It commands a view of the Los Angeles Basin including Downtown Los Angeles to the southeast, Hollywood to the south, and the Pacific Ocean to the southwest. The observatory is a popular tourist attraction with a close view of the Hollywood Sign."),
        Attraction(attractionId: 17, name: "Universal Studios", location: "Los Angeles", isUSC: false, lat: 34.13839019826347, long: -118.35343847708833, hours: ["9:00 AM - 10:00 PM"], desc: "Universal Studios Hollywood is a film studio and theme park in the San Fernando Valley area of Los Angeles County, California. It is one of the oldest and most famous Hollywood film studios still in use."),
        Attraction(attractionId: 18, name: "The Grove", location: "Los Angeles", isUSC: false, lat: 34.07211834511458, long: -118.35749496657732, hours: ["9:00 AM - 8:00 PM"], desc: "The Grove is a retail and entertainment complex in Los Angeles, located on parts of the historic Farmers Market."),
        Attraction(attractionId: 19, name: "Grand Central Market", location: "Los Angeles", isUSC: false, lat: 34.050996422960075, long: -118.24905520365333, hours: ["8:00 AM - 9:00 PM"], desc: "Emporium hosting food vendors & florists, plus game nights, movies & other events, since 1917."),
        Attraction(attractionId: 20, name: "Petersen Automotive Museum", location: "Los Angeles", isUSC: false, lat: 34.06212174229391, long: -118.36140601899784, hours: ["9:00 AM - 5:00 PM"], desc: "One of the world's largest automotive museums, the Petersen Automotive Museum is a nonprofit organization specializing in automobile history and related educational programs.")
    ]
    
    
}
