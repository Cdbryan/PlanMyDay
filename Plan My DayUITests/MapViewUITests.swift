import XCTest

class MapPageViewUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        // Additional setup code here.
    }

    override func tearDownWithError() throws {
        // Additional teardown code here.
    }

    func testSaveItinerary() throws {
        // Launch the app and navigate to the MapPageView
        let app = XCUIApplication()
        app.launch()

        // sign in
        let emailTextField = app.textFields["emailTextField"]
        let passwordTextField = app.secureTextFields["passwordTextField"]
        let signInButton = app.buttons["Sign In"]
        
        emailTextField.tap()
        emailTextField.typeText("itzelvil@usc.edu")

        passwordTextField.tap()
        passwordTextField.typeText("123456")

        signInButton.tap()

        
//        let username = app.textFields["tommyT11@usc.edu"]
//       // Type "Hello, World!" into the text field
//        username.tap()
//        username.typeText("jsriniva@usc.edu")
//
//        let password = app.textFields["Enter Password"]
//        // Type "Hello, World!" into the text field
//        password.tap()
//        password.typeText("098765")
//        app.buttons["Sign In"].tap()


        // Perform actions on the MapPageView, e.g., tap the "Save Itinerary" button
//        app.buttons["Sign In"].tap()
//        app.buttons["Save Itinerary"].tap()

        // Add assertions to verify the expected behavior after tapping the button
        // For example, you can check if a save confirmation message is displayed
//        XCTAssertTrue(app.staticTexts["Itinerary saved successfully"].exists)
    }

    func testOpenExternalMaps() throws {
        // Launch the app and navigate to the MapPageView
        let app = XCUIApplication()
        app.launch()

        // Perform actions on the MapPageView, e.g., tap the "Open in External Maps" button
        app.buttons["Open in External Maps"].tap()

        // Add assertions to verify the expected behavior after tapping the button
        // For example, you can check if the map app chooser alert is displayed
        XCTAssertTrue(app.alerts["Choose a Map App"].exists)
    }

    // Add more test cases as needed...

}


