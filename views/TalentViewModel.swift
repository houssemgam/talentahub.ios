import Foundation
import UIKit
import Alamofire

class TalentViewModel: ObservableObject {
    
    @Published var talents: [Talent] = []
    @Published var talent: Talent?
    @Published var isLoading = true
    @Published var message: String = ""
    
    private let baseURL = "http://localhost:9090/"
    
    func getAll() {
        AF.request(baseURL + "talent/")
            .validate()
            .responseDecodable(of: [Talent].self) { response in
                switch response.result {
                case .success(let talents):
                    self.talents = talents
                    self.isLoading = false
                case .failure(let error):
                    print(error)
                    self.message = "Error: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
    }
    
    func add(newTalent: Talent, image: UIImage) {
        // Convert the image to data
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            // Handle error if unable to convert image to data
            return
        }

        // Create a multipart form data request
        AF.upload(
            multipartFormData: { multipartFormData in
                // Append other parameters
                multipartFormData.append(Data(newTalent.titrepro.utf8), withName: "titrepro")
                multipartFormData.append(Data(newTalent.teamtalent.utf8), withName: "teamtalent")
                multipartFormData.append(Data(newTalent.email.utf8), withName: "email")
                multipartFormData.append(Data(String(newTalent.cartepro).utf8), withName: "cartepro")
                multipartFormData.append(Data(newTalent.typetalent.utf8), withName: "typetalent")
               

                // Append the image data with the name "affiche"
                multipartFormData.append(imageData, withName: "affiche", fileName: "image.jpg", mimeType: "image/jpeg")
            },
            to: baseURL + "talent/",
            method: .post,
            headers: ["Content-Type": "multipart/form-data"]
        )
        .validate()
        .responseDecodable(of: Talent.self) { response in
            switch response.result {
            case .success(let addedTalent):
                self.talents.append(addedTalent)
                self.isLoading = false
            case .failure(let error):
                print(error)
                self.message = "Error: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }

    
    func delete(talentID: String) {
        AF.request(
            baseURL + "talent/\(talentID)",
            method: .delete,
            headers: ["Content-Type": "application/json"] // Set content type
        )
        .validate()
        .response { response in
            switch response.result {
            case .success:
                self.isLoading = false
                // Handle success as needed
            case .failure(let error):
                print(error)
                self.message = "Error: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
}
