//
//  AttractionView.swift
//  Plan My Day
//
//  Created by Alysha Kanjiyani on 10/31/23.
//
import SwiftUI
import Firebase


struct AttractionView: View {
    func isValidPlan() -> Bool {
        // Calculate total time spent at all selected attractions
        let totalAttractionTime = selectedAttractions.reduce(0) { total, attraction in
            return total + (attraction.isUSC ? 0.25 : 1.0)
        }
        
        // Calculate total time per day
        let totalTimePerDay = totalAttractionTime / Double(numberOfDays)
        
        // Check if the itinerary is valid
        if selectedAttractions.count >= numberOfDays && totalAttractionTime <= Double(numberOfDays) * 6.0 {
            return true
        } else {
            return false
        }
    }
    
    let attractions = Attraction.attractionList
   
    // vars to pass into Itinerary
    @State private var selectedAttractions: [Attraction] = []
    @State private var numberOfDays: Int = 1
    @State private var plan: [[Attraction]] = [[]]
    @State private var itineraryName = ""
    @State private var tourDuration: [Double] = []
    
    
    @State private var isChecklistVisible = false
    @State private var isNumberofDaysActive: Bool = false // State to control navigation
    @State private var selectedAttraction: Attraction?
    @State private var validPlan = false
    
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("USC Attractions")) {
                    ForEach(attractions.prefix(8)) { attraction in
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                            Text(attraction.name)
                                .onTapGesture {
                                    selectedAttraction = attraction
                                }
                        }
                    }
                }
                Section(header: Text("LA Attractions")) {
                    ForEach(attractions.dropFirst(8)) { attraction in
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                            Text(attraction.name)
                                .onTapGesture {
                                    selectedAttraction = attraction
                                }
                        }
                    }
                }
            
                
            }
            .navigationTitle("Attractions")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                            Text("Sign Out")
                        }
                    }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isChecklistVisible.toggle()
                    }) {
                        Text("Select Attractions")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(
                        destination: MapPageView(itinerary: Itinerary(itineraryName: itineraryName, attractions: selectedAttractions, numberOfDays: numberOfDays, tourDuration: tourDuration, plan: plan)).navigationTitle("Planned!")
                            ) {
                                Text("Create Plan")
                    }
                    .disabled(!isValidPlan())
                }

            }
            .sheet(item: $selectedAttraction) { attraction in
                AttractionDetailView(attraction: attraction)
            }
            .sheet(isPresented: $isChecklistVisible) {
                AttractionChecklistView(
                    attractions: attractions,
                    selectedAttractions: $selectedAttractions,
                    itineraryName: $itineraryName,
                    plan: $plan,
                    tourDuration: $tourDuration,
                    numberOfDays: $numberOfDays,
                    isNumberofDaysActive: $isNumberofDaysActive,
                    isChecklistVisible:$isChecklistVisible,
                    validPlan: $validPlan
                    
                )
            }

        }
    
    }
    
}




struct NumberofDaysInputView: View {
    func isValidPlan() -> Bool {
        // Calculate total time spent at all selected attractions
        let totalAttractionTime = selectedAttractions.reduce(0) { total, attraction in
            return total + (attraction.isUSC ? 0.25 : 1.0)
        }
        
        // Calculate total time per day
        let totalTimePerDay = totalAttractionTime / Double(numberOfDays)
        
        // Check if the itinerary is valid
        if selectedAttractions.count >= numberOfDays && totalAttractionTime <= Double(numberOfDays) * 6.0 {
            return true
        } else {
            return false
        }
    }
    
