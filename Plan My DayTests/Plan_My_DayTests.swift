import XCTest
@testable import Plan_My_Day
import Firebase
import FirebaseFirestore
//import FirebaseAuth

final class Plan_My_DayTests: XCTestCase {
    
    var authViewModel: AuthViewModel!
    @MainActor
    override func setUp() {
        super.setUp()
        authViewModel = AuthViewModel()
    }
    @MainActor
    // White-box testing
    func testValidateCredentials() async {
        // Valid credentials
        let validEmail = "itzelvil@usc.edu"
        let validPassword = "123456"
        
        // Invalid credentials
        let invalidEmail = "invalid@example.com"
        let invalidPassword = "invalidPassword"
        
        do {
            // Test valid credentials
            let validUser = try await authViewModel.validateCredentials(email: validEmail, password: validPassword)
            XCTAssertNotNil(validUser, "Valid credentials should return a user")
            
            // Test invalid credentials
            let invalidUser = try await authViewModel.validateCredentials(email: invalidEmail, password: invalidPassword)
            XCTAssertNil(invalidUser, "Invalid credentials should return nil")
        } catch {
            XCTFail("Unexpected error during credential validation: \(error.localizedDescription)")
        }
    }
    @MainActor
    func testValidateCredentialsWithInvalidPassword() async {
        // Provide valid email and invalid password for testing
        let email = "leoMessi@testing.com"
        let password = "yourMom"
        
        do {
            // Attempt to validate the provided email and invalid password
            let result = try await authViewModel.validateCredentials(email: email, password: password)
            XCTAssertNil(result, "User should not be validated with an invalid password")
        } catch {
            XCTFail("Unexpected error during credentials validation: \(error.localizedDescription)")
        }
    }
    @MainActor
    func testValidateCredentialsWithEmptyPassword() async {
        // Provide valid email with an empty password for testing
        let email = "test@example.com"
        let password = ""
        
        do {
            // Attempt to validate the provided email with an empty password
            let result = try await authViewModel.validateCredentials(email: email, password: password)
            XCTAssertNil(result, "User should not be validated with an empty password")
        } catch {
            XCTFail("Unexpected error during credentials validation: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func testValidateCredentialsWithEmptyEmail() async {
        // Provide an empty email with a valid password for testing
        let email = ""
        let password = "123456"
        
        do {
            // Attempt to validate an empty email with the provided password
            let result = try await authViewModel.validateCredentials(email: email, password: password)
            XCTAssertNil(result, "User should not be validated with an empty email")
        } catch {
            XCTFail("Unexpected error during credentials validation: \(error.localizedDescription)")
        }
    }
    @MainActor
    // Alysha Kanjiyani: Test for resetting password with valid email
        func testResetPassword() async {
            let validEmail = "kanjiyan@usc.edu"

            do {
                // Attempt to reset the password
                try await authViewModel.resetPassword(forEmail: validEmail)
                
                // Assert that the password reset request was successful (no errors thrown)
                XCTAssert(true, "Password reset request successful")

            } catch {
                // If an error occurs, fail the test with an error message
                XCTFail("Unexpected error during password reset: \(error.localizedDescription)")
            }
        }
    
    @MainActor
    // Alysha Kanjiyani: Test for creating a new user
        func testCreateUser() async {
            let validEmail = "newuser@example100.com"
            let validPassword = "newpassword"
            let validFullname = "John Doe"
            let validSecurityAnswer = "Security123"
            let validItineraryIDs = ["itinerary1", "itinerary2"]

            do {
                // Attempt to create a new user
                try await authViewModel.createUser(withEmail: validEmail, password: validPassword, fullname: validFullname, securityAnswer: validSecurityAnswer, itineraryIDs: validItineraryIDs)
                
                // Assert that the user creation was successful (no errors thrown)
                XCTAssert(true, "User creation successful")

            } catch {
                // If an error occurs, fail the test with an error message
                XCTFail("Unexpected error during user creation: \(error.localizedDescription)")
            }
        }

    @MainActor
    // Alysha Kanjiyani: Test the creating user with a pre-existing email
        func testCreateUserWithDuplicateEmail() async {
            let existingEmail = "kanjiyan@usc.edu"
            let password = "existingpassword"
            let fullname = "Jane Doe"
            let securityAnswer = "Security456"
            let itineraryIDs = ["itinerary3", "itinerary4"]

            do {
                // Attempt to create a new user with a pre-existing email
                try await authViewModel.createUser(withEmail: existingEmail, password: password, fullname: fullname, securityAnswer: securityAnswer, itineraryIDs: itineraryIDs)
                
                // If no error occurs, fail the test with a message
                XCTFail("User creation with duplicate email should fail, but no error was thrown")

            } catch let error as NSError {
                // Assert that the error is related to the email already being in use
                XCTAssertEqual(error.code, AuthErrorCode.emailAlreadyInUse.rawValue, "Expected error code for email already in use")

            }
        }
    
    @MainActor
    //Alysha Kanjiyani: Tests if user sign out functionality works
    func testSignOut() async {
            // Create an expectation
            let expectation = XCTestExpectation(description: "Sign out user")

            // Assume the user is already signed in
            authViewModel.userSession = Auth.auth().currentUser

            // Call the signOut function asynchronously
            await authViewModel.signOut()

            // Check if userSession is nil after signOut
            XCTAssertNil(authViewModel.userSession)

            // Check if currentUser is nil after signOut
            XCTAssertNil(authViewModel.currentUser)

            // Fulfill the expectation
            expectation.fulfill()

            // Wait for the expectation with a timeout
            wait(for: [expectation], timeout: 5.0)
        }
    
    @MainActor
    //Alysha Kanjiyani: Testing to check if it calulates the duration of the tours of each day properly
    func testTourDurationCalculation() {
        var tourDuration: [Double] = []
        let testAttractions: [Attraction] = [
            Attraction(attractionId: 1, name: "USC Village", location: "USC", isUSC: true, lat: 34.0268515, long: -118.2878486, hours: ["9:00 AM - 10:00 PM"], desc: "The USC Village provides our frehmen and sophomore Trojans a built-in community from the moment they arrive, fostering the success of USC students during their time at the university. It features a range of shops, amenities and dining options, open to USC’s community and neighbors."),
            Attraction(attractionId: 9, name: "El Matador State Beach Malibu", location: "Los Angeles", isUSC: false, lat: 34.03830929142738, long: -118.87470591899874, hours: ["8:00 AM - 8:00 PM"], desc: "El Matador Beach is one of three beaches within Robert H. Meyer Memorial State Beach. El Matador is the most popular of the three and located in Malibu."),
            Attraction(attractionId: 10, name: "LA Urban Lights", location: "Los Angeles", isUSC: false, lat: 34.06313901712488, long: -118.35924803248918, hours: ["Open 24 Hours"], desc: "This forest of city street lights, called Urban Light was created by artist Chris Burden.")
        ]

        let numberOfDays = 2
        let plan: [[Attraction]] = [
            [testAttractions[0], testAttractions[1]], // Day 1
            [testAttractions[2]]  // Day 2
        ]

        tourDuration = plan.map { day in
            return day.reduce(0.0) { total, attraction in
                return total + (attraction.isUSC ? 0.25 : 1.0)
            }
        }

        let itinerary = Itinerary(itineraryName: "Test Itinerary", attractions: testAttractions, numberOfDays: numberOfDays, tourDuration: tourDuration, plan: plan)

        print("Original plan: \(plan)")
        print("Calculated tour duration: \(itinerary.tourDuration)")

        XCTAssertEqual(itinerary.tourDuration, [1.25, 1.0])
        // Adjust the expected values based on your specific plan and attraction durations
    }

    



    
    //    var authViewModel: AuthViewModel!
    //
    //    @MainActor
    //    override func setUp() {
    //        super.setUp()
    //        authViewModel = AuthViewModel()
    //    }
    
    //    //--BLACK BOX TESTING--//
    //    @MainActor
    //    //#1 - testing login valid credentials
    //    func testSignInWithValidCredentials() async {
    //        //using my email and pw as the test
    //        let email = "itzelvil@usc.edu"
    //        let pw = "123456"
    //
    //        do {
    //            try await authViewModel.signIn(withEmail: email, password: pw)
    //            XCTAssertNotNil(authViewModel.userSession, "User session should not be nil after successful sign-in")
    //            XCTAssertTrue(authViewModel.isAuthenticated, "User should be authenticated after successful sign-in")
    //            XCTAssertNil(authViewModel.signInError, "Sign-in error should be nil after successful sign-in")
    //        } catch {
    //            XCTFail("Unexpected error during sign-in: \(error.localizedDescription)")
    //        }
    //    }
    //    @MainActor
    //    //#2 - testing login invalid credentials
    //    func testSignInWithInvalidCredentials() {
    //            let expectation = XCTestExpectation(description: "Sign in with invalid credentials")
    //
    //            let email = "itNoWork@mama.gov"
    //            let password = "yourMom"
    //
    //            Task {
    //                do {
    //                    try await authViewModel.signIn(withEmail: email, password: password)
    //                    XCTFail("Expected an error for invalid credentials")
    //                } catch {
    //                    XCTAssertNil(authViewModel.userSession, "User session should be nil after unsuccessful sign-in")
    //                    XCTAssertFalse(authViewModel.isAuthenticated, "User should not be authenticated after unsuccessful sign-in")
    //                    XCTAssertNotNil(authViewModel.signInError, "Sign-in error should not be nil after unsuccessful sign-in")
    //                    expectation.fulfill()
    //                }
    //            }
    //        }
    //
    //    @MainActor
    //    //#3 - testing sign out there is nothing for the userSession or the currentUser
    //    func testSignOut() {
    //            let expectation = XCTestExpectation(description: "Sign out")
    //
    //            Task {
    //                await authViewModel.signOut()
    //                XCTAssertNil(authViewModel.userSession, "User session should be nil after sign-out")
    //                XCTAssertNil(authViewModel.currentUser, "Current user should be nil after sign-out")
    //                expectation.fulfill()
    //            }
    //        }
    //
    //    @MainActor
    //    //#4 - testing new user creation
    //    func testCreateUserWithValidData() {
    //           let expectation = XCTestExpectation(description: "Create user with valid data")
    //
    //           let email = "leoMessi@testing.com"
    //           let password = "123456"
    //           let fullname = "Leo Messi"
    //           let securityAnswer = "Buenos Aires"
    //           let itineraryIDs: [String] = ["id1", "id2"]
    //
    //           Task {
    //               do {
    //                   try await authViewModel.createUser(withEmail: email, password: password, fullname: fullname, securityAnswer: securityAnswer, itineraryIDs: itineraryIDs)
    //                   XCTAssertNotNil(authViewModel.userSession, "User session should not be nil after successful user creation")
    //                   XCTAssertNotNil(authViewModel.currentUser, "Current user should not be nil after successful user creation")
    //                   XCTAssertNil(authViewModel.signUpError, "Sign-up error should be nil after successful user creation")
    //                   expectation.fulfill()
    //               } catch {
    //                   XCTFail("Unexpected error during user creation: \(error.localizedDescription)")
    //               }
    //           }
    //       }
    //
    //    @MainActor
    //    //#5 - testing that all the data from created user is properly fetched
    //    func testFetchUser() {
    //           let expectation = XCTestExpectation(description: "Fetch user")
    //
    //           Task {
    //               await authViewModel.fetchUser()
    //               XCTAssertNotNil(authViewModel.currentUser, "Current user should not be nil after fetch")
    //               expectation.fulfill()
    //           }
    //       }
}
