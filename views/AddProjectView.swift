import SwiftUI
import Alamofire

struct AddProjectView: View {
    @State private var projectTitle = ""
    @State private var projectDate = Date()
    @State private var projectDescription = ""
    @State private var projectExigence = ""
    @State private var projectDetail = ""
    @State private var projectImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var isLoading = false
    @State private var alertMessage: String?
    @State private var showAlert = false

    var body: some View {
        VStack {
            TextField("Project Name", text: $projectTitle)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Project Description", text: $projectDescription)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Project Exigence", text: $projectExigence)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Project Detail", text: $projectDetail)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            DatePicker("Project Date", selection: $projectDate, in: ...Date(), displayedComponents: .date)
                .padding()

            Button("Add Project") {
                addProject()
            }
            .padding()
            .disabled(isLoading)
            .overlay(isLoading ? ProgressView() : nil)

            // Display the selected image
            if let projectImage = projectImage {
                Image(uiImage: projectImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }

            // Use the ImagePicker
            Button("Add Image") {
                showImagePicker.toggle()
            }
            .padding()
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $projectImage, showImagePicker: $showImagePicker)
            }
        }
        .padding()
        .navigationTitle("Add Project")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
        }
    }

    func addProject() {
        // Validate the input fields
        guard validateFields() else { return }

        // Set loading state to true
        isLoading = true

        // Call the function to send project details to the server
        sendProjectToServer()
    }

    func validateFields() -> Bool {
        guard !projectTitle.isEmpty else {
            handleRequestError(message: "Please enter a project title.")
            return false
        }
        // Additional validation as needed...

        return true
    }

    func sendProjectToServer() {
        guard (projectImage?.jpegData(compressionQuality: 0.5)) != nil else {
            handleRequestError(message: "Selected image is missing")
            return
        }

        guard let url = URL(string: "http://localhost:5001/api/projects/store") else {
            handleRequestError(message: "Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        AF.upload(multipartFormData: { multipartFormData in
            // Add project details
            multipartFormData.append(projectTitle.data(using: .utf8) ?? Data(), withName: "title")
            multipartFormData.append(projectDate.description.data(using: .utf8) ?? Data(), withName: "date")
            multipartFormData.append(projectDescription.data(using: .utf8) ?? Data(), withName: "description")
            multipartFormData.append(projectExigence.data(using: .utf8) ?? Data(), withName: "exigence")
            multipartFormData.append(projectDetail.data(using: .utf8) ?? Data(), withName: "detail")

            // Add additional fields
            multipartFormData.append("AdditionalField1Value".data(using: .utf8) ?? Data(), withName: "additionalField1")
            multipartFormData.append("AdditionalField2Value".data(using: .utf8) ?? Data(), withName: "additionalField2")

            if let imageData = projectImage?.jpegData(compressionQuality: 0.5) {
                multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
            }
        }, to: "http://localhost:5001/api/projects/store")
        .response { response in
            handleResponse(response)
        }
    }

    func handleResponse(_ response: AFDataResponse<Data?>) {
        isLoading = false

        if let error = response.error {
            handleRequestError(message: "Error: \(error)")
            return
        }

        if let data = response.data {
            do {
                let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                print("Response data: \(apiResponse.message)")

                // Handle success or failure based on the response
                if apiResponse.message == "An error occurred!" {
                    handleRequestError(message: apiResponse.message)
                } else {
                    // Handle success
                }
            } catch {
                print("Error decoding projects: \(error)")
                handleRequestError(message: "Failed to decode response")
            }
        }
    }

    func handleRequestError(message: String) {
        alertMessage = message
        showAlert = true
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

    struct APIResponse: Decodable {
        let message: String
    }
}
