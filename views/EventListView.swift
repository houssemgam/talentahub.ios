import SwiftUI
import UIKit

struct EventList: Identifiable {
    let id = UUID()
    let name: String
    let date: Date
    let description: String
    let location: String
    let image: String
}




struct EventListView: View {
    let events: [EventList] = [
        EventList(name: "Concert", date: Date(), description: "Join us for an amazing concert with your favorite artists.", location: "City A", image: "concert_image"),
        EventList(name: "Sports Tournament", date: Date(), description: "Cheer on your favorite teams and athletes in an exciting sports tournament.", location: "City B", image: "sports_image"),
        EventList(name: "Art Exhibition", date: Date(), description: "Explore a diverse collection of artwork from talented artists.", location: "City C", image: "art_image"),
        EventList(name: "Jazz Festival", date: Date(), description: "Immerse yourself in the smooth tunes of jazz at our annual festival.", location: "City D", image: "jazz_image")
    ]
    
    @State private var isAddingEvent = false

    var body: some View {
        NavigationView {
            VStack {
                List(events) { event in
                    NavigationLink(destination: EventDetailView(event: event)) {
                        HStack {
                            Image(event.image)
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
                    // Present a new view for adding events
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
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


