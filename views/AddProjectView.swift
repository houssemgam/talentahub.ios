import Foundation
import SwiftUI
import Alamofire

struct Project: Codable, Identifiable {
    let id: String
    let title: String
    let date: Date
    let description: String
    let exigence: String
    let detail: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case date
        case description
        case exigence
        case detail
        case imageURL
    }
}

struct AddProjectView: View {
    @State private var projectName = ""
    @State private var projectDate = Date()
    @State private var projectDescription = ""
    @State private var projectExigence = ""
    @State private var projectDetail = ""
    @State private var image: UIImage? = nil
    @State private var showImagePicker = false
    @State private var createdProject: Project? // Add a property to store the created project

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Project Details")) {
                    TextField("Project Name", text: $projectName)
                    DatePicker("Project Date", selection: $projectDate, in: Date()...)
                    TextField("Project Description", text: $projectDescription)
                    TextField("Project Exigence", text: $projectExigence)
                    TextField("Project Detail", text: $projectDetail)
                }

                Section(header: Text("Project Image")) {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Button(action: {
                            showImagePicker.toggle()
                        }) {
                            Image(systemName: "arrow.up.to.line.alt")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 50)
                                .foregroundColor(Color(red: 0.36, green: 0.7, blue: 0.36))
                                .imageScale(.large)
                        }
                    }
                }

                Button(action: sendProjectToServer) {
                    Text("Add Project")
                }
                .font(.headline)
                .padding(20)
                .background(Color(red: 0.36, green: 0.7, blue: 0.36))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .navigationTitle("Add Project")
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $image, showImagePicker: $showImagePicker)
            }
        }
    }

    func sendProjectToServer() {
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else {
            print("Selected image is missing")
            return
        }

        guard let url = URL(string: "https://your-server-endpoint.com/upload-project") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let formData = MultipartFormData()

        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(projectName.data(using: .utf8) ?? Data(), withName: "projectName")
            multipartFormData.append(projectDate.description.data(using: .utf8) ?? Data(), withName: "projectDate")
            multipartFormData.append(projectDescription.data(using: .utf8) ?? Data(), withName: "projectDescription")
            multipartFormData.append(projectExigence.data(using: .utf8) ?? Data(), withName: "projectExigence")
            multipartFormData.append(projectDetail.data(using: .utf8) ?? Data(), withName: "projectDetail")
            if let imageData = image?.jpegData(compressionQuality: 0.5) {
                multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
            }
        }, to: "http://localhost:5001/api/project")
        .response { response in
            if let error = response.error {
                print("Error: \(error)")
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
