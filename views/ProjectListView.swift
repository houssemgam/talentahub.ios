import SwiftUI

struct ProjectListView: View {
    @State var projects: [Project] = []
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

    func fetchProjects() {
        guard let url = URL(string: "http://localhost:5001/api/projects") else {
            print("Invalid URL")
            return
        }

        fetchData(from: url, decodingType: [Project].self) { result in
            switch result {
            case .success(let fetchedProjects):
                DispatchQueue.main.async {
                    self.projects = fetchedProjects
                }
            case .failure(let error):
                print("Error fetching projects: \(error)")
            }
        }
    }

    struct ProjectCardView: View {
        let project: Project

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                AsyncImageView(url: project.imageURL)
                    .frame(height: 200)

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

        private func formattedDate(date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            return dateFormatter.string(from: date)
        }
    }

    struct ProjectDetailView: View {
        let project: Project
        @State private var isFavorite: Bool = false

        var body: some View {
            VStack {
                Text(project.title)
                    .font(.title)
                    .padding()

                AsyncImageView(url: project.imageURL)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .padding()
                    .shadow(radius: 4)

                HStack {
                    Button(action: {
                        isFavorite.toggle()
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
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView()
    }
}

// Format date as needed
func formattedDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    return dateFormatter.string(from: date)
}

func fetchData<T: Decodable>(from url: URL, decodingType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
    URLSession.shared.dataTask(with: url) { data, _, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data else {
            completion(.failure(NSError(domain: "AppError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data found"])))
            return
        }

        do {
            let decodedData = try JSONDecoder().decode(decodingType, from: data)
            completion(.success(decodedData))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}
