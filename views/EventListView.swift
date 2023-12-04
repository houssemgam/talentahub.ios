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

    var body: some View {
        NavigationView {
            List(events) { event in
                NavigationLink(destination: EventDetailView(event: event)) {
                    EventListItemView(event: event)
                }
            }
            .navigationTitle("Events")
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
                    .foregroundColor(.primary)

                Text(event.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(event.location)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}


struct EventDetailView: View {
    let event: EventList

    @State private var isBookingConfirmationPresented = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                event.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                
                Text(event.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(event.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Text("Location: \(event.location)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Date: \(event.date, style: .date)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Button(action: {
                    bookEvent()
                }) {
                    Text("Book")
                        .fontWeight(.bold)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 2)
                }
            }
            .padding()
        }
        .navigationBarTitle(event.name)
        .sheet(isPresented: $isBookingConfirmationPresented) {
            BookingConfirmationView(event: event)
        }
    }

    private func bookEvent() {
        print("Booking event: \(event.name)")
        isBookingConfirmationPresented = true
    }
}
struct BookingConfirmationView: View {
    let event: EventList
    
    @State private var isSharing = false
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("Event Booked!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("You have successfully booked the \(event.name) event.")
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text("Event Details:")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Name: \(event.name)")
                Text("Date: \(event.date, style: .date)")
                Text("Location: \(event.location)")
                Text("Description: \(event.description)")
            }
            .font(.body)
            .foregroundColor(.primary)
            
            Button(action: {
                isSharing = true
            }) {
                Text("Share")
                    .fontWeight(.bold)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 2)
            }
            
           
        }
        .padding()
        .sheet(isPresented: $isSharing, content: {
            ShareSheet(activityItems: [event.name])
        })
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Leave empty
    }
}
