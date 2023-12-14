import SwiftUI

struct TalentDetailsView: View {
    var talent: Talent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let imageUrlString = talent.affiche, let imageUrl = URL(string: imageUrlString) {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .black))
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(15)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(15)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 100, height: 100)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(15)
                    .frame(width: 100, height: 100)
            }
            
            Text("Title: \(talent.titrepro)")
                .font(.headline)
            Text("Team: \(talent.teamtalent)")
                .font(.subheadline)
            Text("Email: \(talent.email)")
                .font(.subheadline)
            Text("Professional Card: \(String(talent.cartepro))")
                .font(.subheadline)
            Text("Type of Talent: \(talent.typetalent)")
                .font(.subheadline)
            Text("Material Needs: \(talent.besoinmaterielle)")
                .font(.subheadline)
            
            // You can add more details as needed
            
            Spacer()
        }
        .padding()
        .navigationBarTitle(talent.titrepro, displayMode: .inline)
    }
}

struct TalentDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleTalent = Talent(id: "1",
                                  titrepro: "Sample Title",
                                  teamtalent: "Sample Team",
                                  email: "sample@email.com",
                                  cartepro: 12345,
                                  affiche: "Sample Affiche",
                                  typetalent: "Sample Type",
                                  besoinmaterielle: "Sample Needs")
        
        NavigationView {
            TalentDetailsView(talent: sampleTalent)
        }
    }
}
