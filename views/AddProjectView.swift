import SwiftUI

struct AddProjectView: View {
    @State private var projectName = ""
    @State private var projectDate = Date()
    @State private var projectDescription = ""
    @State private var image: Image? = nil
    @State private var showImagePicker = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Project Details")) {
                    TextField("Project Name", text: $projectName)
                    DatePicker("Project Date", selection: $projectDate, in: Date()...)
                    TextField("Project Description", text: $projectDescription)
                }
                
                Section(header: Text("Project Image")) {
                    if let image = image {
                        image
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
                                .foregroundColor(.green)
                                .imageScale(.large)
                        }
                    }
                }
                
                Button(action: {
                    // Add your logic for saving the project here
                }) {
                    Text("Add Project")
                }
                .font(.headline)
                .padding(20)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .navigationTitle("Add Project")
            
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $image, showImagePicker: $showImagePicker)
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: Image?
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
                parent.selectedImage = Image(uiImage: image)
            }
            
            parent.showImagePicker = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.showImagePicker = false
        }
    }
}
