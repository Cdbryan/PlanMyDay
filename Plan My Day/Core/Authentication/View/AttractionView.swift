//
//  AttractionView.swift
//  Plan My Day
//
//  Created by Alysha Kanjiyani on 10/31/23.
//
import SwiftUI


struct AttractionView: View {
    func isValidPlan() -> Bool{
        /* TODO: ADD CODE */
        // check conditions
        if(numberOfDays == 2 ){
            return true
        }

        // else return false
        return false
    }
    
    let attractions = Attraction.attractionList
   
    // vars to pass into Itinerary
    @State private var selectedAttractions: [Attraction] = []
    @State private var numberOfDays: Int = 1
    @State private var plan: [[Attraction]] = [[]]
    @State private var itineraryName = ""
    @State private var tourDuration: [Int] = []
    
    
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
    func isValidPlan() -> Bool{
        /* TODO: ADD CODE */
        // check conditions
        if(numberOfDays == 2 ){
            return true
        }

        // else return false
        return false
    }
    
    @Binding var itineraryName: String
    @Binding var plan: [[Attraction]]
    @Binding var tourDuration: [Int]
    @Binding var numberOfDays: Int
    @Binding var isNumberofDaysActive: Bool
    @Binding var isChecklistVisible: Bool
    @Binding var validPlan: Bool

    
    var body: some View {
        VStack {
            Text("Number of Days: \(numberOfDays)")
                .font(.headline)

            Stepper(value: $numberOfDays, in: 1...7, step: 1) {
                Text("Number of Days: \(numberOfDays)")
            }
            .padding()
            
            Button(action: {
                isNumberofDaysActive.toggle()
                isChecklistVisible.toggle()
                
                // if all requirements met: populate variables req for itinerary and set plan valid
                /* TODO: IMPLEMENT CORE ALG HERE */
                if(isValidPlan()){
                    validPlan = true
                    tourDuration = [] // set durations based on number of selected attrcns and wether USC or Not
                    plan = [[]] // make plan
                    itineraryName = "" // set name
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
    @Binding var tourDuration: [Int]
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
                        NavigationLink(destination: NumberofDaysInputView(itineraryName: $itineraryName, plan: $plan, tourDuration: $tourDuration, numberOfDays: $numberOfDays, isNumberofDaysActive: $isNumberofDaysActive, isChecklistVisible: $isChecklistVisible, validPlan: $validPlan)) {
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

