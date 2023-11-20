import XCTest
import MapKit
@testable import Plan_My_Day // Replace with your actual app module name

let attractionList = [
    Attraction(attractionId: 1, name: "USC Village", location: "USC", isUSC: true, lat: 34.0268515, long: -118.2878486, hours: ["9:00 AM - 10:00 PM"], desc: "The USC Village provides our freshmen and sophomore Trojans a built-in community from the moment they arrive, fostering the success of USC students during their time at the university. It features a range of shops, amenities and dining options, open to USC’s community and neighbors."),
    Attraction(attractionId: 2, name: "Equad", location: "USC", isUSC: true, lat: 34.021007, long: -118.2891249, hours: ["9:00 AM - 10:00 PM"], desc: "The Engineering Quad is the heart of the Viterbi School of Engineering. It has many new lounge areas and tables to eat and do work on a nice day in LA."),
    Attraction(attractionId: 3, name: "School of Cinematic Arts", location: "USC", isUSC: true,  lat: 34.0240968, long: -118.2886852, hours: ["9:00 AM - 10:00 PM"], desc: "The School of Cinematic Arts is divided into seven divisions that work together to train the leaders, scholars and media makers of tomorrow. It is by far, one of the prettiest buildings on campus with a Coffee Bean located inside."),
    Attraction(attractionId: 4, name: "LA Memorial Coliseum", location: "USC", isUSC: true, lat: 34.0136691, long: -118.2904104, hours: ["9:00 AM - 10:00 PM"], desc: "The home of the USC Trojans and also known as the Greatest Stadium in the World. It serves as a living memorial to all who served in the U.S. Armed Forces during World War I. The Coliseum has been a civic treasure for generations of Angelenos."),
    Attraction(attractionId: 5, name: "Marshall School of Business", location: "USC", isUSC: true, lat: 34.0188441, long: -118.2883342, hours: ["9:00 AM - 10:00 PM"], desc: "USC Marshall School of Business is one of the world's leading global undergraduate business programs. It is one of the most popular buildings on campus for business and non-business majors alike.")
]

class MapPageViewTests: XCTestCase {

    var mockItinerary: Itinerary!

    override func setUp() {
        super.setUp()

        // Create a mock itinerary with the specified plan and tour duration
        let plan: [[Attraction]] = [
            [attractionList[0], attractionList[1], attractionList[2]],
            [attractionList[3], attractionList[4]]
        ]

        let tourDuration: [Double] = [0.75, 0.5]

        mockItinerary = Itinerary(itineraryName: "Mock Itinerary", attractions: [], numberOfDays: 2, tourDuration: tourDuration, plan: plan)
    }
    
    // TEST 1: APPLE MAPS
    func testOpenAppleMaps() {
        // Create a mock itinerary for testing
        let mapView = MapPageView(itinerary: mockItinerary, disableSave: false)

        for dayIndex in 0..<mockItinerary.numberOfDays {
            // Set the selected day index
            mapView.debugSelectedDayIndex = dayIndex
            XCTAssertEqual(mapView.itinerary.plan[mapView.debugSelectedDayIndex][0].name, attractionList[0].name)

            // Call the openAppleMaps function
            mapView.openAppleMaps() // calls asserts in MockMapItem
        }
    }
    
    // TEST 2: GOOGLE MAPS
    func testOpenGoogleMaps() {
        // Create a variable to capture the generated URL
        var capturedURLs: [(URL, Int)] = []
        let expectedURLStrings = ["https://www.google.com/maps/dir/?api=1&origin=34.0268515,-118.2878486&destination=34.0240968,-118.2886852&waypoints=34.021007,-118.2891249%7C34.0240968,-118.2886852", "https://www.google.com/maps/dir/?api=1&origin=34.0268515,-118.2878486&destination=34.0240968,-118.2886852&waypoints=34.021007,-118.2891249%7C34.0240968,-118.2886852"]
        
        // Create a mock MapPageView with the onGenerateURL closure
        let mapView = MapPageView(onGenerateURL: { url, dayIndex in
            capturedURLs.append((url, dayIndex))
        }, itinerary: mockItinerary, disableSave: false)
        
        // Iterate over all days in the itinerary
        for dayIndex in 0..<mapView.itinerary.numberOfDays {
            // Set the selected day index
            mapView.debugSelectedDayIndex = dayIndex

            // Call the openGoogleMaps function
            mapView.openGoogleMaps(forDay: dayIndex)
        }
        
        // Assert on capturedURLs as needed
        for (index, capturedURL) in capturedURLs.enumerated() {
            
            let expectedURLString = expectedURLStrings[index]
            
            XCTAssertEqual(capturedURL.0.absoluteString, expectedURLString, "Generated URL for day \(capturedURL.1) should match the expected URL")
        }
    }
}

// Protocol representing the functionalities needed from MKMapItemhttps://www.google.com/maps/dir/?api=1&origin=34.0268515,-118.2878486&destination=34.0240968,-118.2886852&waypoints=34.021007,-118.2891249%7C34.0240968,-118.2886852
protocol MKMapItemProtocol {
    var placemark: MKPlacemark { get }
    func openMaps(with waypoints: [MKMapItemProtocol], launchOptions options: [String: Any]?)
}

// Mock class conforming to MKMapItemProtocol
class MockMKMapItem: MKMapItemProtocol {
    var placemark: MKPlacemark {
        return MKPlacemark(coordinate: CLLocationCoordinate2D())
    }

    var openMapsIsCalledWith: ([MKMapItemProtocol], [String: Any]?) -> Void = { waypoints, _ in
        // Add assertions to check properties of each waypoint
        for waypoint in waypoints {
            XCTAssertNotNil(waypoint.placemark, "Placemark should not be nil")
        }
        
        for (index, waypoint) in waypoints.enumerated() {
            let expectedLat = attractionList[index].lat
            let expectedLong = attractionList[index].long
            XCTAssertEqual(waypoint.placemark.coordinate.latitude, expectedLat, "Latitude of waypoint \(index) should match")
            XCTAssertEqual(waypoint.placemark.coordinate.longitude, expectedLong, "Longitude of waypoint \(index) should match")
        }
        
        
    }

    // Initializer to conform to MKMapItemProtocol
    init() {}
    func openMaps(with waypoints: [MKMapItemProtocol], launchOptions options: [String: Any]?) {
        // Capture the parameters for openMaps
        openMapsIsCalledWith(waypoints, options)
    }
}

protocol URLOpenable {
    func open(_ url: URL)
}
class MockURLOpener: URLOpenable {
    var openedURL: URL?

    func open(_ url: URL) {
        openedURL = url
    }
}
