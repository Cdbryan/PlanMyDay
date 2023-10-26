//
//  Plan_My_DayApp.swift
//  Plan My Day
//
//  Created by Itzel Villanueva on 10/24/23.
//

import SwiftUI

@main
struct Plan_My_DayApp: App {
    //only initalize in one place so that can use it through all pages
    @StateObject var viewModel = AuthViewModel()
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(viewModel)
        }
    }
}
