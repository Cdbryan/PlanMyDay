import XCTest
@testable import Plan_My_Day
import SwiftUI


protocol HomeViewModelProtocol {
      func loadItineraries(testUserID: String?, completion: @escaping ([String]?) -> Void)
  }

  // Your mock implementation
  class MockHomeViewModel: HomeViewModelProtocol {
      var updateFunctionCalled: Bool = false

      func loadItineraries(testUserID: String?, completion: @escaping ([String]?) -> Void) {
          // Simulate the update function being called
          updateFunctionCalled = true
          // You can add any other necessary behavior or assertions here
          completion(nil)
      }
  }



class HomeViewTests: XCTestCase {

    var homeView: HomeView!

    override func setUp() {
        super.setUp()
        homeView = HomeView()
    }

    //tests that itineraries are fetched for a valid user with itineraries
    func testItineraryIDsCount() {
        let expectation = XCTestExpectation(description: "Loading itineraries")

        // Assume you have set testUserID in your test setup
        let testUserID = "z8pxiwpXQCVrxRl5cTgGe1Z2YOM2"

        homeView.loadItineraries(testUserID: testUserID) { itineraryIDs in
            if let itineraryIDs = itineraryIDs {
                print("Itinerary IDs: \(itineraryIDs)")
                XCTAssertEqual(itineraryIDs.count, 3, "Itinerary IDs count should be 3")
            } else {
                XCTFail("Failed to load itinerary IDs")
            }

            expectation.fulfill()
        }

        // Wait for the expectation to be fulfilled or time out
        wait(for: [expectation], timeout: 10)
    }
    
    //tests that itineraries are not fetched for a in invalid user 
    func testLoadItinerariesForInvalidUser() {
        // Load itineraries with a nil user ID
        homeView.loadItineraries(testUserID: nil) { itineraryIDs in
            // Ensure that no itineraries are fetched for an invalid user
            XCTAssertNil(itineraryIDs, "Itineraries should not be fetched for an invalid user")
        }
    }
    
    func testItineraryIDsCountNil() {
        let expectation = XCTestExpectation(description: "Loading itineraries")

        // Assume you have set testUserID in your test setup
        let testUserID = "fXKZOuSsW7haQzKmIX4IGcDZS4K2"

        homeView.loadItineraries(testUserID: testUserID) { [weak self] itineraryIDs in
            guard let self = self else {
                XCTFail("Test instance deallocated")
                expectation.fulfill()
                return
            }

            if let itineraryIDs = itineraryIDs {
                // Fail the test if itineraryIDs is not empty
                if !itineraryIDs.isEmpty {
                    XCTFail("Itinerary IDs count should be 0")
                }

                // At this point, the UI elements should not be visible
                XCTAssertFalse(self.homeView.noItineraries, "UI elements for itineraries should not be visible")

            } else {
                // If itineraryIDs is nil, the UI elements for no itineraries should be visible
                XCTAssertTrue(self.homeView.noItineraries, "UI elements for itineraries should be visible")
            }

            expectation.fulfill()
        }

        // Wait for the expectation to be fulfilled or time out
        wait(for: [expectation], timeout: 10)
    }
    
    func testNoItinerariesText() {
        // Create an instance of HomeView
        var homeView = HomeView()

        // Load itineraries with a user who has no itineraries
        let testUserID = "fXKZOuSsW7haQzKmIX4IGcDZS4K2"
        homeView.loadItineraries(testUserID: testUserID) { [weak self] itineraryIDs in
            guard let self = self else {
                XCTFail("Test instance deallocated")
                return
            }

            // Set the state variable based on the visibility of "No saved itineraries" text
            let isNoItinerariesTextVisible = self.homeView.noItineraries

            // At this point, the UI should display the text for no itineraries
            XCTAssertTrue(isNoItinerariesTextVisible, "UI elements for no itineraries should be visible")
        }
    }
    
      // Your unit test for the ViewModel
      class HomeViewModelTests: XCTestCase {
          func testLoadItinerariesCallsUpdateFunction() {
              // Arrange
              let mockHomeViewModel = MockHomeViewModel()

              // Act
              mockHomeViewModel.loadItineraries(testUserID: "z8pxiwpXQCVrxRl5cTgGe1Z2YOM2") { _ in
                  // This closure is called when loadItineraries completes
                  // Add any assertions related to the test here
                  // For example, you can check if the update function is called
                  XCTAssertTrue(mockHomeViewModel.updateFunctionCalled)
              }
          }
      }
}
