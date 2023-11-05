//
//  FirebaseService.swift
//  Plan My Day
//
//  Created by Christian Bryan  on 11/4/23.
//

import Foundation
import Firebase


//func addItineraryToFirestore(itinerary: Itinerary) {
//    let db = Firestore.firestore()
//    let itineraryRef = db.collection("Itinerary")
//
//    do {
//        // Convert the Itinerary object to a dictionary.
//        let itineraryData: [String: Any] = [
//            "itineraryName": itinerary.itineraryName,
//            "selectedAttrs": itinerary.selectedAttrs.map { $0.toDictionary() },
//            "numberOfDays": itinerary.numberOfDays,
//        ]
//
//        // Add the data to Firestore.
//        itineraryRef.addDocument(data: itineraryData) { error in
//            if let error = error {
//                print("Error adding itinerary to Firestore: \(error)")
//            } else {
//                print("Itinerary added to Firestore")
//            }
//        }
//    } catch {
//        print("Error encoding itinerary: \(error)")
//    }
//}

