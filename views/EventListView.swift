import SwiftUI

struct EventList: Identifiable {
    let id = UUID()
    let name: String
    let date: Date
    let description: String
    let location: String
    let image: Image
}

struct EventListView: View {
    let events: [EventList] = [
        EventList(name: "Concert", date: Date(), description: "Join us for an amazing concert with your favorite artists.", location: "City A", image: Image("concert_image")),
        EventList(name: "Sports Tournament", date: Date(), description: "Cheer on your favorite teams and athletes in an exciting sports tournament.", location: "City B", image: Image("sports_image")),
        EventList(name: "Art Exhibition", date: Date(), description: "Explore a diverse collection of artwork from talented artists.", location: "City C", image: Image("art_image")),
        EventList(name: "Jazz Festival", date: Date(), description: "Immerse yourself in the smooth tunes of jazz at our annual festival.", location: "City D", image: Image("jazz_image"))
    ]
    
    @State private var isAddingEvent = false

    var body: some View {
        NavigationView {
            VStack {
                List(events) { event in
                    NavigationLink(destination: EventDetailView(event: event)) {
                        HStack {
                            event.image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .cornerRadius(8)
                            
                            VStack(alignment: .leading) {
                                Text(event.name)
                                    .font(.headline)
                                Text(event.date.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(event.location)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .navigationTitle("Events")
                
                Button(action: {
                    isAddingEvent = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                        .padding()
                }
                .sheet(isPresented: $isAddingEvent) {
                    // Présenter une nouvelle vue pour ajouter des événements
                    AddEventView()
                }
            }
        }
    }
}

struct EventDetailView: View {
    let event: EventList
    
    var body: some View {
        VStack {
            Text(event.name)
                .font(.title)
                .padding()
            
            Text("Date: \(event.date.description)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Location: \(event.location)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(event.description)
                .padding()
            
            Spacer()
        }
        .navigationBarTitle(event.name)
    }
}