    @Binding var selectedAttractions: [Attraction]
    @Binding var itineraryName: String
    @Binding var plan: [[Attraction]]
    @Binding var tourDuration: [Double]
    @Binding var numberOfDays: Int
    @Binding var isNumberofDaysActive: Bool
    @Binding var isChecklistVisible: Bool
    @Binding var validPlan: Bool

    
    var body: some View {
        VStack {
            Text("Number of Days: \(numberOfDays)")
                .font(.headline)

            Stepper(value: $numberOfDays, in: 1...20, step: 1) {
                Text("Number of Days: \(numberOfDays)")
            }
            .padding()
            
            Button(action: {
                isNumberofDaysActive.toggle()
                isChecklistVisible.toggle()
                
                // if all requirements met: populate variables req for itinerary and set plan valid

                //old one:
                if isValidPlan() {
                                    validPlan = true
                                    tourDuration = [] // Initialize an array to store the duration for each day
                                    plan = [[]] // Initialize the plan array with an empty array for the first day

                                    // Set the itinerary name to the current date
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd"
                                    itineraryName = dateFormatter.string(from: Date())

                                    var currentDay = 0 // Initialize the current day counter
                                    var currentDayDuration: Double = 0 // Initialize the duration for the current day

                                    for attraction in selectedAttractions {
                                        // Calculate the duration for the current attraction
                                        let attractionDuration = attraction.isUSC ? 0.25 : 1.0

                                        // If adding this attraction does not exceed the 6-hour limit for the current day, add it to the plan
                                        if currentDayDuration + attractionDuration <= 6.0 {
                                            plan[currentDay].append(attraction)
                                            currentDayDuration += attractionDuration
                                        } else {
                                            // Move to the next day if the current day is full
                                            currentDay += 1
                                            currentDayDuration = attractionDuration
                                            plan.append([attraction]) // Create a new day in the plan
                                        }
                                    }

                                    // Populate the tour duration array with the duration of each day
                                    tourDuration = plan.map { day in
                                        return day.reduce(0.0) { total, attraction in
                                            return total + (attraction.isUSC ? 0.25 : 1.0)
                                        }
                                    }
                                    
                                    // Print the plan and tourDuration arrays
                                        print("Plan Array:")
                                        for (dayIndex, dayAttractions) in plan.enumerated() {
                                            print("Day \(dayIndex + 1):")
                                            for attraction in dayAttractions {
                                                print("- \(attraction.name)")
                                            }
                                        }
                                        
                                        print("Tour Duration Array:")
                                        for (dayIndex, duration) in tourDuration.enumerated() {
                                            print("Day \(dayIndex + 1): \(duration) hours")
                                        }
                                    
                                }

                
            }) {
                Text("Done")
            }
            .disabled(!isValidPlan())
        }
        .padding()
        
        
        
    }
}

struct AttractionChecklistView: View {
    let attractions: [Attraction]
    @Binding var selectedAttractions: [Attraction]
    @Binding var itineraryName: String
    @Binding var plan: [[Attraction]]
    @Binding var tourDuration: [Double]
    @Binding var numberOfDays: Int
    @Binding var isNumberofDaysActive: Bool
    @Binding var isChecklistVisible: Bool
    @Binding var validPlan: Bool


        var body: some View {
            NavigationView {
                List {
                    ForEach(attractions) { attraction in
                        HStack {
                            Image(systemName: selectedAttractions.contains { $0.id == attraction.id } ? "checkmark.square" : "square")
                            Text(attraction.name)
                        }
                        .onTapGesture {
                            toggleAttraction(attraction)
                        }
                    }
                }
                .navigationBarTitle("Select Attractions")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            selectedAttractions = []
                            isChecklistVisible.toggle()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: NumberofDaysInputView(selectedAttractions: $selectedAttractions, itineraryName: $itineraryName, plan: $plan, tourDuration: $tourDuration, numberOfDays: $numberOfDays, isNumberofDaysActive: $isNumberofDaysActive, isChecklistVisible: $isChecklistVisible, validPlan: $validPlan)) {
                            Text("Next")
                        }
                    }                }
            }
        }
    
       func toggleAttraction(_ attraction: Attraction) {
           if selectedAttractions.contains(where: { $0.id == attraction.id }) {
               selectedAttractions.removeAll { $0.id == attraction.id }
           } else {
               selectedAttractions.append(attraction)
           }
       }
}


struct AttractionDetailView: View {
    let attraction: Attraction
    
    var body: some View {
        VStack {
            Text(attraction.name)
                .font(.title)
            Text("Location: \(attraction.location)")
            Text("Hours: \(attraction.hours.joined(separator: ", "))")
            Text("Description: \(attraction.desc)")
            
            Spacer()
        }
        .padding()
    }
}

