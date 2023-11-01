//
//  AttractionView.swift
//  Plan My Day
//
//  Created by Alysha Kanjiyani on 10/31/23.
//
import SwiftUI


struct AttractionView: View {
    
    // pass in itinerary struct
    
    let attractions = Attraction.attractionList
    @State private var selectedAttractions: [Attraction] = []
    @State private var isChecklistVisible = false
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
            }
            .sheet(item: $selectedAttraction) { attraction in
                AttractionDetailView(attraction: attraction)
            }
            .sheet(isPresented: $isChecklistVisible) {
                AttractionChecklistView(
                    attractions: attractions,
                    selectedAttractions: $selectedAttractions,
                    isChecklistVisible: $isChecklistVisible
                )
            }
        }
    }
}
struct AttractionChecklistView: View {
    let attractions: [Attraction]
    @Binding var selectedAttractions: [Attraction]
    @Binding var isChecklistVisible: Bool
    
    var body: some View {
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
                Button("Done") {
                    isChecklistVisible.toggle()
                }
            }
        }
    }
    
    func toggleAttraction(_ attraction: Attraction) {
        if selectedAttractions.contains(where: { $0.id == attraction.id }) {
            selectedAttractions.removeAll { $0.id == attraction.id }
        } else {
            selectedAttractions.append(attraction)
        }
        
        // update itinerary with selected attractions
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



struct Attraction: Identifiable {
    let id = UUID()
    let attractionId: Int
    let name: String
    let location: String
    let isUSC: Bool
    var hours: [String]
    var desc: String
    
    
    static let attractionList = [
        Attraction(attractionId: 1, name: "USC Village", location: "USC", isUSC: true, hours: ["9:00 AM - 5:00 PM"], desc: "village"),
        Attraction(attractionId: 2, name: "Equad", location: "USC", isUSC: true, hours: ["Open 24 Hours"], desc: "village"),
        Attraction(attractionId: 3, name: "School of Cinematic Arts", location: "USC", isUSC: true, hours: ["Open 24 Hours"], desc: "village"),
        Attraction(attractionId: 4, name: "LA Memorial Colosseum", location: "USC", isUSC: true, hours: ["Open 24 Hours"], desc: "village"),
        Attraction(attractionId: 5, name: "Marshall School of Business", location: "USC", isUSC: true, hours: ["Open 24 Hours"], desc: "village"),
        Attraction(attractionId: 6, name: "Doheny Library", location: "USC", isUSC: true, hours: ["Open 24 Hours"], desc: "village"),
        Attraction(attractionId: 7, name: "Greek Row", location: "USC", isUSC: true, hours: ["Open 24 Hours"], desc: "village"),
        Attraction(attractionId: 8, name: "Tommy Trojan", location: "USC", isUSC: true, hours: ["Open 24 Hours"], desc: "village"),
        Attraction(attractionId: 9, name: "Crypto Center", location: "Los Angeles", isUSC: false, hours: ["Open 24 Hours"], desc: "village"),
        Attraction(attractionId: 10, name: "FIDM Museum", location: "Los Angeles", isUSC: false, hours: ["Open 24 Hours"], desc: "village"),
        Attraction(attractionId: 11, name: "Santa Monica Pier", location: "Los Angeles", isUSC: false, hours: ["Open 24 Hours"], desc: "village"),
        Attraction(attractionId: 12, name: "Natural History Museum", location: "Los Angeles", isUSC: false, hours: ["Open 24 Hours"], desc: "village"),
        Attraction(attractionId: 13, name: "Hollywood Walk of Fame", location: "Los Angeles", isUSC: false, hours: ["Open 24 Hours"], desc: "village"),
        Attraction(attractionId: 14, name: "Hollywood Sign", location: "Los Angeles", isUSC: false, hours: ["Open 24 Hours"], desc: "village"),
        Attraction(attractionId: 15, name: "The Getty", location: "Los Angeles", isUSC: false, hours: ["Open 24 Hours"], desc: "village"),
        Attraction(attractionId: 16, name: "Griffith Observatory", location: "Los Angeles", isUSC: false, hours: ["Open 24 Hours"], desc: "village"),
        Attraction(attractionId: 17, name: "Universal Studios", location: "Los Angeles", isUSC: false, hours: ["Open 24 Hours"], desc: "village"),
        Attraction(attractionId: 18, name: "The Grove", location: "Los Angeles", isUSC: false, hours: ["Open 24 Hours"], desc: "village"),
        Attraction(attractionId: 19, name: "Grand Central Market", location: "Los Angeles", isUSC: false, hours: ["Open 24 Hours"], desc: "village"),
        Attraction(attractionId: 20, name: "Peterson Automative Museum", location: "Los Angeles", isUSC: false, hours: ["Open 24 Hours"], desc: "village"),
    ]
    
    
}
