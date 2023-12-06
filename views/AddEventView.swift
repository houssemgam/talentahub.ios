import SwiftUI
import Alamofire

struct AddEventView: View {
    @State private var eventName = ""
    @State private var eventDate = Date()
    @State private var eventDescription = ""
    @State private var eventLocation = ""
    @State private var eventImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var createdEvent: Event? // Adjust for your needs
    
    var body: some View {
        VStack {
            TextField("Event Name", text: $eventName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Event Description", text: $eventDescription)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Event Location", text: $eventLocation)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Add Event") {
                sendEventToServer()
            }
            .padding()

            ImagePicker(selectedImage: $eventImage, showImagePicker: $showImagePicker)
        }
        .padding()
        .navigationTitle("Add Event")
    }

    func sendEventToServer() {
        guard let imageData = eventImage?.jpegData(compressionQuality: 0.5) else {
            print("Selected image is missing")
            return
        }

        guard let url = URL(string: "http://localhost:5001/event/store") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        AF.upload(multipartFormData: { multipartFormData in
            // Add event details
            multipartFormData.append(eventName.data(using: .utf8) ?? Data(), withName: "name")
            multipartFormData.append(eventDate.description.data(using: .utf8) ?? Data(), withName: "date")
            multipartFormData.append(eventDescription.data(using: .utf8) ?? Data(), withName: "description")
            multipartFormData.append(eventLocation.data(using: .utf8) ?? Data(), withName: "location")

            // Add additional fields
            multipartFormData.append("AdditionalField1Value".data(using: .utf8) ?? Data(), withName: "additionalField1")
            multipartFormData.append("AdditionalField2Value".data(using: .utf8) ?? Data(), withName: "additionalField2")

            if let imageData = eventImage?.jpegData(compressionQuality: 0.5) {
                multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
            }
        }, to: "http://localhost:5001/event/create")
        .response { response in
            if let error = response.error {
                print("Error: \(error)")
                if let data = response.data {
                    let responseString = String(data: data, encoding: .utf8)
                    print("Response data: \(responseString ?? "")")
                }
                return
            }

            if let data = response.data {
                let responseString = String(data: data, encoding: .utf8)
                print("Response data: \(responseString ?? "")")
            }
        }
    }

    struct ImagePicker: UIViewControllerRepresentable {
        @Binding var selectedImage: UIImage?
        @Binding var showImagePicker: Bool

        func makeCoordinator() -> Coordinator {
            return Coordinator(parent: self)
        }

        func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            picker.sourceType = .photoLibrary
            return picker
        }

        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

        class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
            let parent: ImagePicker

            init(parent: ImagePicker) {
                self.parent = parent
            }

            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
                if let image = info[.originalImage] as? UIImage {
                    parent.selectedImage = image
                }
                parent.showImagePicker = false
            }

            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                parent.showImagePicker = false
            }
        }
    }
}
