//
//  ForgetPasswordView.swift
//  talentahub.ios
//
//  Created by ryadh on 12/5/23.
//

import SwiftUI

struct ForgetPasswordView: View {
    @State private var email = ""
    @State private var registrationMessage: String?
    @State private var navigateToNextPage = false
    @State private var otpCode: String?
    @State private var emailUser : String?


    var body: some View {
    
            ZStack {
                Image("background_image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .edgesIgnoringSafeArea(.all)

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

                    

                       

                        Button(action: {
                            forgetPassword()
                        }) {
                            HStack {
                                Image(systemName: "person.badge.plus.fill")
                                Text("Reset Password")
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(8)

                        if let message = registrationMessage {
                            Text(message)
                                .foregroundColor(.white)
                        }

                        NavigationLink(
                            destination: OtpView(otpCode: otpCode ?? "",emailUser: email ?? ""),
                            isActive: $navigateToNextPage
                        ) {
                            EmptyView()
                        }

                        
                        
                    
                        
                        
                       
                    }
                    .padding()
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(16)
                    .padding()
                }
            }
        }
    

    func forgetPassword() {
        guard let url = URL(string: "http://localhost:5002/otp/add") else {
            print("Invalid URL")
            return
        }

        let parameters = [
            "email": email
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
                let responseJSON = try JSONDecoder().decode(RegisterResponsee.self, from: data)
                DispatchQueue.main.async {
                    registrationMessage = responseJSON.message
                    
                    self.otpCode = registrationMessage
                    navigateToNextPage = true

                }
                print("Registration successful. Message: \(responseJSON.message)")
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct RegisterResponsee: Decodable {
    let message: String
}


