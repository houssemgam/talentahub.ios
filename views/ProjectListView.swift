import SwiftUI

struct Project: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let description: String
    let exigence: String
    let detail: String
    let image: String
}

struct ProjectListView: View {
    let projects: [Project] = [
        Project(title: "Portrait Painting", date: Date(), description: "Create a realistic portrait painting using oil colors.", exigence: "Capture the likeness and expression of the subject.", detail: "The painting will be executed on a canvas using traditional oil painting techniques.", image: "paint"),
        Project(title: "Digital Illustration", date: Date(), description: "Produce a vibrant digital illustration for a book cover.", exigence: "Portray the theme and atmosphere of the book.", detail: "The illustration will be created using digital drawing software and a graphics tablet.", image: "Digital"),
        Project(title: "Sculpture Installation", date: Date(), description: "Design and fabricate a large-scale sculpture installation for a public space.", exigence: "Create an engaging and interactive experience for viewers.", detail: "The sculpture will be constructed using metal and other materials, incorporating kinetic elements.", image: "Sculpture"),
        Project(title: "Photography Exhibition", date: Date(), description: "Curate and organize a photography exhibition showcasing local talent.", exigence: "Highlight diverse photographic styles and themes.", detail: "The exhibition will feature a selection of photographs displayed in a gallery setting.", image: "photography"),
        Project(title: "Street Art Mural", date: Date(), description: "Paint a large-scale mural on a public wall in a cityscape.", exigence: "Reflect the cultural context and engage with the local community.", detail: "The mural will be created using spray paint and stencils, incorporating vibrant colors and bold imagery.", image: "street")
    ]
    
    @State private var selectedProject: Project?
    @State private var isAddingProject = false
    
    var body: some View {
        NavigationView {
            List(projects) { project in
                ProjectListItemView(project: project)
                    .onTapGesture {
                        selectedProject = project
                    }
            }
            .navigationTitle("Projects")
            .sheet(item: $selectedProject) { project in
                ProjectDetailView(project: project)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddingProject = true
                    }) {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
        }
        .accentColor(.purple)
        .sheet(isPresented: $isAddingProject) {
            AddProjectView()
        }
    }
}

struct addProjectView: View {
    var body: some View {
        Text("Add Project View")
    }
}

struct ProjectListItemView: View {
    let project: Project
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer()
                Image(project.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .cornerRadius(8)
                    .clipped()
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(project.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(project.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(project.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text(project.exigence)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

struct ProjectDetailView: View {
    let project: Project
    @State private var message: String = ""

    var body: some View {
        VStack(spacing: 16) {
            Image(project.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 8) {
                Text("Title")
                    .font(.headline)
                Text(project.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Text("Date")
                    .font(.headline)
                Text(project.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("Description")
                    .font(.headline)
                Text(project.description)
                    .font(.body)
                    .foregroundColor(.secondary)

                Text("Exigence")
                    .font(.headline)
                Text(project.exigence)
                    .font(.body)
                    .foregroundColor(.secondary)

                Text("Detail")
                    .font(.headline)
                Text(project.detail)
                    .font(.body)
                    .foregroundColor(.secondary)

                Divider()

                Text("Message")
                    .font(.headline)
                TextField("Enter your message", text: $message)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    // Perform action when the send button is tapped
                    sendMessage()
                }) {
                    Text("Send")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
        }
        .padding()
    }

    private func sendMessage() {
        // Implement your logic to send the message
        print("Sending message: \(message)")
    }
}
