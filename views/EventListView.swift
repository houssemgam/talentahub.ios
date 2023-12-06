import SwiftUI
import URLImage

struct MyEventsView: View {
    @State private var events: [Event] = []
    @State private var isAddingEvent = false
    @State private var selectedEvent: Event?

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(events, id: \.id) { event in
                        VStack(alignment: .leading, spacing: 8) {
                            EventCardView(event: event)
                                .onTapGesture {
                                    selectedEvent = event
                                }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 16)
            }
            .navigationBarTitle("Events")
            .onAppear {
                fetchEvents()
            }
            .sheet(item: $selectedEvent) { event in
                EventDetailView(event: event)
            }
            .sheet(isPresented: $isAddingEvent) {
                AddEventView()
            }
            Spacer()
        }
        .overlay(
            VStack {
                Spacer()
                Button(action: {
                    isAddingEvent = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .padding()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(red: 0.36, green: 0.7, blue: 0.36))
                        .imageScale(.large)
                }
            }
        )
    }

    struct EventCardView: View {
        let event: Event

        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                ZStack(alignment: .topTrailing) {
                    URLImage(URL(string: event.image)!) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(height: 200)
                    .cornerRadius(16)

                    Text(event.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(12)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Description:")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text(event.description)
                        .font(.body)
                        .foregroundColor(.primary)

                    Text("Location:")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text(event.location)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(UIColor.secondarySystemBackground))
                )
                .shadow(color: Color.gray.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding([.leading, .trailing], 16)
        }
    }

    struct EventDetailView: View {
        let event: Event
        @State private var message: String = ""

        var body: some View {
            ScrollView {
                VStack {
                    Text(event.name)
                        .font(.title)
                        .padding()

                    URLImage(URL(string: event.image)!) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                            .shadow(radius: 4)
                    }

                    Text("Description: \(event.description)")
                        .font(.body)
                        .padding()

                    TextField("Enter your message", text: $message)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button(action: {
                        // Handle send button action
                        // You can access the message using self.message
                    }) {
                        Text("Send")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .padding()
            }
            .navigationBarTitle(Text("Event Details"), displayMode: .inline)
        }
    }

    func fetchEvents() {
        guard let url = URL(string: "http://localhost:5001/event") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching events: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            decoder.dateDecodingStrategy = .formatted(dateFormatter)

            do {
                let eventsArray = try decoder.decode([Event].self, from: data)
                DispatchQueue.main.async {
                    self.events = eventsArray
                }
            } catch {
                print("Error decoding events: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received JSON: \(jsonString)")
                } else {
                    print("Unable to convert JSON data to string")
                }
            }
        }.resume()
    }
}

       struct AsyncImageView: View {
           @StateObject private var imageLoader: ImageLoader

           init(url: String) {
               let urlString = "http://localhost:5001/" + url
               _imageLoader = StateObject(wrappedValue: ImageLoader(url: urlString))
           }

           var body: some View {
               if let uiImage = imageLoader.image {
                   Image(uiImage: uiImage)
                       .resizable()
                       .aspectRatio(contentMode: .fit)
               } else {
                   ProgressView()
                       .progressViewStyle(CircularProgressViewStyle())
               }
           }
       }

       class ImageLoader: ObservableObject {
           @Published var image: UIImage?

           init(url: String) {
               guard let imageURL = URL(string: url) else { return }

               URLSession.shared.dataTask(with: imageURL) { data, response, error in
                   if let data = data, let loadedImage = UIImage(data: data) {
                       DispatchQueue.main.async {
                           self.image = loadedImage
                       }
                   }
               }.resume()
           }
       }

       struct MyEventsView_Previews: PreviewProvider {
           static var previews: some View {
               MyEventsView()
           }
       }

