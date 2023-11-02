//
//  AttractionView.swift
//  Plan My Day
//
//  Created by Alysha Kanjiyani on 10/31/23.
//
import SwiftUI


struct AttractionView: View {
    
    let attractions = Attraction.attractionList
    @State private var selectedAttractions: [Attraction] = []
    @State private var numberOfDays: Int = 1
    @State private var isChecklistVisible = false
    @State private var isNumberofDaysActive: Bool = false // State to control navigation
    @State private var selectedAttraction: Attraction?
    
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
                    NavigationLink(destination: MapPageView(itinerary: Itinerary(itineraryName: "test Itinerary", attractions: selectedAttractions, numberOfDays: numberOfDays))
                        .navigationTitle("Tour Planned!")) {
                        Text("Create Plan")
                    }
                }

            }
            .sheet(item: $selectedAttraction) { attraction in
                AttractionDetailView(attraction: attraction)
            }
            .sheet(isPresented: $isChecklistVisible) {
                AttractionChecklistView(
                    attractions: attractions,
                    selectedAttractions: $selectedAttractions,
                    isChecklistVisible: $isChecklistVisible,
                    isNumberofDaysActive: $isNumberofDaysActive,
                    numberOfDays: $numberOfDays
                )
            }
        }
    }
}

struct NumberofDaysInputView: View {
    @Binding var numberOfDays: Int
    @Binding var isNumberofDaysActive: Bool
    @Binding var isChecklistVisible: Bool

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
            }) {
                Text("Done")
            }
        }
        .padding()
    }
}

struct AttractionChecklistView: View {
    let attractions: [Attraction]
        @Binding var selectedAttractions: [Attraction]
        @Binding var isChecklistVisible: Bool
        @Binding var isNumberofDaysActive: Bool
    @Binding var numberOfDays: Int

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
                        NavigationLink(destination: NumberofDaysInputView(numberOfDays: $numberOfDays, isNumberofDaysActive: $isNumberofDaysActive, isChecklistVisible: $isChecklistVisible)) {
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

