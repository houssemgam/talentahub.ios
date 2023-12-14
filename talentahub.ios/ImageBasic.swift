//
//  ImageBasic.swift
//  talentahub.ios
//
//  Created by mikhail on 29/11/2023.
import SwiftUI

struct ImageBasic: View {
    var body: some View {
        ZStack {
            Image("k")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Hello, World!")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                
                Button(action: {
                    // Action for the button
                }) {
                    Text("Button")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
    }
}

struct ImageBasic_Previews: PreviewProvider {
    static var previews: some View {
        ImageBasic()
    }
}
