//
//  LoginUITests.swift
//  Plan My DayUITests
//
//  Created by Itzel Villanueva on 11/20/23.
//

import XCTest

final class LoginUITests: XCTestCase {
    
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
    
    func testNewUser() {
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
        securityQuestionTextField.typeText("Lisbon\t")

        passwordTextField.tap()
        passwordTextField.typeText("1234567")

        confirmPasswordTextField.tap()
        confirmPasswordTextField.typeText("1234567\n")
        

        let signUpButton = app.buttons["Sign Up"]
        signUpButton.tap()
        sleep(5)

        
    }
}
