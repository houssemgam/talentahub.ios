import SwiftUI

struct TalentListView: View {
    @ObservedObject var talentViewModel: TalentViewModel = TalentViewModel()
    
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        // Handle settings button tap
                    }) {
                        Image(systemName: "gear")
                            .font(.title)
                    }
                    .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text("Talents")
                        .font(.title)
                    
                    Spacer()
                    
                    NavigationLink(destination: TalentAddView(talentViewModel: talentViewModel)) {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.yellow) // Customize the color
                            .cornerRadius(25)
                    }
                }
                .padding()
                
                VStack {
                    if let firstTalent = talentViewModel.talents.first {
                        HStack {
                            NavigationLink(destination: TalentDetailsView(talent: firstTalent)) {
                                TalentBigCardView(
                                    talent: firstTalent,
                                    showAlert: $showAlert,
                                    talentViewModel: talentViewModel
                                )
                            }
                        }
                    }
                    
                    HStack {
                        Text("Previous events:")
                            .font(.title)
                        
                        Spacer()
                    }
                    .padding()
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(talentViewModel.talents) { talent in
                                if let firstTalentID = talentViewModel.talents.first?.id, firstTalentID != talent.id {
                                    NavigationLink(destination: TalentDetailsView(talent: talent)) {
                                        TalentCardView(
                                            talent: talent,
                                            showAlert: $showAlert,
                                            talentViewModel: talentViewModel
                                        )
                                    }
                                }
                            }
                        }
                    }
                    .padding(.leading)
                }
               // .background(Color(UIColor(hex: "#EEEEEE")!))
                
                Spacer()
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .onAppear {
                talentViewModel.getAll()
            }
        }
        .navigationBarHidden(true)
    }
}

struct TalentBigCardView: View {
    var talent: Talent
    @Binding var showAlert: Bool
    @ObservedObject var talentViewModel: TalentViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button(action: {
                    // Action for the "Follow" button
                }) {
                    HStack {
                        Image(systemName: "person.badge.plus")
                            .foregroundColor(.black)
                        Text("Follow")
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.yellow, lineWidth: 2))
                    .background(Color.white)
                }
                
                Button(action: {
                    // Action for the "Connect" button
                }) {
                    HStack {
                        Image(systemName: "link")
                            .foregroundColor(.black)
                        Text("Connect")
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.yellow, lineWidth: 2))
                    .background(Color.white)
                }
            }
            .padding()
            
            HStack {
           //     AsyncImage(
             //       url: talent.affiche,
               //     placeholder: { ProgressView() },
                //    image: { Image(uiImage: $0).resizable() }
               // )
              //  .cornerRadius(15)
              //  .frame(width: 130, height: 200)
               // .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    Spacer()
                    
                    Text(talent.titrepro)
                        .font(.title)
                        .foregroundColor(.black)
                        .padding()
                    
                    Text("Type talent: " + talent.typetalent)
                        .font(.headline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    
                    Text("Email: " + talent.email)
                        .font(.headline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    
                    Text("Carte pro: \(talent.cartepro)")
                        .font(.headline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    
                    //Text("Besoin materiel: \(talent.besoinmateriel)")
                        .font(.headline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Button(action: {
                        showAlert = true
                    }) {
                        Image(systemName: "trash")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Confirm Deletion"),
                            message: Text("Are you sure you want to delete this talent?"),
                            primaryButton: .destructive(Text("Delete")) {
                              //  talentViewModel.delete(talent: talent)
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    .padding(.bottom)
                }
            }
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct TalentCardView: View {
    var talent: Talent
    @Binding var showAlert: Bool
    @ObservedObject var talentViewModel: TalentViewModel
    
    var body: some View {
        VStack {
       //     AsyncImage(
         //       url: talent.affiche,
            //    placeholder: { ProgressView() },
           ///     image: { Image(uiImage: $0).resizable() }
           // )
       //     .cornerRadius(15)
         //   .frame(width: 130, height: 200)
           // .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Spacer()
                
                Text(talent.titrepro)
                    .font(.title)
                    .foregroundColor(.black)
                    .padding()
                
                Text("Type talent: " + talent.typetalent)
                    .font(.headline)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Button(action: {
                    showAlert = true
                }) {
                    Image(systemName: "trash")
                        .font(.title)
                        .foregroundColor(.red)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Confirm Deletion"),
                        message: Text("Are you sure you want to delete this talent?"),
                        primaryButton: .destructive(Text("Delete")) {
                       //     talentViewModel.delete(talent: talent)
                        },
                        secondaryButton: .cancel()
                    )
                }
                .padding(.bottom)
            }
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}
