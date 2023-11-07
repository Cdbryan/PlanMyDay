import SwiftUI
import FirebaseFirestore
import Firebase

struct HomeView: View {
    @State private var itineraries: [FirestoreItinerary] = []
    @State var plan: [[Attraction]]
    @State private var noItineraries: Bool = false

    var body: some View {
        NavigationView {
            if noItineraries {
                Text("No saved itineraries")
                    .font(.title)
                    .padding()
                    .onAppear {
                        loadItineraries()
                    }
            } else {
                List(itineraries, id: \.id) { itinerary in
                    NavigationLink(destination: MapPageView(itinerary: Itinerary(plan: plan, tourDuration: itinerary.tourDuration), disableSave: true)) {
                        Text(itinerary.itineraryName)
                    }
                }
                .onAppear {
                    loadItineraries()
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(
                        leading: HStack {
                            NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                                Text("Sign Out")
                            }
                            Text("My Trips")
                                .font(.title)
                                .foregroundColor(.primary)
                        },
                        trailing:
            NavigationLink(destination: AttractionView().navigationBarBackButtonHidden(false)) {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.primary)
            }
        )
    }

    func loadItineraries() {
        if let user = Auth.auth().currentUser {
            let db = Firestore.firestore()
            let userId = user.uid
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
                                            for selectedAttractionRef in itinerary.selectedAttrs {
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

                                                    if selectedAttractions.count == itinerary.selectedAttrs.count {
                                                        fetchedItineraries.append(itinerary)

                                                        if fetchedItineraries.count == querySnapshot?.documents.count {
                                                            self.itineraries = fetchedItineraries
                                                            self.noItineraries = false
                                                        }
                                                    }
                                                }
                                            }

                                            let planPerDay: Int = selectedAttractions.count / itinerary.numberOfDays

                                            itinerary.tourDuration = []
                                            self.plan = Array(repeating: [], count: itinerary.numberOfDays)

                                            let dateFormatter = DateFormatter()
                                            dateFormatter.dateFormat = "yyyy-MM-dd"
                                            itinerary.itineraryName = dateFormatter.string(from: Date())

                                            var currentDay = 0
                                            var currentDayDuration: Double = 0

                                            for attraction in selectedAttractions {
                                                let attractionDuration = attraction.isUSC ? 0.25 : 1.0
                                                if currentDayDuration + attractionDuration <= 6.0 && self.plan[currentDay].count < planPerDay {
                                                    self.plan[currentDay].append(attraction)
                                                    currentDayDuration += attractionDuration
                                                } else {
                                                    currentDay += 1
                                                    currentDayDuration = attractionDuration
                                                    if currentDay < itinerary.numberOfDays {
                                                        self.plan[currentDay].append(attraction)
                                                    }
                                                }

                                            }

                                            itinerary.tourDuration = self.plan.map { day in
                                                return day.reduce(0.0) { total, attraction in
                                                    return total + (attraction.isUSC ? 0.25 : 1.0)
                                                }
                                            }

                                            print("Plan Array:")
                                            for (dayIndex, dayAttractions) in self.plan.enumerated() {
                                                print("Day \(dayIndex + 1):")
                                                for attraction in dayAttractions {
                                                    print("- \(attraction.name)")
                                                }
                                            }

                                            print("Tour Duration Array:")
                                            for (dayIndex, duration) in itinerary.tourDuration.enumerated() {
                                                print("Day \(dayIndex + 1): \(duration) hours")
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
                        self.noItineraries = true
                    }
                } else if let error = error {
                    print("Error fetching user document: \(error)")
                }
            }
        } else {
            print("User is not authenticated.")
        }
    }
}
