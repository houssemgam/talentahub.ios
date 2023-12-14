//
//  MainTalent.swift
//  talentahub.ios
//
//  Created by ryadh on 29/11/2023.
//

import SwiftUI

struct MainTalent: View {
    @State private var isShowingProfil = false
    let userId: String
    let userEmail: String
    let userPassword: String

    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Options")) {
                    NavigationLink(destination: ProfilTalentView(userId: userId ?? "", userEmail: userEmail ?? "", userPassword: userPassword ?? ""), isActive: $isShowingProfil) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(25)
                            Text("Mon Profil")
                                .padding()
                                .foregroundColor(.blue)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button(action: {
                        handleLogout()
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.square")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(8)
                            Text("Déconnexion")
                                .padding()
                                .foregroundColor(.green)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button(action: {
                        showAlert = true
                    }) {
                        HStack {
                            Image(systemName: "trash.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(25)
                            Text("Supprimer compte")
                                .padding()
                                .foregroundColor(.red)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .confirmationDialog("Confirmation", isPresented: $showAlert) {
                        Button("Confirmer") {
                            deleteTalent()
                            handleLogout()
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .background(Image("backprof").resizable().edgesIgnoringSafeArea(.all))
            .navigationBarTitle("BIENVENU TALENT", displayMode: .inline)
        }
    }
    
    private func handleLogout() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    
    func deleteTalent() {
        guard let url = URL(string: "http://localhost:5002/user/users/\(userId)") else {
            print("Invalid URL")
            return
        }

    

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

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


struct MainTalentView_Previews: PreviewProvider {
    static var previews: some View {
        MainTalent(userId: "123", userEmail: "123", userPassword: "123")
    }
}
