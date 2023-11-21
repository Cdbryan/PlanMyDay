//
//  LoginUITests.swift
//  Plan My DayUITests
//
//  Created by Itzel Villanueva on 11/20/23.
//

import XCTest

final class LoginUITests: XCTestCase {
    
    //--BLACK BOX TESTING--//
    
    //Itzel Villanueva #1 - test ensures that when sign in with valid credentials it takes you to the home view page
    func testHomeViewValid() {
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
        let signOutButton = app.buttons["Sign Out"]
        XCTAssertTrue(signOutButton.waitForExistence(timeout: 10.0))
        
    }
    
    //Itzel Villanueva #2 - test ensures that if there is no valid credentials from firebase then it will stay in the sign in page
    func testInvalidPW() {
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
        passwordTextField.typeText("09885")
        
        signInButton.tap()
        let signOutButton = app.buttons["Sign Out"]
        XCTAssertFalse(signOutButton.waitForExistence(timeout: 10.0))
        
    }
    
    //Itzel Villanueva #3 - tests the sign in button is enables only after user enters a 6 char long pw
    func testSignInButtonEnabled() throws {
        let app = XCUIApplication()
        app.launch()
        
        // sign in
        let emailTextField = app.textFields["emailTextField"]
        let passwordTextField = app.secureTextFields["passwordTextField"]
        let signInButton = app.buttons["Sign In"]
        
        emailTextField.tap()
        emailTextField.typeText("itzelvil@usc.edu")
        
        passwordTextField.tap()
        passwordTextField.typeText("11")
        XCTAssertFalse(signInButton.isEnabled)
        
        // Tap the sign-in button
        signInButton.tap()
    }
    
    //Itzel Villanueva #4 - tests that the forgot password works
    func testForgotPW() {
        // Launch the app and navigate to the MapPageView
        let app = XCUIApplication()
        app.launch()
        
        //forgot pw
        let forgotPW = app.buttons["Forgot Password?"]
        forgotPW.tap()
        sleep(2)
        
        //enter email
        let emailRTextField = app.textFields["Enter Email"]
        emailRTextField.tap()
        emailRTextField.typeText("itzelvil@usc.edu")
        
        //reset
        let resetButton = app.buttons["Reset Password"]
        resetButton.tap()
        sleep(2)
        
    }
    
    //Itzel Villanueva #5 - tests that a new user can be created
    func testNewUserSucess() {
        // Launch the app and navigate to the MapPageView
        let app = XCUIApplication()
        app.launch()
        
        //sign up --> change every time run!!
        let signUp = app.buttons["Don't have an account?, Sign Up"]
        signUp.tap()
        sleep(2)
        
        let emailTextField = app.textFields["Enter Email"]
        let fullNameTextField = app.textFields["Enter Your Name"]
        let securityQuestionTextField = app.textFields["What city were you born in?"]
        let passwordTextField = app.textFields["Minimum 6 Characters"]
        let confirmPasswordTextField = app.textFields["Confirm Password"]
        
        emailTextField.tap()
        emailTextField.typeText("cr7@gmail.com")
        
        fullNameTextField.tap()
        fullNameTextField.typeText("CR7")
        
        securityQuestionTextField.tap()
        securityQuestionTextField.typeText("Lisbon\t")
        
        passwordTextField.tap()
        passwordTextField.typeText("1234567")
        
        confirmPasswordTextField.tap()
        confirmPasswordTextField.typeText("1234567\n")
        
        
        let signUpButton = app.buttons["Sign Up"]
        signUpButton.tap()
        sleep(5)
    }
    
    //Alysha Kanjiyani #1 - tests new user cant be created with same email already in db
    func testNewUserUnsucess() {
        // Launch the app and navigate to the MapPageView
        let app = XCUIApplication()
        app.launch()
        
        //sign up
        let signUp = app.buttons["Don't have an account?, Sign Up"]
        signUp.tap()
        sleep(2)
        
        let emailTextField = app.textFields["Enter Email"]
        let fullNameTextField = app.textFields["Enter Your Name"]
        let securityQuestionTextField = app.textFields["What city were you born in?"]
        let passwordTextField = app.textFields["Minimum 6 Characters"]
        let confirmPasswordTextField = app.textFields["Confirm Password"]
        
        emailTextField.tap()
        emailTextField.typeText("cr7@gmail.com")
        
        fullNameTextField.tap()
        fullNameTextField.typeText("CR7")
        
        securityQuestionTextField.tap()
        securityQuestionTextField.typeText("Lisbon")
        
        passwordTextField.tap()
        passwordTextField.typeText("1234567")
        
        confirmPasswordTextField.tap()
        confirmPasswordTextField.typeText("1234567\n")
        
        
        let signUpButton = app.buttons["Sign Up"]
        signUpButton.tap()
        sleep(5)
        
        XCTAssertTrue(app.alerts["Sign-Up Unsuccessful"].exists)
    }
    
    //Alysha Kanjiyani #2 - ensure that plus button to view the list of attractions
    func testAttractionsPageNav() {
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
        
        //plus
        let plusButton = app.buttons["plus"]
        plusButton.tap()
    }
    
    //Alysha Kanjiyani #3 - Test to see if you can navigate to the page where you can choose attractions
    func testSelectAttractions() {
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
        
        //plus
        let plusButton = app.buttons["plus"]
        plusButton.tap()
        
        //Select Attractions
        let sa = app.buttons["Select Attractions"]
        sa.tap()
        
        
    }

    
    //Alysha Kanjiyani #4 - Test to see if you can cancel selected attraction to look at attreaction details
    func testCancelAttractions() {
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
        
        //plus
        let plusButton = app.buttons["plus"]
        plusButton.tap()
        
        //Select Attractions
        let sa = app.buttons["Select Attractions"]
        sa.tap()
        
        //select cancel
        let cancel = app.buttons["Cancel"]
        cancel.tap()
    }
    
    //Alysha Kanjiyani #5 - Test to see if you can go to next page to select number of days for trip
    func testDays() {
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
        
        //plus
        let plusButton = app.buttons["plus"]
        plusButton.tap()
        
        //Select Attractions
        let sa = app.buttons["Select Attractions"]
        sa.tap()
        
        //select next
        let next = app.buttons["Next"]
        next.tap()
        sleep(2)
    }
    
    
}
