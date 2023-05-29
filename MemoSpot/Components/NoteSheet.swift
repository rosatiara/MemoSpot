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
                    guard let selectedPlace = mapData.selectedPlace else {
                        return
                    }
                    
                    viewModel.saveNote(
                        longitude: selectedPlace.place.location?.coordinate.longitude ?? 0.0,
                        latitude: selectedPlace.place.location?.coordinate.latitude ?? 0.0,
                        placeName: selectedPlace.place.name ?? "",
                        placeNote: reviewText
                    )
                    viewModel.fetchPlaces()
                }.background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("action"))
                        .frame(width: 326, height: 50)
                )
                .foregroundColor(.black)
                .onDisappear {
                    viewModel.fetchPlaces()
                }
            }
            
        }
        .onAppear {
            DispatchQueue.main.async {
                viewModel.fetchPlaces()
            }
        }
    }
}

struct NoteSheet_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
