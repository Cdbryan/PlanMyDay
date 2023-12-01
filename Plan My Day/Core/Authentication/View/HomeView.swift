import SwiftUI
import FirebaseFirestore
import Firebase

struct HomeView: View {
    @State private var itineraries: [FirestoreItinerary] = []
    @State var plans: [[[Attraction]]] = [] // 3D array for plans
    @State var noItineraries: Bool = true // Initialize as true

    // Properties to handle navigation link action simulation
    var navigationLinkAction: (() -> Void)?
    var simulateNavigation: (() -> Void)?

    var body: some View {
        NavigationView {
            if noItineraries {
                Text("No saved itineraries")
                    .font(.title)
                    .padding()
                    .onAppear {
                        self.loadItineraries { itineraryIDs in
                            // Use itineraryIDs as needed
                            print("Test - Itinerary IDs count: \(itineraryIDs?.count ?? 0)")
                        }
                    }
            } else {
                List {
                    ForEach(0..<itineraries.count, id: \.self) { index in
                        NavigationLink(destination: MapPageView(itinerary: Itinerary(plan: plans[index], tourDuration: itineraries[index].tourDuration), disableSave: true)) {
                            Text(itineraries[index].itineraryName)
                        }
                    }
                }.accessibilityIdentifier("itineraryList")
                .onAppear {
                    self.loadItineraries { itineraryIDs in
                        // Use itineraryIDs as needed
                        print("Test - Itinerary IDs count: \(itineraryIDs?.count ?? 0)")
                    }
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(
            leading: HStack {
                NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                    Text("Sign Out").accessibilityIdentifier("Sign Out")
                }
                Text("My Trips")
                    .font(.custom("Nunito-VariableFont_wght.ttf", size: 30))
                    .foregroundColor(Color(red: 0.42, green: 0.56, blue: 0.5))
                    .accessibilityIdentifier("MyTripsIdentifier")
            },
            trailing:
                HStack {
                Spacer()
                
                ZStack {
                    Circle()
                        .foregroundColor(Color(red: 242/255, green: 184/255, blue: 125/255)) // Use the RGB values
                        .frame(width: 44, height: 44)
                    
                    NavigationLink(destination: AttractionView().navigationBarBackButtonHidden(false)) {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.white)
                            .accessibilityIdentifier("PlusIdentifier")
                    }
                    .frame(width: 44, height: 44)
                    .offset(x: -5) // Adjust the offset as needed
                }
                Spacer()
            }
        )
        // Simulate the navigation link action
        .onAppear {
            self.navigationLinkAction?()
        }
    }

    func loadItineraries(testUserID: String? = nil, completion: @escaping ([String]?) -> Void) {
        // Check if it's a test scenario and use the provided testUserID or the current user's ID
        let userID = testUserID ?? Auth.auth().currentUser?.uid

        guard let userId = userID else {
            print("User is not authenticated.")
            completion(nil)
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)

        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data(), let itineraryIDsData = data["itineraryIDs"] as? [Any], !itineraryIDsData.isEmpty {
                    let itineraryIDs = itineraryIDsData.compactMap { value in
                        if let stringValue = value as? String, UUID(uuidString: stringValue) != nil {
                            return stringValue
                        } else {
                            return nil
                        }
                    }

                    print("Itinerary IDs: \(itineraryIDs)")
                    // Call the completion handler with itineraryIDs
                    completion(itineraryIDs)

                    db.collection("itineraries").whereField("id", in: itineraryIDs).getDocuments { (querySnapshot, error) in
                        if let error = error {
                            print("Error fetching itineraries: \(error)")
                        } else {
                            var fetchedItineraries: [FirestoreItinerary] = []

                            for document in querySnapshot?.documents ?? [] {
                                do {
                                    if let itineraryData = document.data() as? [String: Any] {
                                        var itinerary = FirestoreItinerary(
                                            itineraryName: itineraryData["itineraryName"] as? String ?? "",
                                            numberOfDays: itineraryData["numberOfDays"] as? Int ?? 0,
                                            tourDuration: itineraryData["tourDuration"] as? [Double] ?? [],
                                            plan: itineraryData["plan"] as? [[DocumentReference]] ?? [[]],
                                            selectedAttrs: itineraryData["selectedAttrs"] as? [DocumentReference] ?? []
                                        )

                                        var selectedAttractions: [Attraction] = []

                                        // Create a Dispatch Group
                                        let dispatchGroup = DispatchGroup()

                                        var itineraryPlans: [[Attraction]] = Array(repeating: [], count: itinerary.numberOfDays) // Initialize the plans array

                                        for (index, selectedAttractionRef) in itinerary.selectedAttrs.enumerated() {
                                            // Enter the Dispatch Group
                                            dispatchGroup.enter()

                                            selectedAttractionRef.getDocument { (attractionDocument, attractionError) in
                                                if let attractionError = attractionError {
                                                    print("Error fetching attraction document: \(attractionError)")
                                                } else if let attractionDocument = attractionDocument, attractionDocument.exists {
                                                    if let attractionData = attractionDocument.data() as? [String: Any] {
                                                        let attraction = Attraction(
                                                            attractionId: attractionData["attractionId"] as? Int ?? 0,
                                                            name: attractionData["name"] as? String ?? "",
                                                            location: attractionData["location"] as? String ?? "",
                                                            isUSC: attractionData["isUSC"] as? Bool ?? false,
                                                            lat: attractionData["lat"] as? Double ?? 0.0,
                                                            long: attractionData["long"] as? Double ?? 0.0,
                                                            hours: attractionData["hours"] as? [String] ?? [],
                                                            desc: attractionData["desc"] as? String ?? ""
                                                        )
                                                        selectedAttractions.append(attraction)
                                                        print("Selected Attraction: \(attraction)")
                                                    }
                                                }

                                                // Leave the Dispatch Group
                                                dispatchGroup.leave()
                                            }
                                        }

                                        // Notify when all attraction documents are fetched
                                        dispatchGroup.notify(queue: .main) {
                                            let planPerDay: Int = Int(ceil(Double(selectedAttractions.count) / Double(itinerary.numberOfDays)))

                                            itinerary.tourDuration = []

                                            // Initialize a 2D array for the plans
                                            var itineraryPlans: [[Attraction]] = Array(repeating: [], count: itinerary.numberOfDays)

                                            // Populate the itineraryPlans 2D array with selectedAttractions
                                            for (index, attraction) in selectedAttractions.enumerated() {
                                                let day = index / planPerDay

                                                // Ensure the day index is within bounds
                                                if day < itinerary.numberOfDays {
                                                    itineraryPlans[day].append(attraction)
                                                } else {
                                                    // Handle the case where the day index is out of bounds
                                                    print("Day index is out of bounds: \(day)")
                                                }
                                            }

                                            // Populate the tour duration array with the duration of each day
                                            itinerary.tourDuration = itineraryPlans.map { day in
                                                return day.reduce(0.0) { total, attraction in
                                                    return total + (attraction.isUSC ? 0.25 : 1.0)
                                                }
                                            }

                                            // Append the plan to the plans array
                                            self.plans.append(itineraryPlans)
                                            print("Plans 3D array: \(self.plans)") // Print the plans array

                                            fetchedItineraries.append(itinerary)
                                            self.itineraries = fetchedItineraries // Update the itineraries array
                                            self.noItineraries = false // Update the flag when itineraries are found
                                        }
                                    }
                                } catch let error {
                                    print("Error decoding FirestoreItinerary: \(error)")
                                }
                            }
                        }
                    }
                } else {
                    print("User has no valid itineraryIDs or it's not an array of UUID strings or it's empty.")
                    self.noItineraries = true // Update the flag when no itineraries are found
                    completion(nil)
                }
            } else if let error = error {
                print("Error fetching user document: \(error)")
                completion(nil)
            }
        }
    }
}
