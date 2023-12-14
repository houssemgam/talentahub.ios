import SwiftUI
import UIKit
import Combine

struct TalentAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var cancellables: Set<AnyCancellable> = []
    
    @ObservedObject var talentViewModel: TalentViewModel
    
    @State private var newTalent = Talent(
        titrepro: "",
        teamtalent: "",
        email: "",
        cartepro: 0,
        affiche: nil,
        typetalent: "",
        besoinmaterielle: ""
    )
    
    @State private var selectedTeam = ""
    @State private var selectedType = ""
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImage: UIImage?
    
    let teams = ["Select a team","Solo", "Squad"]
    let talentTypes = ["Select talent type", "Sport", "Art"]
    
    @State private var teamAlert = false
    @State private var typeAlert = false
    @State private var imageAlert = false
    @State private var allFieldsALert = false
    
    var body: some View {
        ScrollView {
            VStack {
                
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                
                Text("Add New Talent")
                    .font(.title)
                    .padding()
                
                VStack {
                    TextField("Title", text: $newTalent.titrepro)
                        .padding()
                    
                    StringPicker(selection: $selectedTeam, options: teams)
                        .padding()
                        .alert(isPresented: $teamAlert) {
                            Alert(
                                title: Text("Warning"),
                                message: Text("Select a team for the talent."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    
                    TextField("Email", text: $newTalent.email)
                        .padding()
                        .alert(isPresented: $allFieldsALert) {
                            Alert(
                                title: Text("Warning"),
                                message: Text("Please fill all fields."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    
                    TextField("Card Pro", value: $newTalent.cartepro, formatter: NumberFormatter())
                        .padding()
                    
                    StringPicker(selection: $selectedType, options: talentTypes)
                        .padding()
                        .alert(isPresented: $typeAlert) {
                            Alert(
                                title: Text("Warning"),
                                message: Text("Select a talent type."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    
                    TextField("Material Needs", text: $newTalent.besoinmaterielle)
                        .padding()
                    
                    Button(action: {
                        isImagePickerPresented.toggle()
                    }) {
                        Text("Select Image")
                            .padding()
                            .foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.blue))
                    }
                    .padding()
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePicker(selectedImage: $selectedImage)
                    }
                    .alert(isPresented: $imageAlert) {
                        Alert(
                            title: Text("Warning"),
                            message: Text("Please choose an image."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    
                    // Display selected image if available
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                    }
                }
                .padding()
              //  .background(Color(UIColor(hex: "#EFEFEF")!))
                .cornerRadius(20)
                
                Spacer()
                
                Button("Add Talent") {
                    
                    guard !newTalent.titrepro.isEmpty else {
                        allFieldsALert = true
                        return
                    }
                    guard !newTalent.email.isEmpty else {
                        allFieldsALert = true
                        return
                    }
                    guard !newTalent.besoinmaterielle.isEmpty else {
                        allFieldsALert = true
                        return
                    }
                    
                    
                    guard selectedImage != nil else {
                        imageAlert = true
                        return
                    }
                    
                    
                    guard !selectedTeam.isEmpty else {
                        teamAlert = true
                        return
                    }
                    guard selectedTeam != "Select a team" else {
                        teamAlert = true
                        return
                    }
                    
                    guard !selectedType.isEmpty else {
                        typeAlert = true
                        return
                    }
                    guard selectedType != "Select talent type" else {
                        typeAlert = true
                        return
                    }
                    
                    
                    newTalent.teamtalent = selectedTeam
                    newTalent.typetalent = selectedType
                    
                    talentViewModel.add(newTalent: newTalent, image: selectedImage!)
                    
                    talentViewModel.$talent
                        .delay(for: .milliseconds(200), scheduler: RunLoop.main) // Introduce a 200ms delay
                        .sink { _ in
                            // Do something when talentViewModel.talent changes
                            // For example, pop the navigation
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        .store(in: &self.cancellables)  // Use 'self' to reference the property
                }
                .padding()
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.yellow))
            }
            .padding()
        }
    }
}
struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        // No need to update the view controller
    }
}
struct TalentAddView_Previews: PreviewProvider {
    static var previews: some View {
        TalentAddView(talentViewModel: TalentViewModel())
    }
}

struct StringPicker: View {
    @Binding var selection: String
    var options: [String]
    
    var body: some View {
        Picker("", selection: $selection) {
            ForEach(options, id: \.self) { option in
                Text(option)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension UIImage {
    func base64String() -> String? {
        return self.jpegData(compressionQuality: 0.5)?.base64EncodedString()
    }
}
