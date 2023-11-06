import SwiftUI
import FirebaseFirestore



struct HomeView: View {
    
    var itineraries : [Itinerary] = [
        Itinerary(itineraryName: "Other Trip", attractions: [
        Attraction(attractionId: 1, name: "USC Village", location: "USC", isUSC: true, lat: 34.0268515, long: -118.2878486, hours: ["9:00 AM - 5:00 PM"], desc: "village"),
        Attraction(attractionId: 2, name: "Equad", location: "USC", isUSC: true, lat: 34.021007, long: -118.2891249, hours: ["Open 24 Hours"], desc: "village")], numberOfDays: 2), 
        
        Itinerary(itineraryName: "USC Trip", attractions: [
        Attraction(attractionId: 6, name: "Leavy", location: "USC", isUSC: true, lat: 34.0268515, long: -118.2878486, hours: ["9:00 AM - 5:00 PM"], desc: "village"),
        Attraction(attractionId: 7, name: "SCA", location: "USC", isUSC: true, lat: 34.021007, long: -118.2891249, hours: ["Open 24 Hours"], desc: "village")], numberOfDays: 2)]
    
    
    
    var body: some View {
        NavigationView {
            List(itineraries, id: \.id) { itinerary in
                NavigationLink(destination: MapPageView(itinerary : itinerary, disableSave: true)) {
                    Text(itinerary.itineraryName)
                }
            }
            .navigationBarTitle("", displayMode: .inline) // Hide the default title
            .navigationBarItems(
                leading: HStack {
                    NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                        Text("Sign Out")
                    }
                    Text("My Trips")
                        .font(.title)
                        .foregroundColor(.primary)
                },
                trailing: NavigationLink(destination: AttractionView().navigationBarBackButtonHidden(false)) {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.primary)
            }
            )
        }
    }
}

