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
                Section(header: Text("USC Attractions").foregroundColor(Color("orange"))) {
                    ForEach(attractions.prefix(8)) { attraction in
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(Color("orange"))
                            Text(attraction.name).accessibilityIdentifier("USC Village")
                                .onTapGesture {
                                    selectedAttraction = attraction
                                }
                        }
                    }
                }
                Section(header: Text("LA Attractions").foregroundColor(Color("orange"))) {
                    ForEach(attractions.dropFirst(8)) { attraction in
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(Color("orange"))
                            Text(attraction.name)
                                .onTapGesture {
                                    selectedAttraction = attraction
                                }
                        }
                    }
                }
            
                
            }
            .navigationTitle("Attractions").foregroundColor(Color("purps"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isChecklistVisible.toggle()
                    }) {
                        Text("Select Attractions").accessibilityIdentifier("Select Attractions").foregroundColor(Color("orange")).bold()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(
                        destination: MapPageView(itinerary: Itinerary(itineraryName: itineraryName, attractions: selectedAttractions, numberOfDays: numberOfDays, tourDuration: tourDuration, plan: plan), disableSave: false).navigationTitle("")
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
            Image("sunset")
                .resizable()
                .scaledToFill()
                .frame(width: 250, height: 270)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .overlay(Circle().stroke(Color("orange"), lineWidth: 4))
                .shadow(radius: 4)
                .padding(.top, -95)
                .padding(.bottom, 10)
            
            Text("Number of Days: \(numberOfDays)")
                .font(.headline)
                .foregroundColor(Color("orange"))

            Stepper(value: $numberOfDays, in: 1...20, step: 1) {
                Text("Number of Days: \(numberOfDays)")
            }
            .padding()
            
            Button(action: {
                isNumberofDaysActive.toggle()
                isChecklistVisible.toggle()
                
                // if all requirements met: populate variables req for itinerary and set plan valid
                if isValidPlan() {
                    let planPerDay: Int = Int(ceil(Double(selectedAttractions.count) / Double(numberOfDays)))

                    validPlan = true
                    tourDuration = [] // Initialize an array to store the duration for each day
                    plan = Array(repeating: [], count: numberOfDays) // Initialize the plan array with empty arrays for each day

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
                        if currentDayDuration + attractionDuration <= 6.0 && plan[currentDay].count < planPerDay {
                            plan[currentDay].append(attraction)
                            currentDayDuration += attractionDuration
                        } else {
                            // Move to the next day if the current day is full
                            currentDay += 1
                            currentDayDuration = attractionDuration

                            // Ensure we don't go out of bounds
                            if currentDay < numberOfDays {
                                plan[currentDay].append(attraction) // Create a new day in the plan
                            }
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
                    .foregroundColor(Color("orange"))
                    .bold()
                    .font(.system(size: 20))
                    .padding(.top, 20)
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
                            Image(systemName: selectedAttractions.contains { $0.id == attraction.id } ? "checkmark.square" : "square").accessibilityIdentifier("checkmark.square")
                            Text(attraction.name)
                        }
                        .onTapGesture {
                            toggleAttraction(attraction)
                        }
                    }
                }
                .navigationBarTitle("Select Attractions").foregroundColor(Color("purps"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            selectedAttractions = []
                            isChecklistVisible.toggle()
                        }
                        .accessibilityIdentifier("Cancel")
                        .foregroundColor(Color(.systemBlue))
                        .bold()
                        
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: NumberofDaysInputView(selectedAttractions: $selectedAttractions, itineraryName: $itineraryName, plan: $plan, tourDuration: $tourDuration, numberOfDays: $numberOfDays, isNumberofDaysActive: $isNumberofDaysActive, isChecklistVisible: $isChecklistVisible, validPlan: $validPlan)) {
                            Text("Next").accessibilityIdentifier("Next").foregroundColor(Color("orange"))
                                .bold()
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
        VStack(alignment: .leading) {
            Text(attraction.name)
                .font(.title)
                .accessibilityIdentifier("attractionNameLabel")
                .padding(EdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 0))
                .font(.largeTitle)
                .foregroundColor(Color("purps"))
                .bold()
            HStack(alignment: .top){
                Text("Location: ").bold()
                    .foregroundColor(Color("orange"))
                    .padding(EdgeInsets(top: 0, leading: 25, bottom: 10, trailing: 0))
                Text(" \(attraction.location)")
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            }

            HStack(alignment: .top){
                Text("Hours: ").bold()
                    .foregroundColor(Color("orange"))
                    .padding(EdgeInsets(top: 0, leading: 25, bottom: 10, trailing: 0))
                Text(" \(attraction.hours.joined(separator: ", "))")
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 0))
            }
            
            VStack(alignment: .leading){
                Text("Description: ").bold()
                    .foregroundColor(Color("orange"))
                    .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 0))
                Text(" \(attraction.desc)")
                    .padding(EdgeInsets(top: 0, leading: 25, bottom: 10, trailing: 0))
            }
            
            HStack {
                Spacer() // Pushes the image to the center
                Image("\(attraction.name)")
                    .resizable()
                   .scaledToFill()
                   .frame(width: 350, height: 350) // Adjust size as needed
                   .clipShape(Rectangle()) // You can use Circle() for a circular shape
                   .overlay(Rectangle().stroke(Color(.systemBlue), lineWidth: 4)) // Optional: add a border
                   .padding(EdgeInsets(top: 25, leading: 25, bottom: 25, trailing: 25))
                Spacer()
            }

            
            
            Spacer()
        }
        .padding(10)
    }
}

