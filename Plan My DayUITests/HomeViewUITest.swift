//
//  HomeViewUITest.swift
//  Plan My DayUITests
//
//  Created by Christian Bryan on 11/20/23.
//

import XCTest

final class HomeViewUITest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHomeViewLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric(waitUntilResponsive: true)]) {
                let app = XCUIApplication()
                app.launch()

                // Navigate to the HomeView after launching the app
                // Adjust this part based on your app's navigation flow
                // For example, if HomeView is the root view controller, you may not need this
                let emailTextField = app.textFields["emailTextField"]
                let passwordTextField = app.secureTextFields["passwordTextField"]
                let signInButton = app.buttons["Sign In"]

                emailTextField.tap()
                emailTextField.typeText("TestUser@gmail.com")

                passwordTextField.tap()
                passwordTextField.typeText("123456")

                signInButton.tap()
            }
        }

    func testUIElementsVisibility() {
        let app = XCUIApplication()
        app.launch()
        
        
        // Enter the test user credentials
        let emailTextField = app.textFields["emailTextField"]
        let passwordTextField = app.secureTextFields["passwordTextField"]
        let signInButton = app.buttons["Sign In"]

        emailTextField.tap()
        emailTextField.typeText("TestUser@gmail.com")

        passwordTextField.tap()
        passwordTextField.typeText("123456")

        // Tap the sign-in button
        signInButton.tap()

        // Verify the visibility of important UI elements
        XCTAssertTrue(app.staticTexts["MyTripsIdentifier"].waitForExistence(timeout: 20))
        
    }
    
    func testLoginAndNavigateToHomeView() {
        let app = XCUIApplication()
        app.launch()

        // Enter the test user credentials
        let emailTextField = app.textFields["emailTextField"]
        let passwordTextField = app.secureTextFields["passwordTextField"]
        let signInButton = app.buttons["Sign In"]

        emailTextField.tap()
        emailTextField.typeText("TestUser@gmail.com")

        passwordTextField.tap()
        passwordTextField.typeText("123456")

        // Tap the sign-in button
        signInButton.tap()

        
        let collectionView = app.collectionViews["itineraryList"]
        XCTAssertTrue(collectionView.waitForExistence(timeout: 10), "CollectionView did not appear within 10 seconds")
        print(app.debugDescription)
    }
    
    func testSignOut() {
        let app = XCUIApplication()
        app.launch()

        // Enter the test user credentials
        let emailTextField = app.textFields["emailTextField"]
        let passwordTextField = app.secureTextFields["passwordTextField"]
        let signInButton = app.buttons["Sign In"]

        emailTextField.tap()
        emailTextField.typeText("TestUser@gmail.com")

        passwordTextField.tap()
        passwordTextField.typeText("123456")

        // Tap the sign-in button
        signInButton.tap()

        // Tap on the "Sign Out" button
        let signOutButton = app.buttons["Sign Out"]
        signOutButton.tap()

        // Verify that the app returns to the login screen
        XCTAssertTrue(app.textFields["emailTextField"].waitForExistence(timeout: 10), "Failed to sign out")
    }
    
    func testScrollItineraryList() {
        let app = XCUIApplication()
        app.launch()

        // Enter the test user credentials
        let emailTextField = app.textFields["emailTextField"]
        let passwordTextField = app.secureTextFields["passwordTextField"]
        let signInButton = app.buttons["Sign In"]

        emailTextField.tap()
        emailTextField.typeText("TestUser@gmail.com")

        passwordTextField.tap()
        passwordTextField.typeText("123456")

        // Tap the sign-in button
        signInButton.tap()

        // Verify the visibility of the itinerary list
        XCTAssertTrue(app.collectionViews["itineraryList"].waitForExistence(timeout: 10), "CollectionView did not appear within 10 seconds")

        // Scroll the itinerary list
        let collectionView = app.collectionViews["itineraryList"]
        collectionView.swipeUp()
    }
}
