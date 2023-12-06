import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TabView {
                MyProjectsView()
                    .tabItem {
                        Label("Projects", systemImage: "folder")
                    }
                
                MyEventsView()
                    .tabItem {
                        Label("Events", systemImage: "calendar")
                    }
            }
            .navigationTitle("TalentaHub")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
