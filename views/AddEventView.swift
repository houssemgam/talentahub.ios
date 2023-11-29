import SwiftUI


struct ImagePickerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = context.coordinator
        return imagePickerController
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePickerView

        init(_ parent: ImagePickerView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.selectedImage = selectedImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct AddEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var eventName = ""
    @State private var eventDate = Date()
    @State private var eventDescription = ""
    @State private var eventLocation = ""
    @State private var selectedImage: UIImage?

    // Add a State variable to track the image picker presentation
    @State private var isShowingImagePicker = false
    
    var body: some View {
        VStack {
            TextField("Event Name", text: $eventName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            DatePicker("Event Date", selection: $eventDate, displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding()

            TextField("Event Description", text: $eventDescription)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Event Location", text: $eventLocation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                // Present the image picker
                isShowingImagePicker = true
            }) {
                Text("Add Image")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .padding()

            Button(action: {
                // Handle button action here
            }) {
                Text("Send")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .padding()
            
            Spacer()
        }
        .sheet(isPresented: $isShowingImagePicker) {
            // Present the image picker as a sheet
            ImagePickerView(selectedImage: $selectedImage)
        }
        .navigationTitle("Add Event")
    }
}
