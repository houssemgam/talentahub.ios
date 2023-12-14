//
//  Login.swift
//  talentahub.ios
//
//  Created by ryadh on 29/11/2023.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var plainPassword = ""
    @State private var showError = false
    @State private var userId: String?
    @State private var role: String?
    @State private var isUserActive = false
    @State private var isTalentActive = false


    var body: some View {
      
            VStack(spacing: 20) {
                Text("TALENTA")
                    .font(.system(size: 55))
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                VStack(spacing: 10) {
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.blue)
                        TextField("Email", text: $email)
                            .padding(.horizontal)
                            .frame(height: 40)
                    }
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
                    .padding(.horizontal)

                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.blue)
                        SecureField("Mot de passe", text: $password)
                            .padding(.horizontal)
                            .frame(height: 40)
                    }
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
                    .padding(.horizontal)

                    Button(action: {
                        signIn()
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                            Text("Se connecter")
                                .foregroundColor(.white)
                        }
                    }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(8)
                        
                    NavigationLink(
                        destination: MainUserView(userId: userId ?? "",userEmail: email ?? "",userPassword: password ?? ""),
                                    isActive: $isUserActive
                                ) {
                                    EmptyView()
                                }

                                NavigationLink(
                                    destination: MainTalent(userId: userId ?? "",userEmail: email ?? "",userPassword: password ?? ""),
                                    isActive: $isTalentActive
                                ) {
                                    EmptyView()
                                }
                   

                    NavigationLink(destination: RegisterView()) {
                        Text("Don't have an account? Sign Up")
                            .foregroundColor(.blue)
                    }
                    
                    NavigationLink(destination: ForgetPasswordView()) {
                        Text("Forget Password?")
                            .foregroundColor(.blue)
                    }
                }
                
                
                .padding()
                .background(Color.gray.opacity(0.5))
                .cornerRadius(16)
                
                .navigationBarTitle("Sign In", displayMode: .inline)
                .alert(isPresented: $showError) {
                    Alert(title: Text("Error"), message: Text("Mot de passe invalide"), dismissButton: .default(Text("OK")))
                }
        }
    }
    
    
    
    
    func signIn() {
        guard let url = URL(string: "http://localhost:5002/auth/login") else {
            print("Invalid URL")
            return
        }

        let parameters = [
            "email": email,
            "password": password
        ]

        guard let postData = try? JSONSerialization.data(withJSONObject: parameters) else {
            print("JSON serialization error")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = postData

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Network error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let responseJSON = try JSONDecoder().decode(ResponseModel.self, from: data)

                if let userId = responseJSON.userId {
                    print("Login successful. User ID: \(userId)")
                    self.userId = userId
                }
                    if let userRole = responseJSON.role {
                        self.role = userRole

                        DispatchQueue.main.async {
                            if userRole == "talent" {
                                                            isTalentActive = true
                                                        } else if userRole == "user" {
                                                            isUserActive = true
                                                        } else {
                            }
                        }
                    
                } else {
                    DispatchQueue.main.async {
                        showError = true
                    }
                    print("Invalid password or server error")
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }

}

struct ResponseModel: Decodable {
    let success: Bool?
    let userId: String?
    let role: String?
    let profile: UserProfile?
}

struct UserProfile: Decodable {
    let email: String?
}







