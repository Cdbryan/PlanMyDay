//
//  AttractionView.swift
//  Plan My Day
//
//  Created by Alysha Kanjiyani on 10/31/23.
//

//import SwiftUI
//
//struct AttractionView: View {
//    let attractions = attractionList
//    var body: some View {
//        NavigationView{
//            List {
//                ForEach(attractions, id: \.self){ attraction in
//                    NavigationLink(destination: Text(attraction)){
//                        Image(systemName: "mappin.circle.fill")
//                        Text(attraction)
//                    }.padding()
//                }.navigationTitle("Attractions")
//            }
//        }
//    }
//}
import SwiftUI

struct AttractionView: View {
    let attractions = Attraction.attractionList
    @State private var selectedAttraction: Attraction?

    var body: some View {
        NavigationView {
            List {
                ForEach(attractions) { attraction in
                    Button(action: {
                        selectedAttraction = attraction
                    }) {
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                            Text(attraction.name)
                        }
                    }
                }.navigationTitle("Attractions")
            }
            .sheet(item: $selectedAttraction) { attraction in
                AttractionDetailView(attraction: attraction)
            }
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
            // Add more information as needed

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

    static let attractionList = [
        Attraction(attractionId: 1, name: "USC Bookstore", location: "Los Angeles", isUSC: true, hours: ["9:00 AM - 5:00 PM"]),
        Attraction(attractionId: 2, name: "Tommy Trojan", location: "Los Angeles", isUSC: true, hours: ["Open 24 Hours"]),
        Attraction(attractionId: 3, name: "Tommy Trojan", location: "Los Angeles", isUSC: true, hours: ["Open 24 Hours"]),
        Attraction(attractionId: 4, name: "Tommy Trojan", location: "Los Angeles", isUSC: true, hours: ["Open 24 Hours"]),
        Attraction(attractionId: 5, name: "Tommy Trojan", location: "Los Angeles", isUSC: true, hours: ["Open 24 Hours"]),
        Attraction(attractionId: 6, name: "Tommy Trojan", location: "Los Angeles", isUSC: true, hours: ["Open 24 Hours"]),
        Attraction(attractionId: 7, name: "Tommy Trojan", location: "Los Angeles", isUSC: true, hours: ["Open 24 Hours"]),
        Attraction(attractionId: 8, name: "Tommy Trojan", location: "Los Angeles", isUSC: true, hours: ["Open 24 Hours"]),
        Attraction(attractionId: 9, name: "Tommy Trojan", location: "Los Angeles", isUSC: true, hours: ["Open 24 Hours"]),
        Attraction(attractionId: 10, name: "Tommy Trojan", location: "Los Angeles", isUSC: true, hours: ["Open 24 Hours"]),
        Attraction(attractionId: 11, name: "Tommy Trojan", location: "Los Angeles", isUSC: true, hours: ["Open 24 Hours"]),
        Attraction(attractionId: 12, name: "Tommy Trojan", location: "Los Angeles", isUSC: true, hours: ["Open 24 Hours"]),
        Attraction(attractionId: 13, name: "Tommy Trojan", location: "Los Angeles", isUSC: true, hours: ["Open 24 Hours"]),
        Attraction(attractionId: 14, name: "Tommy Trojan", location: "Los Angeles", isUSC: true, hours: ["Open 24 Hours"]),
        Attraction(attractionId: 15, name: "Tommy Trojan", location: "Los Angeles", isUSC: true, hours: ["Open 24 Hours"]),
        Attraction(attractionId: 16, name: "Tommy Trojan", location: "Los Angeles", isUSC: true, hours: ["Open 24 Hours"]),
        Attraction(attractionId: 17, name: "Tommy Trojan", location: "Los Angeles", isUSC: true, hours: ["Open 24 Hours"]),
        Attraction(attractionId: 18, name: "Tommy Trojan", location: "Los Angeles", isUSC: true, hours: ["Open 24 Hours"]),
        Attraction(attractionId: 19, name: "Tommy Trojan", location: "Los Angeles", isUSC: true, hours: ["Open 24 Hours"]),
        Attraction(attractionId: 20, name: "Tommy Trojan", location: "Los Angeles", isUSC: true, hours: ["Open 24 Hours"]),
    ]
}
//"USC Village",
//"Equad",
//"School of Cinematic Arts",
//"LA Memorial Colosseum",
//"Marshall School of Business",
//"Doheny Library",
//"Greek Row",
//"Grand Central Market",
//"Crypto Center",
//"FIDM Museum",
//"Santa Monica Pier",
//"Natural History Museum",
//"Hollywood Walk of Fame",
//"Hollywood Sign",
//"The Getty",
//"Griffith Observatory",
//"Universal Studios",
//"The Grove",
//"Peterson Automative Museum"
