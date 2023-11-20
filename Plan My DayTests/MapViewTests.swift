//// Written by Josheta Srinivasan
//
//import XCTest
//import SwiftUI
//import MapKit
//@testable import Plan_My_Day
//
//class MapPageViewTests: XCTestCase {
//
//    func testSaveItineraryToFirestore() {
//        let mockItinerary = /* create a mock Itinerary with necessary data */
//        var mapView = MapPageView(itinerary: mockItinerary, disableSave: false)
//
//        let mockFirestore = MockFirestore()
//        mapView.firestore = mockFirestore
//
//        mapView.saveItineraryToFirestore()
//
//        XCTAssertTrue(mockFirestore.collectionCalled)
//        XCTAssertTrue(mockFirestore.collectionPath == "itineraries")
//
//        XCTAssertTrue(mockFirestore.documentCalled)
//        XCTAssertTrue(mockFirestore.documentPath == mockItinerary.id)
//
//        XCTAssertTrue(mockFirestore.setDataCalled)
//        XCTAssertTrue(mockFirestore.setDataData != nil)
//    }
//
//    func testSaveAsPDF() {
//        let mockItinerary = /* create a mock Itinerary with necessary data */
//        var mapView = MapPageView(itinerary: mockItinerary, disableSave: false)
//
//        let mockUIActivityViewController = MockUIActivityViewController()
//        let mockUIApplication = MockUIApplication()
//        mapView.uiActivityViewController = mockUIActivityViewController
//        mapView.uiApplication = mockUIApplication
//
//        mapView.saveAsPDF()
//
//        XCTAssertTrue(mockUIActivityViewController.initCalled)
//        XCTAssertTrue(mockUIApplication.openCalled)
//    }
//
//    func testOpenGoogleMaps() {
//        let mockItinerary = /* create a mock Itinerary with necessary data */
//        var mapView = MapPageView(itinerary: mockItinerary, disableSave: false)
//        mapView.selectedDayIndex = 0
//
//        let mockUIApplication = MockUIApplication()
//        mapView.openURL = { (url: URL) in // Explicitly specify the type of 'url'
//            XCTAssertTrue(url.absoluteString == "https://www.google.com/maps?q=\(mockItinerary.plan[0][0].lat),\(mockItinerary.plan[0][0].long)")
//        }
//
//        mapView.openGoogleMaps()
//    }
//
//    func testOpenAppleMaps() {
//        let mockItinerary = /* create a mock Itinerary with necessary data */
//        var mapView = MapPageView(itinerary: mockItinerary, disableSave: false)
//        mapView.selectedDayIndex = 0
//
//        let mockMKMapItem = MockMKMapItem()
//        mapView.openInMaps = { mapItems, options in
//            XCTAssertTrue(mapItems.count == 1)
//            XCTAssertTrue(mapItems[0].placemark.coordinate.latitude == mockItinerary.plan[0][0].lat)
//            XCTAssertTrue(mapItems[0].placemark.coordinate.longitude == mockItinerary.plan[0][0].long)
//        }
//
//        mapView.openAppleMaps()
//    }
//
//    func testMapViewUpdate() {
//        let mockItinerary = /* create a mock Itinerary with necessary data */
//        var mapView = MapPageView(itinerary: mockItinerary, disableSave: false)
//        mapView.selectedDayIndex = 0
//
//        let mockMapView = MockMapView()
//        let coordinator = mapView.makeCoordinator()
//        coordinator.selectedMapMode = .car
//        coordinator.mapView(mockMapView, rendererFor: MKPolyline())
//
//        XCTAssertTrue(mockMapView.removeOverlaysCalled)
//        XCTAssertTrue(mockMapView.removeAnnotationsCalled)
//        XCTAssertTrue(mockMapView.addOverlayCalled)
//        XCTAssertTrue(mockMapView.addAnnotationsCalled)
//        XCTAssertTrue(mockMapView.setRegionCalled)
//    }
//}
//
//// Mock classes
//class MockFirestore: FirestoreProtocol {
//    var collectionCalled = false
//    var collectionPath: String?
//    var documentCalled = false
//    var documentPath: String?
//    var setDataCalled = false
//    var setDataData: [String: Any]?
//
//    func collection(_ collectionPath: String) -> DocumentReferenceProtocol {
//        self.collectionCalled = true
//        self.collectionPath = collectionPath
//        return MockDocumentReference()
//    }
//}
//
//class MockDocumentReference: DocumentReferenceProtocol {
//    func document(_ documentPath: String) -> DocumentReferenceProtocol {
//        return MockDocumentReference()
//    }
//
//    func setData(_ documentData: [String: Any], completion: ((Error?) -> Void)?) {
//        setDataCalled = true
//        setDataData = documentData
//        completion?(nil)
//    }
//}
//
//class MockUIActivityViewController: UIActivityViewController {
//    var initCalled = false
//
//    override init(activityItems: [Any], applicationActivities: [UIActivity]?) {
//        super.init(activityItems: activityItems, applicationActivities: applicationActivities)
//        initCalled = true
//    }
//}
//
//class MockUIApplication: UIApplicationProtocol {
//    var openCalled = false
//
//    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any], completionHandler completion: ((Bool) -> Void)?) {
//        openCalled = true
//        completion?(true)
//    }
//}
//
//class MockMapView: MKMapView {
//    var removeOverlaysCalled = false
//    var removeAnnotationsCalled = false
//    var addOverlayCalled = false
//    var addAnnotationsCalled = false
//    var setRegionCalled = false
//
//    override func removeOverlays(_ overlays: [MKOverlay]) {
//        removeOverlaysCalled = true
//    }
//
//    override func removeAnnotations(_ annotations: [MKAnnotation]) {
//        removeAnnotationsCalled = true
//    }
//
//    override func addOverlay(_ overlay: MKOverlay) {
//        addOverlayCalled = true
//    }
//
//    override func addAnnotations(_ annotations: [MKAnnotation]) {
//        addAnnotationsCalled = true
//    }
//
//    override func setRegion(_ region: MKCoordinateRegion, animated: Bool) {
//        setRegionCalled = true
//    }
//}
//
