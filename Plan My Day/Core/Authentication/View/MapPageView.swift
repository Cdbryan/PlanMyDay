//
//  MapPageView.swift
//  Plan My Day
//
//  Created by Josheta Srinivasan on 1/11/23.
//

import SwiftUI

struct MapPageView: View {
    var itinerary: Itinerary

    var body: some View {
        VStack {
            Text("Number of Days: \(itinerary.numberOfDays)") // Display the number of days
                .font(.headline)
                .padding()
            
            List {
                ForEach(itinerary.selectedAttrs, id: \.attractionId) { attraction in
                    Text(attraction.name)
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Selected Attractions")
    }
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
