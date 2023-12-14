//
//  OtpView.swift
//  talentahub.ios
//
//  Created by ryadh on 12/5/23.
//

import SwiftUI

struct OtpView: View {
    let otpCode: String
      let emailUser: String

      @State private var enteredOtp = ""
      @State private var showAlert = false
      @State private var titleMessage = ""
      @State private var successMessage = ""
      @State private var MessageVisible = false
      @State private var navigateToLogin = false
      @State private var suToLogin = false


      var body: some View {
          VStack {
              Spacer()

              Text("Enter OTP")
                  .font(.title)
                  .foregroundColor(.black)

              TextField("Enter OTP", text: $enteredOtp)
                  .padding()
                  .keyboardType(.numberPad)
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                  .frame(width: 200)

              NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
                  EmptyView()
              }

              Button(action: {
                  checkOtp()
              }) {
                  Text("Next")
                      .padding()
                      .foregroundColor(.white)
                      .background(Color.blue)
                      .cornerRadius(8)
              }
              .padding(.top, 20)

              Spacer()
          }
          .padding()
         
          .alert(isPresented: $MessageVisible) {
              Alert(
                  title: Text(titleMessage),
                  message: Text(successMessage),
                  dismissButton: .default(Text("OK")) {
                      // Reset failMessageVisible when the user dismisses the alert
                  
                      if titleMessage=="Success"{
                          MessageVisible = false
                          InitPasswordUser()
                          navigateToLogin = true
                      }else   {
                          MessageVisible = false
                      }
                  }
              )
          }
          
          
      }

      func checkOtp() {
          
          if enteredOtp == otpCode {
              titleMessage = "Success"
              successMessage = "Password is set to: 00000000"

             MessageVisible = true

              
          } else {
              titleMessage = "Fail"
              successMessage = "Otp is incorrect!"
             MessageVisible = true
          }
      }
    
    func InitPasswordUser() {
        guard let url = URL(string: "http://localhost:5002/user/user/\(emailUser)") else {
            print("Invalid URL")
            return
        }

        let updateData = [
            "password": "00000000"
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

struct OtpView_Previews: PreviewProvider {
    static var previews: some View {
        OtpView(otpCode: "123",emailUser: "123")
    }
}
