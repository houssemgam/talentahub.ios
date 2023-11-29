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
        Project(title: "Portrait Painting", date: Date(), description: "Create a realistic portrait painting using oil colors.", exigence: "Capture the likeness and expression of the subject.", detail: "The painting will be executed on a canvas using traditional oil painting techniques.", image: "portrait_painting"),
        Project(title: "Digital Illustration", date: Date(), description: "Produce a vibrant digital illustration for a book cover.", exigence: "Portray the theme and atmosphere of the book.", detail: "The illustration will be created using digital drawing software and a graphics tablet.", image: "digital_illustration"),
        Project(title: "Sculpture Installation", date: Date(), description: "Design and fabricate a large-scale sculpture installation for a public space.", exigence: "Create an engaging and interactive experience for viewers.", detail: "The sculpture will be constructed using metal and other materials, incorporating kinetic elements.", image: "sculpture_installation"),
        Project(title: "Photography Exhibition", date: Date(), description: "Curate and organize a photography exhibition showcasing local talent.", exigence: "Highlight diverse photographic styles and themes.", detail: "The exhibition will feature a selection of photographs displayed in a gallery setting.", image: "photography_exhibition"),
        Project(title: "Street Art Mural", date: Date(), description: "Paint a large-scale mural on a public wall in a cityscape.", exigence: "Reflect the cultural context and engage with the local community.", detail: "The mural will be created using spray paint and stencils, incorporating vibrant colors and bold imagery.", image: "street_art_mural")
    ]
    
    @State private var selectedProject: Project?
    
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
        }
        .accentColor(.purple)
    }
}

struct ProjectListItemView: View {
    let project: Project
    
    var body: some View {
        HStack(spacing: 16) {
            Image(project.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(project.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
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
    
    var body: some View {
        VStack(spacing: 16) {
            Image(project.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Title:")
                    .font(.headline)
                Text(project.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Date:")
                    .font(.headline)
                Text(project.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Description:")
                    .font(.headline)
                Text(project.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Text("Exigence:")
                    .font(.headline)
                Text(project.exigence)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .navigationTitle("Project Details")
    }
}

