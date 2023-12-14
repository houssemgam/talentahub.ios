import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var selectedRole = 0
    @State private var registrationMessage: String?
    @State private var navigateToNextPage = false
    let roles = ["user", "talent"]

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

                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.blue)
                            SecureField("Mot de passe", text: $password)
                                .padding(.horizontal)
                                .frame(height: 40)
                        }
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
                        .padding(.horizontal)

                        Picker(selection: $selectedRole, label: Text("Role")) {
                            ForEach(0..<roles.count) { index in
                                Text(roles[index])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)

                        Button(action: {
                            register()
                        }) {
                            HStack {
                                Image(systemName: "person.badge.plus.fill")
                                Text("Inscription")
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
                            destination: LoginView(),
                            isActive: $navigateToNextPage
                        ) {
                            EmptyView()
                        }

                        
                        
                        Button(action: {

                        }) {
                            NavigationLink(destination: LoginView()) {
                                HStack {
                                    Image(systemName: "arrow.right.circle.fill")
                                    Text("Se connecter")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(8)
                        
                        
                       
                    }
                    .padding()
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(16)
                    .padding()
                }
            }
        }
    

    func register() {
        guard let url = URL(string: "http://localhost:5002/auth/register") else {
            print("Invalid URL")
            return
        }

        let parameters = [
            "email": email,
            "password": password,
            "role": roles[selectedRole]
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
                let responseJSON = try JSONDecoder().decode(RegisterResponse.self, from: data)
                DispatchQueue.main.async {
                    registrationMessage = responseJSON.message

                    if responseJSON.message == "Utilisateur créé avec succès" {
                        navigateToNextPage = true
                    }
                }
                print("Registration successful. Message: \(responseJSON.message)")
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct RegisterResponse: Decodable {
    let message: String
}


