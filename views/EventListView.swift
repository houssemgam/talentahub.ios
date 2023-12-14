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
        @State private var isSwipeActive: Bool = false

        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    // Image Frame
                    URLImage(URL(string: event.image)!) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                            .cornerRadius(16)
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .background(Color.blue)
                    .cornerRadius(16)
                    .shadow(color: Color.gray.opacity(0.3), radius: 8, x: 0, y: 4)
                    .overlay(
                        HStack(spacing: 0) {
                            // Modifier (Edit) button
                            Button(action: {
                                // Handle edit action
                                print("Edit tapped")
                            }) {
                                Image(systemName: "pencil.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.blue)
                                    .padding(.bottom, 16)
                            }

                            // Supprimer (Delete) button
                            Button(action: {
                                // Handle delete action
                                print("Delete tapped")
                            }) {
                                Image(systemName: "trash.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.red)
                                    .padding(.bottom, 16)
                            }
                            Spacer()
                        }
                        .opacity(isSwipeActive ? 1 : 0)
                        .frame(width: isSwipeActive ? 120 : 0)
                        .animation(.default)
                    )

                    // Description, Location, and Event Date Frame
                    VStack(alignment: .leading, spacing: 8) {
                        Text(event.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)

                        Text("Description:")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text(event.description)
                            .font(.body)
                            .foregroundColor(.primary)

                        Text("Location: \(event.location)")
                            .font(.headline)
                            .foregroundColor(.gray)

                        DatePicker("", selection: .constant(Date()), displayedComponents: .date)
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(16)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.gray.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .frame(maxWidth: .infinity)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isSwipeActive = value.translation.width < 0
                    }
                    .onEnded { _ in
                        isSwipeActive = false
                    }
            )
            .padding([.leading, .trailing], 16)
        }
    }
    

   
    struct EventDetailView: View {
        let event: Event
        @State private var isLiked: Bool = false

        var body: some View {
            ScrollView {
                VStack(alignment: .center, spacing: 16) {
                    EventImage(url: event.image)

                    Text(event.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding()

                    LikeDateLocationView(isLiked: $isLiked, date: event.date, location: event.location)

                    // Book Button
                    BookingButton(action: {
                        // Add your action for booking
                    })

                    Divider()

                    EventDetailsView(event: event)
                }
                .padding()
            }
            .navigationBarTitle(Text("Event Details"), displayMode: .inline)
        }
    }

    struct EventImage: View {
        let url: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0){
                URLImage(URL(string: url)!) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(16)
                        .shadow(radius: 4)
                }
                .frame(height: 200) // Adjust the height based on your design preference
            }
        }
    }

    struct LikeDateLocationView: View {
        @Binding var isLiked: Bool
        let date: String
        let location: String

        var body: some View {
            HStack {
                LikeButton(isLiked: $isLiked)

                Text("Date: \(date)")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Spacer()

                Text("Location: \(location)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
        }
    }

    struct LikeButton: View {
        @Binding var isLiked: Bool

        var body: some View {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .font(.system(size: 20))
                .foregroundColor(isLiked ? Color.red : Color.gray)
                .onTapGesture {
                    isLiked.toggle()
                }
        }
    }

    struct BookingButton: View {
        var action: () -> Void

        var body: some View {
            Button(action: action) {
                Text("Book")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
    }

    struct EventDetailsView: View {
        let event: Event

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("Event Details")
                    .font(.headline)
                    .padding(.bottom, 8)

                Text("Name: \(event.name)")
                    .font(.body)
                    .foregroundColor(.primary)

                Text("Date: \(event.date)")
                    .font(.body)
                    .foregroundColor(.primary)

                Text("Location: \(event.location)")
                    .font(.body)
                    .foregroundColor(.primary)
            }
        }
    }



    func fetchEvents() {
        guard let url = URL(string: "http://localhost:5001/event") else {//effectuer requette
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

            let decoder = JSONDecoder()//écupère les données JSON de la réponse, puis les décode en un tableau d'objets Event à l'aide de JSONDecoder
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
               //capInsets: <#T##EdgeInsets#>, resizingMode: <#T##Image.ResizingMode#>
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

