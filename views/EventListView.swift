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
        EventList(name: "Concert", date: Date(), description: "Join us for an amazing concert with your favorite artists.", location: "City A", image: Image("dj")),
        EventList(name: "Sports Tournament", date: Date(), description: "Cheer on your favorite teams and athletes in an exciting sports tournament.", location: "City B", image: Image("sport")),
        EventList(name: "Art Exhibition", date: Date(), description: "Explore a diverse collection of artwork from talented artists.", location: "City C", image: Image("art")),
        EventList(name: "Jazz Festival", date: Date(), description: "Immerse yourself in the smooth tunes of jazz at our annual festival.", location: "City D", image: Image("jazz"))
    ]

    @State private var isAddingEvent = false

    var body: some View {
        NavigationView {
            VStack {
                List(events) { event in
                    NavigationLink(destination: EventDetailView(event: event)) {
                        EventListItemView(event: event)
                    }
                }
                .navigationTitle("Events")
                .listStyle(InsetGroupedListStyle())

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
                    AddEventView()
                }
            }
        }
    }
}

struct EventListItemView: View {
    let event: EventList

    var body: some View {
        HStack {
            event.image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(event.name)
                    .font(.headline)
                Text(event.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(event.location)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

struct EventDetailView: View {
    let event: EventList

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                event.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(12)

                VStack(alignment: .leading, spacing: 8) {
                    Text(event.name)
                        .font(.title)
                        .fontWeight(.bold)

                    Text(event.date, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(event.location)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(event.description)
                        .font(.body)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationBarTitle(event.name)
    }
}

