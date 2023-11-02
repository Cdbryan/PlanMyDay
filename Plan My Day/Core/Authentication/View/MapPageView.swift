//
//  MapPageView.swift
//  Plan My Day
//
//  Created by Josheta Srinivasan on 1/11/23.
//

import SwiftUI


struct MapPageView: View {
    var itinerary: Itinerary
    var plan: [[Attraction]] = [
            [Attraction(attractionId: 1, name: "USC Village", location: "USC", isUSC: true, hours: ["9:00 AM - 5:00 PM"], desc: "village"),
             Attraction(attractionId: 2, name: "Equad", location: "USC", isUSC: true, hours: ["Open 24 Hours"], desc: "village")
            ],
            
            [Attraction(attractionId: 3, name: "School of Cinematic Arts", location: "USC", isUSC: true, hours: ["Open 24 Hours"], desc: "village"),
             Attraction(attractionId: 4, name: "LA Memorial Colosseum", location: "USC", isUSC: true, hours: ["Open 24 Hours"], desc: "village")],
            
            
            [Attraction(attractionId: 5, name: "Marshall School of Business", location: "USC", isUSC: true, hours: ["Open 24 Hours"], desc: "village")]
        ] // holder; need to implement generate plan function

    @State private var selectedDayIndex = 0

    var body: some View {
            NavigationView {
                VStack {
                    Picker("Day", selection: $selectedDayIndex) {
                        ForEach(0..<plan.count, id: \.self) { dayIndex in
                            Text("Day \(dayIndex + 1)").tag(dayIndex)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    List(plan[selectedDayIndex]) { attraction in
                        Text(attraction.name)
                            .font(.title)
                    }
                }
                .navigationBarTitle("Tour Planned!", displayMode: .inline)
            }
        }
//    var body: some View {
//        VStack {
//
//
//
//            Text("Number of Days: \(itinerary.numberOfDays)") // Display the number of days
//                .font(.headline)
//                .padding()
//
//            List {
//                ForEach(itinerary.selectedAttrs, id: \.attractionId) { attraction in
//                    Text(attraction.name)
//                }
//            }
//            .listStyle(PlainListStyle())
//        }
//        .navigationTitle("Tour Planned! ")
//    }
}

struct ItineraryView_Previews: PreviewProvider {
    static var previews: some View {
        let selected_attractions = [
            Attraction(attractionId: 1, name: "USC Village", location: "USC", isUSC: true, hours: ["9:00 AM - 5:00 PM"], desc: "village"),
            Attraction(attractionId: 2, name: "Equad", location: "USC", isUSC: true, hours: ["Open 24 Hours"], desc: "village")
        ]
        let numberOfDays = 1
        @State var itinerary = Itinerary(attractions: selected_attractions, numberOfDays: numberOfDays)

        return MapPageView(itinerary: itinerary)
    }
}
