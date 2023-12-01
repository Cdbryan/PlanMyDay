import SwiftUI
import MapKit
import PDFKit
import UniformTypeIdentifiers
import Firebase

enum MapMode {
    case car
    case walk
}

struct ItineraryData {
    var id: String
    var itineraryName: String
    var numberOfDays: Int
    var tourDuration: [Double]
    var plan: [[Attraction]]
    var selectedAttrs: [Attraction]
}

struct MapPageView: View {
    @State private var showMapsAlert = false {
            didSet {
                #if DEBUG
                debugShowMapsAlert = showMapsAlert
                #endif
            }
        }
        
        @State private var pdfData: Data? {
            didSet {
                #if DEBUG
                debugPdfData = pdfData
                #endif
            }
        }
        
        @State private var isActivityViewPresented = false {
            didSet {
                #if DEBUG
                debugIsActivityViewPresented = isActivityViewPresented
                #endif
            }
        }
        
        @State private var selectedDayIndex: Int = 0 {
            didSet {
                #if DEBUG
                if selectedDayIndex != debugSelectedDayIndex {
                    debugSelectedDayIndex = selectedDayIndex
                }
                #endif
            }
        }
    
    @State private var selectedMapMode: MapMode = .car {
            didSet {
                #if DEBUG
                if selectedMapMode != debugSelectedMapMode {
                    debugSelectedMapMode = selectedMapMode
                }
                #endif
            }
        }


        // Debug properties
        #if DEBUG
        @State public var debugShowMapsAlert = false
        @State public var debugPdfData: Data?
        @State public var debugIsActivityViewPresented = false
//        @State public var debugSelectedDayIndex = 0
//        @State public var debugSelectedMapMode: MapMode = .car
//        @State public var debugDirections: [MKDirections] = []
        @State public var debugSelectedDayIndex = 0 {
                didSet {
                    selectedDayIndex = debugSelectedDayIndex
                }
            }
            @State public var debugSelectedMapMode: MapMode = .car {
                didSet {
                    selectedMapMode = debugSelectedMapMode
                }
            }
            @State public var debugDirections: [MKDirections] = []
        #endif
    
    var onGenerateURL: ((URL, Int) -> Void)?
    var onSaveItinerary: ((ItineraryData) -> Void)?


    @State private var directions: [MKDirections] = []{
        didSet {
            #if DEBUG
            debugDirections = directions
            #endif
        }
        
    }
    
    @Environment(\.openURL) private var openURL

    func formatTourDuration(_ duration: Double) -> String {
        let integerValue = Int(duration)
        if duration - Double(integerValue) == 0 {
            // Display as a whole number if it has no fractional part
            return String("\(integerValue) hours")
        } else {
            // Display with two decimal places
            return String(format: "%.2f hours", duration)
        }
    }
    
    var itinerary: Itinerary
    var disableSave: Bool
    
