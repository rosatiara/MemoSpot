//
//  SelectedLocationSheet.swift
//  MemoSpot
//
//  Created by Rosa Tiara Galuh on 21/05/23.
//

import SwiftUI

struct SelectedLocationSheet: View {
    @StateObject var mapData = MapViewModel()
    @State private var showNoteSheet = false
    
    var body: some View {
        ZStack {
            Color("gray").edgesIgnoringSafeArea(.all)
            VStack(spacing: 60) {
                VStack(alignment: .leading, spacing: 10) {
                    if let currentPlace = mapData.places.first {
                        Text(currentPlace.place.name ?? "" ).fontWeight(.bold).font(.system(size: 18))
                    } else {
                        Text("No places available")
                    }

                    Text("Jalan Green Office Park nomor 94, kecamatan Bojongkenyot, Jakarta Tenggara").font(.system(size: 16))
                }
                .padding(.horizontal, 35)
                .foregroundColor(Color("accentColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
                Button("Add Review") {
                    
                }.background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("accentColor"))
                        .frame(width: 326, height: 50)
                )
                .foregroundColor(.black)
            }


        }
    }
}


struct SelectedLocationSheet_Previews: PreviewProvider {
    static var previews: some View {
        SelectedLocationSheet()
    }
}
