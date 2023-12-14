//
//  ProfilTalent.swift
//  talentahub.ios
//
//  Created by ryadh on 1/12/2023.
//

import SwiftUI

struct ProfilTalentView: View {
    @Environment(\.presentationMode) var presentationMode

    let userId: String
    let userEmail: String
    let userPassword: String
    
    @State private var MessageVisible = false
    @State private var userEmaill: String
    @State private var userPasswordd: String
    @State private var isPasswordVisible = false

    init(userId: String, userEmail: String, userPassword: String) {
        self.userId = userId
        self.userEmail = userEmail
        self.userPassword = userPassword

        _userEmaill = State(initialValue: userEmail)
        _userPasswordd = State(initialValue: userPassword)
    }

    
    var body: some View {
        VStack {
            Text("Mon Profil")
                .font(.title)
                .padding(.top, 16)
                .padding(.bottom, 16)

            HStack {
                Text("Email:")
                    .font(.headline)
                TextField("Entrez votre email", text: $userEmaill)
            }
            .padding(.bottom, 8)

            HStack {
                Text("Mot de passe:")
                    .font(.headline)
                SecureField("Entrez votre mot de passe", text: $userPasswordd)
               
            }
            .padding(.bottom, 16)

            Button(action: {
                updateTalent()
                MessageVisible=true
            }) {
                Text("Modifier")
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.bottom, 16)

            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Retour")
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background(Color.gray)
                    .cornerRadius(8)
            }
        }
        .padding(16)
        .background(
            Image("backprof")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        )
        
        .alert(isPresented: $MessageVisible) {
            Alert(
                title: Text("Update "),
                message: Text("Succeded"),
                dismissButton: .default(Text("OK")) {
                    // Reset failMessageVisible when the user dismisses the alert
                
                    MessageVisible=false
                }
            )
        }
    }

    func updateTalent() {
        guard let url = URL(string: "http://localhost:5002/user/users/\(userId)") else {
            print("Invalid URL")
            return
        }

        let updateData = [
            "email": userEmaill,
            "password": userPasswordd
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: updateData) else {
            print("Failed to serialize JSON data")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if (200..<300).contains(httpResponse.statusCode) {
                    if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let message = responseJSON["message"] as? String {
                        print("API Response: \(message)")
                    }
                } else {
                    print("Error response: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
}

struct ProfilTalentView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilTalentView(userId: "123", userEmail: "initial@email.com", userPassword: "initialPassword")
    }
}