    var body: some View {
            NavigationView {
                VStack(alignment: .leading) {

                    HStack {
                        Button(action: {
                                
                            // Call the function to save the data to Firestore
                            saveItineraryToFirestore()
                            
                            if let user = Auth.auth().currentUser {
                               let db = Firestore.firestore()
                               let userId = user.uid
                               
                               // Reference the user's document in Firestore
                               let userRef = db.collection("users").document(userId)
                               
                               // Add the new itinerary ID to the user's array of itinerary IDs
                               userRef.updateData([
                                "itineraryIDs": FieldValue.arrayUnion([itinerary.id])
                               ]) { error in
                                   if let error = error {
                                       print("Error updating user document: \(error)")
                                   } else {
                                       print("User document updated with itinerary ID")
                                   }
                               }
                           }
                        }) {
                            Text("Save Itinerary")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                        }
                        .background(Color(red: 0.8, green: 0.4, blue: 0.0))
                        .cornerRadius(10)
                        .disabled(disableSave)

                        Spacer()

                        Button(action: {
                            saveAsPDF()
                        }) {
                            Image(systemName: "arrow.down.to.line.alt")
                                .font(.title)
                                .foregroundColor(Color(red: 242/255, green: 184/255, blue: 125/255))
                        }
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        .accessibilityIdentifier("SaveAsPDF")
                    }

                    Picker("Day", selection: $selectedDayIndex) {
                        ForEach(0..<itinerary.plan.count, id: \.self) { dayIndex in
                            Text("Day \(dayIndex + 1)").tag(dayIndex)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .accessibilityIdentifier("DayPicker")


                    ScrollView {
                        Text("Total Time: \(formatTourDuration(selectedDayIndex < itinerary.tourDuration.count ? itinerary.tourDuration[selectedDayIndex] : 0.0))")
                            .font(.title)
                            .foregroundColor(Color(red: 0.42, green: 0.56, blue: 0.5))


                        ForEach(itinerary.plan[selectedDayIndex].indices, id: \.self) { index in
                            HStack(alignment: .top, spacing: 10) {
                                Text("\(index + 1).")
                                    .font(.title3)
                                Text(itinerary.plan[selectedDayIndex][index].name)
                                    .font(.title3)
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                        }
                    }.accessibilityIdentifier("Attractions")


                    Picker("Map Mode", selection: $selectedMapMode) {
                        Text("Car").tag(MapMode.car)
                        Text("Walk").tag(MapMode.walk)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .accessibilityIdentifier("MapPicker")


                    // Display Map
                    MapView(directions: $directions, selectedMapMode: selectedMapMode, attractions: itinerary.plan[selectedDayIndex], selectedDayIndex: selectedDayIndex)
                        .frame(height: 300)

                    Spacer()

                    Button(action: {
                        showMapsAlert = true
                    }) {
                        HStack {
                            Image("apple_maps_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                            Image("google_maps_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)

                            Text("Open in External Maps")
                                .font(.title2)
                                .foregroundColor(Color(red: 0.8, green: 0.4, blue: 0.0))
                            
                        }
                    }
                    .padding()
                    .cornerRadius(10)
                    .alert(isPresented: $showMapsAlert) {
                        Alert(
                            title: Text("Choose a Map App"),
                            message: Text("Open the location in Google Maps or Apple Maps?"),
                            primaryButton: .default(Text("Google Maps")) {
                                openGoogleMaps(forDay: selectedDayIndex)
                            },
                            secondaryButton: .default(Text("Apple Maps")) {
                                openAppleMaps()
                            })
                    }
                }
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

        let pdfURL = documentsDirectory.appendingPathComponent("MyPlan.pdf")

        do {
            try pdfData.write(to: pdfURL)
            return pdfURL
        } catch {
            print("Error saving PDF: \(error.localizedDescription)")
            return nil
        }
    }
    
    func openGoogleMaps(forDay dayIndex: Int) {
        if itinerary.plan[selectedDayIndex].isEmpty {
            // Handle the case where there are no attractions in the plan
            // You can show an alert or display a message in your view.
            return
        }

        if itinerary.plan[selectedDayIndex].count == 1 {
            // If there's only one attraction, open Google Maps for that location
            let attraction = itinerary.plan[selectedDayIndex][0]
            let location = "\(attraction.lat),\(attraction.long)"
            let urlString = "https://www.google.com/maps?q=\(location)"
            
            if let url = URL(string: urlString) {
                onGenerateURL?(url, dayIndex)
                openURL(url)
            }
        } else {
            // If there are multiple attractions, set the last attraction as the destination
            let originAttraction = itinerary.plan[selectedDayIndex][0]
            let originLocation = "\(originAttraction.lat),\(originAttraction.long)"

            let waypoints = itinerary.plan[selectedDayIndex].dropFirst().map { attraction in
                return "\(attraction.lat),\(attraction.long)"
            }

            let originParam = "origin=\(originLocation)"
            let waypointsParam = "waypoints=\(waypoints.joined(separator: "%7C"))"

            let lastAttraction = itinerary.plan[selectedDayIndex].last!
            let lastLocation = "\(lastAttraction.lat),\(lastAttraction.long)"
            let destinationParam = "destination=\(lastLocation)"

            let urlString = "https://www.google.com/maps/dir/?api=1&\(originParam)&\(destinationParam)&\(waypointsParam)"
            
            if let url = URL(string: urlString) {
                onGenerateURL?(url, dayIndex)
                openURL(url)
            }
        }
    }


    func saveItineraryToFirestore() {
        let db = Firestore.firestore()
        
        // Create an array to store DocumentReferences for selectedAttractions
        var selectedAttractionRefs: [DocumentReference] = []
        
        // Iterate through the selectedAttractions array and get DocumentReferences
        for attraction in itinerary.selectedAttrs {
            let attractionRef = db.collection("attractions").document("attraction\(attraction.attractionId-1)")
            selectedAttractionRefs.append(attractionRef)
        }
        
        // Create an array to store references to plans
        var planAttractionRefs: [DocumentReference] = []
        
        for dayPlan in itinerary.plan {
            // Create an array to store references to attractions for each day's plan
            var dayPlanRefs: [DocumentReference] = []
            
            for attraction in dayPlan {
                let attractionRef = db.collection("attractions").document("attraction\(attraction.attractionId)")
                dayPlanRefs.append(attractionRef)
            }
            
            // Append the references to attractions for this day's plan
            planAttractionRefs.append(contentsOf: dayPlanRefs)
        }
        
        // Create a FirestoreItinerary struct with the necessary data
        let itineraryData: [String: Any] = [
            "id": itinerary.id, //pls work
            "itineraryName": itinerary.itineraryName, // Replace with your itinerary name
            "numberOfDays": itinerary.numberOfDays, // Replace with the number of days
            "tourDuration": itinerary.tourDuration, // Replace with your tour duration data
            "plan": planAttractionRefs, // Use the plan attraction references
            "selectedAttrs": selectedAttractionRefs // Use the selected attraction references
        ]
        
        let debugItinerary = ItineraryData(
                id: itinerary.id,
                itineraryName: itinerary.itineraryName,
                numberOfDays: itinerary.numberOfDays,
                tourDuration: itinerary.tourDuration,
                plan: itinerary.plan,
                selectedAttrs: itinerary.selectedAttrs
            )
        
        onSaveItinerary?(debugItinerary)

        // Add the itinerary data to Firestore
        db.collection("itineraries").document(itinerary.id).setData(itineraryData){error in
            if let error = error {
                print("Error adding itinerary: \(error)")
            } else {
                print("Itinerary added successfully")
            }
        }
    }
    
    func openAppleMaps() {
        if itinerary.plan[selectedDayIndex].count == 1 {
            
            // Display a single attraction on the map from the user's current location
            let attraction = itinerary.plan[selectedDayIndex][0]
            let location = CLLocationCoordinate2D(latitude: attraction.lat, longitude: attraction.long)
            let placemark = MKPlacemark(coordinate: location)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = attraction.name  // Set the attraction's name as the destination name

            let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: options)
        } else if itinerary.plan[selectedDayIndex].count > 1 {
            
            // Display multiple attractions on the map with default driving directions
            var waypoints: [MKMapItem] = []
            for attraction in itinerary.plan[selectedDayIndex] {
                let location = CLLocationCoordinate2D(latitude: attraction.lat, longitude: attraction.long)
                let placemark = MKPlacemark(coordinate: location)
                let mapItem = MKMapItem(placemark: placemark)
                waypoints.append(mapItem)
            }

            let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            MKMapItem.openMaps(with: waypoints, launchOptions: options)
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

struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView

    @Binding var directions: [MKDirections]
    var selectedMapMode: MapMode // Add selectedMapMode

    var attractions: [Attraction]
    var selectedDayIndex: Int

    func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(selectedMapMode: selectedMapMode) // Pass selectedMapMode to the coordinator
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
        context.coordinator.selectedMapMode = selectedMapMode

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
            
            // Calculate directions for the placemarks
            for i in 0..<placemarks.count - 1 {
                let sourcePlacemark = placemarks[i]
                let destinationPlacemark = placemarks[i + 1]

                let request = MKDirections.Request()
                request.source = MKMapItem(placemark: sourcePlacemark)
                request.destination = MKMapItem(placemark: destinationPlacemark)
                
                switch selectedMapMode {
                   case .car:
                       request.transportType = .automobile
                   case .walk:
                       request.transportType = .walking
                   }

                let directions = MKDirections(request: request)
                    directions.calculate { response, error in
                        guard let route = response?.routes.first else {
                            return
                        }
                        
                        uiView.delegate = context.coordinator
                        uiView.addAnnotations([sourcePlacemark, destinationPlacemark])
                        uiView.addOverlay(route.polyline)
                        
                        uiView.setVisibleMapRect(
                            route.polyline.boundingMapRect,
                            edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                            animated: true
                        )
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
        var selectedMapMode: MapMode // Add selectedMapMode property
        init(selectedMapMode: MapMode) {
            self.selectedMapMode = selectedMapMode // Initialize the selectedMapMode property
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            if(selectedMapMode == .walk){
                let renderer = MKPolylineRenderer(overlay: overlay)
                renderer.strokeColor = .black
                renderer.lineWidth = 3
                renderer.lineDashPattern = [1, 5]
                return renderer
            } else {
                let renderer = MKPolylineRenderer(overlay: overlay)
                renderer.strokeColor = .systemBlue
                return renderer
            }
        }
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
        
        let pdfView = PDFItineraryView(plan: itinerary.plan, tourDuration: itinerary.tourDuration)
        
        // Capture a screenshot of the SwiftUI view
        let uiImage = pdfView.asImage()

        // Create a PDF document
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRect(x: 0, y: 0, width: uiImage.size.width, height: uiImage.size.height), nil)

        UIGraphicsBeginPDFPage()
        uiImage.draw(in: CGRect(x: 0, y: 0, width: uiImage.size.width, height: uiImage.size.height))

        UIGraphicsEndPDFContext()

        return pdfData as Data
    }
}

struct PDFItineraryView: View {
    var plan: [[Attraction]]
    var tourDuration: [Double]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(plan.indices, id: \.self) { dayIndex in
                DayView(dayIndex: dayIndex + 1, attractions: plan[dayIndex], hours: tourDuration[dayIndex])
            }
        }
    }
}

struct DayView: View {
    var dayIndex: Int
    var attractions: [Attraction]
    var hours: Double

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Day \(dayIndex)")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Text("(\(String(format: "%.2f", hours)) Hours)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            ForEach(attractions.indices) { attractionIndex in
                HStack {
                    Text("- \(attractions[attractionIndex].name)")
                    Spacer()
                }
                .padding(.leading, 20)
            }
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
    }
}

