import FirebaseFirestore

struct FirestoreAttraction: Identifiable, Codable {
    let id = UUID().uuidString
    let attractionId: Int
    let name: String
    let location: String
    let isUSC: Bool
    let lat: Double
    let long: Double
    var hours: [String]
    var desc: String
}

struct FirestoreItinerary: Identifiable, Codable {
    let id = UUID().uuidString
    var itineraryName: String
    let numberOfDays: Int
    var tourDuration: [Double]
    var plan: [[DocumentReference]] // Store references to attractions
    var selectedAttrs: [DocumentReference] // Store references to selected attractions
    
    static func decode(from data: [String: Any]) throws -> FirestoreItinerary {
        let decoder = Firestore.Decoder()
        return try decoder.decode(FirestoreItinerary.self, from: data)
    }
    
}

//func saveItineraryToFirestore() {
//    let db = Firestore.firestore()
//
//    let attractionRef1 = db.collection("attractions").document("unique_attraction_id_1")
//    let attractionRef2 = db.collection("attractions").document("unique_attraction_id_2")
//
//    let itinerary = FirestoreItinerary(
//        itineraryName: "My Itinerary",
//        numberOfDays: 3,
//        tourDuration: [1.0, 2.0, 3.0],
//        plan: [[attractionRef1, attractionRef2]],
//        selectedAttrs: [attractionRef1, attractionRef2]
//    )
//
//    // Store the itinerary in Firestore
//    let itineraryData: [String: Any] = [
//        "itineraryName": itinerary.itineraryName,
//        "numberOfDays": itinerary.numberOfDays,
//        "tourDuration": itinerary.tourDuration,
//        "plan": [attractionRef1, attractionRef2],
//        "selectedAttrs": [attractionRef1, attractionRef2]
//    ]
//
//    db.collection("itineraries").addDocument(data: itineraryData) { error in
//        if let error = error {
//            print("Error adding itinerary: \(error)")
//        } else {
//            print("Itinerary added successfully")
//        }
//    }
//
//
//
//}
//
//// Call the function to save the data to Firestore
//saveItineraryToFirestore()
