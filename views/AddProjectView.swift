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
    @State private var createdProject: Project? // Adjust for your needs
    
    var body: some View {
           VStack {
               TextField("Project Name", text: $projectTitle)
                   .padding()
                   .textFieldStyle(RoundedBorderTextFieldStyle())

               TextField("Project Description", text: $projectDescription)
                   .padding()
                   .textFieldStyle(RoundedBorderTextFieldStyle())

               Button("Add Project") {
                   sendProjectToServer()
               }
               .padding()
           }
           .padding()
           .navigationTitle("Add Project")
       }

    
    func sendProjectToServer() {
        guard let imageData = projectImage?.jpegData(compressionQuality: 0.5) else {
            print("Selected image is missing")
            return
        }

        guard let url = URL(string: "http://localhost:5001/api/projects/store") else {
            print("Invalid URL")
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
