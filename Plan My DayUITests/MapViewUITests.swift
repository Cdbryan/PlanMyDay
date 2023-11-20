import XCTest

class MapPageViewUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        // Launch the app
        app = XCUIApplication()
        app.launch()

        // Sign in
        let emailTextField = app.textFields["emailTextField"]
        let passwordTextField = app.secureTextFields["passwordTextField"]
        let signInButton = app.buttons["Sign In"]

        emailTextField.tap()
        emailTextField.typeText("itzelvil@usc.edu")

        passwordTextField.tap()
        passwordTextField.typeText("123456")

        signInButton.tap()

        // Navigate to mapView
        let collectionView = app.collectionViews["itineraryList"]
        let firstCell = collectionView.cells.element(boundBy: 0)
        let button = firstCell.buttons["2023-11-06"]
        button.tap()
    }

    override func tearDownWithError() throws {
        // Additional teardown code here.
    }

    // Written By Josheta Srinivasan
    func testInitialState() {
        // Add assertions to check UI components
        XCTAssertTrue(app.buttons["Save Itinerary"].exists, "Save Itinerary button should exist")
        XCTAssertTrue(app.buttons["SaveAsPDF"].exists, "Save PDF should exist")
        XCTAssertTrue(app.segmentedControls["DayPicker"].exists, "Day Segmented Control should exist")
        XCTAssertTrue(app.segmentedControls["MapPicker"].exists, "Transportation Segmented Control should exist")
        XCTAssertTrue(app.scrollViews["Attractions"].exists, "Attractions ScrollView should exist")
        XCTAssertTrue(app.staticTexts["Open in External Maps"].exists, "Open Map should exist")
        XCTAssertNotEqual(app.maps.count, 0)
    }
    
    // Written By Josheta Srinivasan
    func testOpenAppleMaps() {
        app.staticTexts["Open in External Maps"].tap()
        app.buttons["Apple Maps"].tap()
        
        // Add assertion to check if Apple Maps app is active
        let appleMapsApp = XCUIApplication(bundleIdentifier: "com.apple.Maps")
        XCTAssertTrue(appleMapsApp.waitForExistence(timeout: 5), "Apple Maps should be launched")
    }
    
    // Written By Josheta Srinivasan
    func testOpenGoogleMaps() {
        app.staticTexts["Open in External Maps"].tap()
        app.buttons["Google Maps"].tap()
        
        // Add assertion to check if Google Maps app is active
        let safariApp = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
        XCTAssertTrue(safariApp.waitForExistence(timeout: 5), "Google Maps in Safari should be launched")
    }
     
    
    // Written By Josheta Srinivasan
    func testConvertToPDF() {
        app.buttons["SaveAsPDF"].tap()
        XCTAssertNotEqual(app.otherElements.count, 0, "PDF should be generated")
    }
    
    // Written By Josheta Srinivasan
    func testPickerUpdatesMapView(){
        // Get a reference to the MapView before picker interaction
        var mapViewBeforeInteraction = app.maps.firstMatch
        
        // Interact with the pickers, for example, changing the selected day
        app.segmentedControls["DayPicker"].buttons["Day 2"].tap()
        
        // Get a reference to the MapView after picker interaction
        var mapViewAfterInteraction = app.maps.firstMatch
        
        // Assert that the MapView has been updated
        XCTAssertNotEqual(mapViewBeforeInteraction.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)),
                          mapViewAfterInteraction.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)),
                          "MapView should be updated after picker interaction")
        
        // Get a reference to the MapView before picker interaction
        mapViewBeforeInteraction = mapViewAfterInteraction
        
        // Interact with the pickers, for example, changing the selected day
        app.segmentedControls["MapPicker"].buttons["Walk"].tap()
        
        // Get a reference to the MapView after picker interaction
        mapViewAfterInteraction = app.maps.firstMatch
        
        // Assert that the MapView has been updated
        XCTAssertNotEqual(mapViewBeforeInteraction.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)),
                          mapViewAfterInteraction.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)),
                          "MapView should be updated after picker interaction")
    }
    
    
    

}


