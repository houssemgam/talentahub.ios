import SwiftUI


struct ProjectListView: View {
    @State var projects: [project] = [] // Change 'project' to 'Project'
    @State private var isAddingProject = false // Used to present the project adding view

    @State private var selectedProject: project?
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(projects, id: \.id) { project in
                        VStack(alignment: .leading, spacing: 8) {
                            // Use a ProjectCardView with a featured image
                            ProjectCardView(project: project)
                                .onTapGesture {
                                    selectedProject = project // Select the project when tapped
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
                // Display details of the selected project in a dedicated view (Sheet)
                ProjectDetailView(project: project)
            }
            .sheet(isPresented: $isAddingProject) {
                AddProjectView() // Open AddProjectView when isAddingProject is true
            }
            Spacer()
            
        }
        .overlay(
            VStack {
                Spacer()
                Button(action: {
                    isAddingProject = true // Activate project adding
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .padding()
                        .frame(width: 20, height: 20) // Adjust icon size as needed
                        .foregroundColor(Color(red: 0.36, green: 0.7, blue: 0.36)) // Icon color // Choose the appropriate color
                        .imageScale(.large) // Choose the scale
                }
            }
        )
    }
}

struct ProjectCardView: View {
    let project: project

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImageView(url: project.image)
                .frame(height: 200) // Size of the featured image

            Text(project.title)
                .font(.headline)
                .foregroundColor(.primary)

            Text("Date: \(formattedDate(date: project.date))")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text("Description: \(project.description)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
// Format date as needed
  private func formattedDate(date: Date) -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateStyle = .short
      return dateFormatter.string(from: date)
  }


struct ProjectDetailView: View {
    let project: project
    @State private var isFavorite: Bool = false

    var body: some View {
        VStack {
            Text(project.title)
                .font(.title)
                .padding()

            AsyncImageView(url: project.image)
                .frame(maxWidth: .infinity, maxHeight: 200)
                .padding()
                .shadow(radius: 4)

            HStack {
                Button(action: {
                    isFavorite.toggle()
                    // Add code here to save the project as a favorite
                }, label: {
                    HStack {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .foregroundColor(.white)
                        Text(isFavorite ? "Unmark as Favorite" : "Mark as Favorite")
                            .foregroundColor(.white)
                    }
                })
                .padding()
                .background(Color(red: 0.36, green: 0.7, blue: 0.36))
                .cornerRadius(10)

                Button(action: {
                    // Add action for sharing the project
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.white)
                })
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }

            Text("Date: \(formattedDate(date: project.date))")
                .font(.headline)
                .padding(.horizontal)

            Text("Description: \(project.description)")
                .font(.body)
                .padding()

            Spacer()
        }
        .navigationBarTitle(Text("Project Details"), displayMode: .inline)
    }

    // Format date as needed
    private func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
    }
}

func fetchProjects() {
    guard let url = URL(string: "http://localhost:5001/api/projects") else {
        print("Invalid URL")
        return
    }

    URLSession.shared.dataTask(with: url) { data, _, error in
        if let error = error {
            print("Error fetching projects: \(error)")
            return
        }

        guard let data = data else {
            print("No data found")
            return
        }

        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let jsonDictionary = json as? [String: Any], let projectList = jsonDictionary["list"] as? [[String: Any]] {
                let jsonData = try JSONSerialization.data(withJSONObject: projectList)
                let fetchedProjects = try decoder.decode([project].self, from: jsonData) // Change 'project' to 'Project'
                DispatchQueue.main.async {
                    self.projects = fetchedProjects
                }
            } else {
                print("JSON structure doesn't match")
            }
        } catch {
            print("JSON decoding error: \(error)")
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
            // Placeholder image or loading indicator
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

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView() // Provide a type annotation if necessary
    }
}
