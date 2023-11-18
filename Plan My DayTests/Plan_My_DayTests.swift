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
