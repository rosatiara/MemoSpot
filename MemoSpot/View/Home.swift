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
    
    var body: some View {
        ZStack { // Zstack map & properties (search bar, change map type)
            MapView()
                .environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)
                .onAppear {
                }
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
                VStack(spacing: -20) {
                    // search bar
                    HStack(spacing: -10) {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color("accentColor"))
                        TextField("Search...", text: $mapData.searchedText).colorScheme(.dark).background(Color("gray")).padding(.horizontal, 28).accentColor(Color("accentColor"))
                    }
                    .padding(.horizontal, 28)
                    .frame(width: screenWidth, height: screenHeight * 0.08)
                    .background(Color("gray"))
                    
                }
                if !mapData.places.isEmpty && mapData.searchedText != "" {
                    ScrollView {
                        VStack(alignment: .leading, spacing:-0) {
                            ForEach(mapData.places) { place in
                                VStack(alignment: .leading, spacing: -0) {
                                    Text(place.place.name ?? "")
                                        .bold()
                                        .font(.system(size: 20))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 16)
                                        .padding(.vertical, 12)
                                        .foregroundColor(.white)
                                        .onTapGesture {
                                            mapData.selectPlace(place: place)
                                        }
                                    Divider()
                                        .overlay(.white)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color("gray"))
                    }
                    .padding(.top, -10)
                    .frame(alignment: .leading) // Set alignment to .leading
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
                // open settings app
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
