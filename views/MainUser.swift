import SwiftUI

struct MainUserView: View {
    @State private var isShowingProfile = false
    @State private var showAlert = false
    let userId: String
    let userEmail: String
    let userPassword: String

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ZStack {
                Image("backprof")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Spacer()

                    Button(action: {
                        isShowingProfile = true
                    }) {
                        ButtonWithIcon(imageName: "person.circle.fill", color: .blue, text: "Mon Profil")
                    }
                    .buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: $isShowingProfile) {
                        ProfilUserView(userId: userId, userEmail: userEmail, userPassword: userPassword)
                    }

                    Button(action: {
                        showAlert = true
                    }) {
                        ButtonWithIcon(imageName: "trash.circle.fill", color: .red, text: "Supprimer compte")
                    }
                    .buttonStyle(PlainButtonStyle())
                    .confirmationDialog("Confirmation", isPresented: $showAlert) {
                        Button("Confirmer") {
                            deleteUser()
                            handleLogout()
                        }
                    }

                    NavigationLink(destination: MyEventsView()) {
                        ButtonWithIcon(imageName: "calendar", color: .green, text: "Events")
                    }

                    NavigationLink(destination: MyProjectsView()) {
                        ButtonWithIcon(imageName: "hammer", color: .orange, text: "Projects")
                    }

                    Spacer()

                    Button(action: {
                        handleLogout()
                    }) {
                        ButtonWithIcon(imageName: "arrow.right.square", color: .green, text: "Déconnexion")
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationBarTitle("BIENVENUE USER", displayMode: .inline)
        }
    }

    private func handleLogout() {
        self.presentationMode.wrappedValue.dismiss()
    }

    private func deleteUser() {
        // Code pour supprimer le compte de l'utilisateur
    }
}

struct MainUserView_Previews: PreviewProvider {
    static var previews: some View {
        MainUserView(userId: "123", userEmail: "123", userPassword: "123")
    }
}

struct ButtonWithIcon: View {
    let imageName: String
    let color: Color
    let text: String

    var body: some View {
        HStack {
            Image(systemName: imageName)
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(color)
                .cornerRadius(25)
            Text(text)
                .foregroundColor(color)
                .font(.headline)
        }
    }
}
