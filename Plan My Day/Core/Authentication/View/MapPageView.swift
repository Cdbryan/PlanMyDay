import SwiftUI
import MapKit
import PDFKit
import UniformTypeIdentifiers



struct MapPageView: View {
    @State private var showMapsAlert = false
    @State private var pdfData: Data?
    @State private var isActivityViewPresented = false
    @State private var selectedDayIndex = 0

    @State private var directions: [MKDirections] = []

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

    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                
                HStack {
                   Spacer() // Add a spacer to push the button to the top right corner
                   
                    Button(action: {
                        saveAsPDF()

                    }) {
                        Image(systemName: "arrow.down.to.line.alt")
                            .font(.title)
                    }
                   .padding(.trailing) // Add some padding to the button
               }
                
                Picker("Day", selection: $selectedDayIndex) {
                    ForEach(0..<plan.count, id: \.self) { dayIndex in
                        Text("Day \(dayIndex + 1)").tag(dayIndex)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                ScrollView {
                    Text("Total Time: ")
                        .font(.title)
                        
                    ForEach(plan[selectedDayIndex].indices, id: \.self) { index in
                            HStack(alignment: .top, spacing: 10) {
                                Text("\(index + 1).")
                                    .font(.title3)
                                Text(plan[selectedDayIndex][index].name)
                                    .font(.title3)
                                
                                Spacer() // for left align
                            }
                            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                        }
                
                    }
                    
                // Display Map
                MapView(directions: $directions, attractions: plan[selectedDayIndex], selectedDayIndex: selectedDayIndex)
//                MapView(attractions: plan[selectedDayIndex])
                    .frame(height: 300) // Adjust the map height as needed
                
                Spacer()
                
                // Button to open in external map
                Button(action: {
                    showMapsAlert = true
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
                .alert(isPresented: $showMapsAlert) {
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
//            .navigationBarTitle("Tour Planned!", displayMode: .inline)
            .padding()
        }
    }
    
    func saveAsPDF() {
        guard let pdfData = self.convertToPDF() else {
            return
        }

        if let pdfURL = self.savePDFToFilesApp(pdfData: pdfData) {
            let activityViewController = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)
            
            
            UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true)
        }
    }
    
    func savePDFToFilesApp(pdfData: Data) -> URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }

        let pdfURL = documentsDirectory.appendingPathComponent("MyMap.pdf")

        do {
            try pdfData.write(to: pdfURL)
            return pdfURL
        } catch {
            print("Error saving PDF: \(error.localizedDescription)")
            return nil
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
        Spacer()
    }
}

//struct MapView: View {
//    var attractions: [Attraction]
//
//    @State private var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437),
//        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//    )
//
//    @State private var directions: MKDirections?
//
//    var body: some View {
//        Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow), annotationItems: attractions) { attraction in
//            MapPin(coordinate: CLLocationCoordinate2D(latitude: attraction.lat, longitude: attraction.long), tint: .blue)
//        }
//        .onAppear {
//            let minlat = attractions.min { $0.lat < $1.lat }?.lat ?? 34.0522
//            let maxlat = attractions.max { $0.lat < $1.lat }?.lat ?? 34.0522
//            let minlong = attractions.min { $0.long < $1.long }?.long ?? -118.2437
//            let maxlong = attractions.max { $0.long < $1.long }?.long ?? -118.2437
//
//            let center = CLLocationCoordinate2D(latitude: (minlat + maxlat) / 2, longitude: (minlong + maxlong) / 2)
//            let span = MKCoordinateSpan(latitudeDelta: maxlat - minlat, longitudeDelta: maxlong - minlong)
//
//            region = MKCoordinateRegion(center: center, span: span)
//
//        }
//    }
//
//}

struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView

    @Binding var directions: [MKDirections]
    var attractions: [Attraction]
    var selectedDayIndex: Int

    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Clear existing directions and annotations
        uiView.removeOverlays(uiView.overlays)
        uiView.removeAnnotations(uiView.annotations)

        let dayAttractions = attractions

        if dayAttractions.count == 1 {
            // Display a single placemark if there's only one attraction
            let attraction = dayAttractions[0]
            let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: attraction.lat, longitude: attraction.long))
            uiView.addAnnotation(placemark)
            
            // Calculate the region to fit the single attraction
            let region = MKCoordinateRegion(center: placemark.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            uiView.setRegion(region, animated: true)
        } else if dayAttractions.count > 1 {
            // Create an array to store source and destination placemarks for each attraction pair
            var placemarks: [MKPlacemark] = []

            for attraction in dayAttractions {
                let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: attraction.lat, longitude: attraction.long))
                placemarks.append(placemark)
            }

            // Calculate directions for each attraction pair
            for i in 0..<placemarks.count - 1 {
                let sourcePlacemark = placemarks[i]
                let destinationPlacemark = placemarks[i + 1]

                let request = MKDirections.Request()
                request.source = MKMapItem(placemark: sourcePlacemark)
                request.destination = MKMapItem(placemark: destinationPlacemark)
                request.transportType = .automobile

                let directions = MKDirections(request: request)
                directions.calculate { response, error in
                    guard let route = response?.routes.first else { return }
                    uiView.addAnnotations([sourcePlacemark, destinationPlacemark])
                    uiView.addOverlay(route.polyline)
                    uiView.setVisibleMapRect(
                        route.polyline.boundingMapRect,
                        edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                        animated: true)
                    self.directions = [directions] // Update the directions array for the selected day
                }
            }

            // Calculate the region to fit all attractions
            let coordinates = placemarks.map { $0.coordinate }
            let minLat = coordinates.min { $0.latitude < $1.latitude }?.latitude ?? 0.0
            let maxLat = coordinates.max { $0.latitude < $1.latitude }?.latitude ?? 0.0
            let minLon = coordinates.min { $0.longitude < $1.longitude }?.longitude ?? 0.0
            let maxLon = coordinates.max { $0.longitude < $1.longitude }?.longitude ?? 0.0

            let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
            let span = MKCoordinateSpan(latitudeDelta: maxLat - minLat, longitudeDelta: maxLon - minLon)
            let region = MKCoordinateRegion(center: center, span: span)
            uiView.setRegion(region, animated: true)
        }
    }

    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
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

extension View {
    func asImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        controller.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        let renderer = UIGraphicsImageRenderer(size: controller.view.bounds.size)
        return renderer.image { _ in
            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

extension MapPageView {
    func convertToPDF() -> Data? {
            // Capture a screenshot of the SwiftUI view
            let uiImage = asImage()

            // Create a PDF document
            let pdfData = NSMutableData()
            UIGraphicsBeginPDFContextToData(pdfData, CGRect(x: 0, y: 0, width: uiImage.size.width, height: uiImage.size.height), nil)

            UIGraphicsBeginPDFPage()
            uiImage.draw(in: CGRect(x: 0, y: 0, width: uiImage.size.width, height: uiImage.size.height))

            UIGraphicsEndPDFContext()

            return pdfData as Data
        }
}
