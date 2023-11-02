import SwiftUI
import MapKit

struct MapPageView: View {
    @State private var showAlert = false
    var itinerary: Itinerary
    var plan: [[Attraction]] = [
        [Attraction(attractionId: 1, name: "USC Village", location: "USC", isUSC: true, lat: 34.0268515, long: -118.2878486, hours: ["9:00 AM - 5:00 PM"], desc: "village"),
         Attraction(attractionId: 2, name: "Equad", location: "USC", isUSC: true, lat: 34.021007, long: -118.2891249, hours: ["Open 24 Hours"], desc: "village")
        ],
        
        [Attraction(attractionId: 3, name: "School of Cinematic Arts", location: "USC", isUSC: true, lat: 34.0240968, long: -118.2886852, hours: ["Open 24 Hours"], desc: "village"),
         Attraction(attractionId: 4, name: "LA Memorial Colosseum", location: "USC", isUSC: true, lat: 34.0136691, long: -118.2904104, hours: ["Open 24 Hours"], desc: "village")],
        
        [Attraction(attractionId: 5, name: "Marshall School of Business", location: "USC", isUSC: true, lat: 34.0188441, long: -118.2883342, hours: ["Open 24 Hours"], desc: "village"),
        ]
    ] // holder; need to implement generate plan function

    @State private var selectedDayIndex = 0

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Picker("Day", selection: $selectedDayIndex) {
                    ForEach(0..<plan.count, id: \.self) { dayIndex in
                        Text("Day \(dayIndex + 1)").tag(dayIndex)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                ScrollView {
                        ForEach(plan[selectedDayIndex].indices, id: \.self) { index in
                            HStack(alignment: .top, spacing: 10) {
                                Text("\(index + 1).")
                                    .font(.title)
                                Text(plan[selectedDayIndex][index].name)
                                    .font(.title)
                                    .lineLimit(nil)
                            }
                            .padding()
                        }
                    }
                    
                // Display Map
                MapView(attractions: plan[selectedDayIndex])
                    .frame(height: 300) // Adjust the map height as needed
                
                Spacer()
                
                // Button to open in external map
                Button(action: {
                    showAlert = true
                }) {
                    HStack {
                        Image("apple_maps_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30) // Adjust the width and height as needed
                        Image("google_maps_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30) // Adjust the width and height as needed

                        Text("Open in External Maps")
                            .font(.title2)
                            .foregroundColor(Color.accentColor)
                    }
                }
                .padding()
                .cornerRadius(10)

                // Alert for choosing a map app
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Choose a Map App"),
                        message: Text("Open the location in Google Maps or Apple Maps?"),
                        primaryButton: .default(Text("Google Maps")) {
                            openGoogleMaps()
                        },
                        secondaryButton: .default(Text("Apple Maps")) {
                            openAppleMaps()
                        }
                    )
                }
            
                            
            }
            .navigationBarTitle("Tour Planned!", displayMode: .inline)
            .padding()
        }
    }
}

struct AttractionRowView: View {
    var attraction: Attraction
    var number: Int

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("\(number).")
                .font(.title)
            Text(attraction.name)
                .font(.title)
                .lineLimit(nil)
        }
    }
}

func openGoogleMaps() {
        if let url = URL(string: "comgooglemaps://?q=latitude,longitude") {
            UIApplication.shared.open(url)
        }
    }

func openAppleMaps() {
    if let url = URL(string: "http://maps.apple.com/?q=latitude,longitude") {
        UIApplication.shared.open(url)
    }
}

struct MapView: View {
    var attractions: [Attraction]

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437), // Default coordinates
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: attractions) { attraction in
            MapPin(coordinate: CLLocationCoordinate2D(latitude:  attraction.lat, longitude:  attraction.long), tint: .blue)
        }
        .onAppear {
            // Calculate the region that fits all attraction pins
            let minlat = attractions.min { $0.lat < $1.lat }?.lat ?? 34.0522
            let maxlat = attractions.max { $0.lat < $1.lat }?.lat ?? 34.0522
            let minlong = attractions.min { $0.long < $1.long }?.long ?? -118.2437
            let maxlong = attractions.max { $0.long < $1.long }?.long ?? -118.2437

            let center = CLLocationCoordinate2D(latitude: (minlat + maxlat) / 2, longitude: (minlong + maxlong) / 2)
            let span = MKCoordinateSpan(latitudeDelta: maxlat - minlat, longitudeDelta: maxlong - minlong)

            region = MKCoordinateRegion(center: center, span: span)
        }
    }
}


struct ItineraryView_Previews: PreviewProvider {
    static var previews: some View {
        let selected_attractions = [
            Attraction(attractionId: 1, name: "USC Village", location: "USC", isUSC: true, lat: 34.0268515, long: -118.2878486, hours: ["9:00 AM - 5:00 PM"], desc: "village"),
            Attraction(attractionId: 2, name: "Equad", location: "USC", isUSC: true, lat: 34.021007, long: -118.2891249, hours: ["Open 24 Hours"], desc: "village")
        ]
        let numberOfDays = 1
        @State var itinerary = Itinerary(attractions: selected_attractions, numberOfDays: numberOfDays)

        return MapPageView(itinerary: itinerary)
    }
}
