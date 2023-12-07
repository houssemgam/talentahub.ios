import SwiftUI

struct MyProjectsView: View {
    @State var projects: [Project] = [] // Make sure Project is defined as per your model
    @State private var isAddingProject = false
    
    @State private var selectedProject: Project?
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(projects, id: \.id) { project in
                        VStack(alignment: .leading, spacing: 8) {
                            ProjectCardView(project: project)
                                .onTapGesture {
                                    selectedProject = project
                                }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 16)
            }
            
            .navigationBarTitle("Projects")
            .onAppear {
                fetchProjects()
            }
            
            .sheet(item: $selectedProject) { project in
                ProjectDetailView(project: project)
            }
            .sheet(isPresented: $isAddingProject) {
                AddProjectView()
            }
            Spacer()
            
        }
        .overlay(
            VStack {
                Spacer()
                Button(action: {
                    isAddingProject = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .padding()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(red: 0.36, green: 0.7, blue: 0.36))
                        .imageScale(.large)
                }
            }
        )
    }
    struct ProjectCardView: View {
        let project: Project

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                AsyncImageView(url: project.image)
                    .frame(maxWidth: .infinity)
                    .frame(height: 218)
                    .cornerRadius(20)
                    .overlay(
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text(project.title)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(8)
                            }
                        }
                    )
                    .padding(.bottom, 8)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Description:")
                        .font(.headline)
                        .foregroundColor(.gray)

                    Text(project.description)
                        .font(.body)
                        .foregroundColor(.primary)

                    Text("Exigence:")
                        .font(.headline)
                        .foregroundColor(.gray)

                    Text(project.exigence)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding([.leading, .trailing], 16)
                .padding(.bottom, 16)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.gray.opacity(0.3), radius: 8, x: 0, y: 4)
            )
            .padding([.leading, .trailing], 16)
        }
    }

    struct ProjectDetailView: View {
        let project: Project
        @State private var message: String = ""

        var body: some View {
            ScrollView {
                VStack(alignment: .center, spacing: 16) { // Align content to the center
                    Text(project.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .multilineTextAlignment(.center)

                    AsyncImageView(url: project.image)
                        
                        .cornerRadius(16)
                        .shadow(radius: 4)

                    Text("Description:")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 4)

                    Text(project.description)
                        .font(.body)
                        .foregroundColor(.primary)

                    Text("Exigence:")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 4)

                    Text(project.exigence)
                        .font(.body)
                        .foregroundColor(.primary)

                    Text("Detail:")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 4)

                    Text(project.detail)
                        .font(.body)
                        .foregroundColor(.primary)

                  

                    HStack {
                        Spacer() // Add spacer to push the button to the right
                        TextField("Enter your message", text: $message)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    }
                    .padding()
                }
                        Button(action: {
                            // Handle send button action
                            // You can access the message using self.message
                        })
                 
                        {
                            Text("Send")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding()

            
            .navigationBarTitle(Text("Project Details"), displayMode: .inline)
        }

        private func formattedDate() -> String {
            guard let date = project.date else {
                return "N/A"
            }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        }
    }

    func fetchProjects() {
        guard let url = URL(string: "http://localhost:5001/api/projects") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching projects: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            decoder.dateDecodingStrategy = .formatted(dateFormatter)

            do {
                let jsonResponse = try decoder.decode([String: [Project]].self, from: data)

                if let projectsArray = jsonResponse["message"] {
                    DispatchQueue.main.async {
                        self.projects = projectsArray
                    }
                } else {
                    print("Error extracting projects from JSON")
                }
            } catch {
                print("Error decoding projects: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received JSON: \(jsonString)")
                } else {
                    print("Unable to convert JSON data to string")
                }
            }
        }.resume()
    }

       struct AsyncImageView: View {
           @StateObject private var imageLoader: ImageLoader

           init(url: String) {
               let urlString = "http://localhost:5001/" + url
               _imageLoader = StateObject(wrappedValue: ImageLoader(url: urlString))
           }

           var body: some View {
               if let uiImage = imageLoader.image {
                   Image(uiImage: uiImage)
                       .resizable()
                       .aspectRatio(contentMode: .fit)
               } else {
                   ProgressView()
                       .progressViewStyle(CircularProgressViewStyle())
               }
           }
       }

       class ImageLoader: ObservableObject {
           @Published var image: UIImage?

           init(url: String) {
               guard let imageURL = URL(string: url) else { return }

               URLSession.shared.dataTask(with: imageURL) { data, response, error in
                   if let data = data, let loadedImage = UIImage(data: data) {
                       DispatchQueue.main.async {
                           self.image = loadedImage
                       }
                   }
               }.resume()
           }
       }

       struct MyProjectsView_Previews: PreviewProvider {
           static var previews: some View {
               MyProjectsView()
           }
       }
   }
