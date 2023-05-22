//
//  SelectedLocationSheet.swift
//  MemoSpot
//
//  Created by Rosa Tiara Galuh on 21/05/23.
//

import SwiftUI

struct SelectedLocationSheet: View {
    @EnvironmentObject var mapData: MapViewModel
    @State private var showNoteSheet = false
    
    var body: some View {
        ZStack {
            Color("gray").edgesIgnoringSafeArea(.all)
            VStack(spacing: 60) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(mapData.selectedPlace?.place.name ?? "No Place Selected")
                        .bold()
                        .font(.system(size: 18))
                    Text(mapData.selectedPlace?.address ?? "").font(.system(size: 16))
                }
                .padding(.horizontal, 35)
                .foregroundColor(Color("AccentColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
                Button("Add Review") {
                    showNoteSheet = true
                }.background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("AccentColor"))
                        .frame(width: 326, height: 50)
                )
                .foregroundColor(.black)
                .sheet(isPresented: $showNoteSheet) {
                    NoteSheet().presentationDetents([.fraction(0.4)]) // to make sheet smaller
                }
            }
            
        }
    }
}


//struct SelectedLocationSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectedLocationSheet()
//    }
//}
