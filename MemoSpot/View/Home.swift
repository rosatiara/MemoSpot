//
//  Home.swift
//  MemoSpot
//
//  Created by Rosa Tiara Galuh on 18/05/23.
//

import SwiftUI
import MapKit
import CoreLocation
import Foundation

struct Home: View {
    @StateObject var mapData = MapViewModel()
    @State var locationManager = CLLocationManager()
    @State var screenWidth = UIScreen.main.bounds.width
    @State var screenHeight = UIScreen.main.bounds.height
    
//    @State private var isSheetPresented = false

    
    var body: some View {
        ZStack { // Zstack map & properties (search bar, change map type)
            MapView()
                .environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)
            VStack {
                // recenter & maptype buttons
                VStack {
                    Button(action: {
                        mapData.recenterMap()
                    }, label: {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding(15)
                            .foregroundColor(Color("accentColor"))
                            .background(Color("gray"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    })
                    Button(action: {
                        mapData.updateMapType()
                    }, label: {
                        Image(systemName: mapData.mapType == .standard ? "network" : "map")
                            .font(.title2)
                            .padding(15)
                            .foregroundColor(Color("accentColor"))
                            .background(Color("gray"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    })
                }.frame(maxWidth: .infinity, alignment: .trailing).padding().offset(y: -20)
                Spacer()
                VStack(spacing: 10) {
                    // search bar
                    HStack(spacing: 20) {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.leading)
                            .foregroundColor(Color("accentColor"))
                        TextField("Search...", text: $mapData.searchedText).colorScheme(.dark).background(Color("gray")).accentColor(Color("accentColor"))
                    }.frame(width: 358, height: 50).background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("gray")))
                    if !mapData.places.isEmpty && mapData.searchedText != "" {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(mapData.places) { place in
                                    VStack(alignment: .leading, spacing: -0) {
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(place.place.name ?? "")
                                                .fontWeight(.semibold)
                                                .font(.system(size: 18))
                                            Text("\(place.place.locality ?? ""), \(place.place.country ?? "")")
                                                .opacity(0.7)
                                                .font(.system(size: 16))
                                        }
                                        .padding(.leading, 16)
                                        .padding(.vertical, 16)
                                        .foregroundColor(.white)
                                        .onTapGesture {
                                            mapData.selectPlace(place: place)
                                        }
                                        Divider()
                                            .overlay(.white)
                                    }
                                    .frame(alignment: .leading)
                                    .transition(.opacity)
                                }
                            }
                            .frame(width: 358)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("gray")))
                        }
                        .frame(alignment: .leading)
                    }

                }
            }
            
        }.onAppear(perform: {
            locationManager.delegate = mapData
            locationManager.requestWhenInUseAuthorization()
        })
        .alert(isPresented: $mapData.permissionDenied, content: {
            Alert(title: Text("Permission denied"),
                  message: Text("Please enable permission in App Settings"),
                  dismissButton: .default(Text("Go to Settings"),
                                          action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
        })
        .onChange(of: mapData.searchedText, perform: { value in
            let delay = 0.3
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if value == mapData.searchedText {
                    self.mapData.searchPlaces()
                }
            }
        })
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
