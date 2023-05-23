//
//  NoteSheet.swift
//  MemoSpot
//
//  Created by Rosa Tiara Galuh on 21/05/23.
//

import SwiftUI

struct NoteSheet: View {
    @State private var reviewText = ""
    @EnvironmentObject var mapData: MapViewModel
    
    @StateObject private var viewModel = CoreDataViewModel()
    var body: some View {
        ZStack {
            Color("gray").edgesIgnoringSafeArea(.all)
            VStack(spacing: 60) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(mapData.selectedPlace?.place.name ?? "No Place Selected").fontWeight(.bold).font(.system(size: 24))
                    TextField("Write your review..", text: $reviewText).foregroundColor(Color("detail")).accentColor(Color("detail")).font(.system(size: 18))
                }
                .padding(.horizontal, 35)
                .foregroundColor(Color("AccentColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button("Save Note") {
                    
                    // savePinCoordinate() 
                }.background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("action"))
                        .frame(width: 326, height: 50)
                )
                .foregroundColor(.black)
            }

        }
        .onAppear {
            DispatchQueue.main.async {
                reviewText = viewModel.getNote()
            }
        }
    }
}

struct NoteSheet_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
