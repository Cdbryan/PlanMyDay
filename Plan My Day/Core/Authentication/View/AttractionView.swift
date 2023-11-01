//
//  AttractionView.swift
//  Plan My Day
//
//  Created by Alysha Kanjiyani on 10/31/23.
//

import SwiftUI

struct AttractionView: View {
    let attractions = attractionList
    var body: some View {
        NavigationView{
            List {
                ForEach(attractions, id: \.self){ attraction in
                    NavigationLink(destination: Text(attraction)){
                        Image(systemName: "mappin.circle.fill")
                        Text(attraction)
                    }.padding()
                }.navigationTitle("Attractions")
            }
        }
    }
}

