import SwiftUI
struct ContentView: View {
    var body: some View {
        NavigationView {
            TabView {
                //TalentListView()
                LoginView()
                    .tabItem {
                        //Label("Events", systemImage: "calendar")
                    }
                
                // MyProjectsView()
                //.tabItem {
                // Label("Projects", systemImage: "folder")
                //}
                
                //MyEventsView()
                // .tabItem {
                //  Label("Events", systemImage: "calendar")
                //}
            }
            // .navigationTitle("")
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
