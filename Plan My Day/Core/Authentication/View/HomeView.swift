import SwiftUI



struct HomeView: View {
    
    
    //    var itinerary = Itinerary(plan: [
    //        [Attraction(attractionId: 1, name: "USC Village", location: "USC", isUSC: true, lat: 34.0268515, long: -118.2878486, hours: ["9:00 AM - 5:00 PM"], desc: "village"),
    //         Attraction(attractionId: 2, name: "Equad", location: "USC", isUSC: true, lat: 34.021007, long: -118.2891249, hours: ["Open 24 Hours"], desc: "village")
    //        ],
    //
    //        [Attraction(attractionId: 3, name: "School of Cinematic Arts", location: "USC", isUSC: true, lat: 34.0240968, long: -118.2886852, hours: ["Open 24 Hours"], desc: "village"),
    //         Attraction(attractionId: 4, name: "LA Memorial Colosseum", location: "USC", isUSC: true, lat: 34.0136691, long: -118.2904104, hours: ["Open 24 Hours"], desc: "village")],
    //
    //        [Attraction(attractionId: 5, name: "Marshall School of Business", location: "USC", isUSC: true, lat: 34.0188441, long: -118.2883342, hours: ["Open 24 Hours"], desc: "village"),
    //        ]
    //    ])
    //
    //    var itineraries : [Itinerary] = [Itinerary(plan: [
    //        [Attraction(attractionId: 1, name: "USC Village", location: "USC", isUSC: true, lat: 34.0268515, long: -118.2878486, hours: ["9:00 AM - 5:00 PM"], desc: "village"),
    //         Attraction(attractionId: 2, name: "Equad", location: "USC", isUSC: true, lat: 34.021007, long: -118.2891249, hours: ["Open 24 Hours"], desc: "village")
    //        ],
    //
    //        [Attraction(attractionId: 3, name: "School of Cinematic Arts", location: "USC", isUSC: true, lat: 34.0240968, long: -118.2886852, hours: ["Open 24 Hours"], desc: "village"),
    //         Attraction(attractionId: 4, name: "LA Memorial Colosseum", location: "USC", isUSC: true, lat: 34.0136691, long: -118.2904104, hours: ["Open 24 Hours"], desc: "village")],
    //
    //        [Attraction(attractionId: 5, name: "Marshall School of Business", location: "USC", isUSC: true, lat: 34.0188441, long: -118.2883342, hours: ["Open 24 Hours"], desc: "village"),
    //        ]
    //    ])]
    
    
    
    
    var itineraries : [Itinerary] = [
        Itinerary(itineraryName: "Other Trip", attractions: [
        Attraction(attractionId: 1, name: "USC Village", location: "USC", isUSC: true, lat: 34.0268515, long: -118.2878486, hours: ["9:00 AM - 5:00 PM"], desc: "village"),
        Attraction(attractionId: 2, name: "Equad", location: "USC", isUSC: true, lat: 34.021007, long: -118.2891249, hours: ["Open 24 Hours"], desc: "village")], numberOfDays: 2), 
        
        Itinerary(itineraryName: "USC Trip", attractions: [
        Attraction(attractionId: 6, name: "Leavy", location: "USC", isUSC: true, lat: 34.0268515, long: -118.2878486, hours: ["9:00 AM - 5:00 PM"], desc: "village"),
        Attraction(attractionId: 7, name: "SCA", location: "USC", isUSC: true, lat: 34.021007, long: -118.2891249, hours: ["Open 24 Hours"], desc: "village")], numberOfDays: 2)]
    
    
    
    var body: some View {
        NavigationView {
            List(itineraries, id: \.itineraryID) { itinerary in
                NavigationLink(destination: MapPageView(itinerary : itinerary)) {
                    Text(itinerary.itineraryName)
                }
            }
            .navigationBarTitle("", displayMode: .inline) // Hide the default title
            .navigationBarItems(leading:
                                    Text("My Trips")
                .font(.title)
                .foregroundColor(.primary),
                                trailing:
                                    NavigationLink(destination: AttractionView().navigationBarBackButtonHidden(true)) {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.primary)
            }
            )
        }
    }
}
