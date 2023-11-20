//
//  LoginUITests.swift
//  Plan My DayUITests
//
//  Created by Itzel Villanueva on 11/20/23.
//

import XCTest

final class LoginUITests: XCTestCase {

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
}
