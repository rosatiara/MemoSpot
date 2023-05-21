//
//  MapView.swift
//  MemoSpot
//
//  Created by Rosa Tiara Galuh on 18/05/23.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    @EnvironmentObject var mapData: MapViewModel
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            // customized pin
            if annotation.isKind(of: MKUserLocation.self) {
                return nil
            } else {
                let pinAnnotation = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "PIN_VIEW")
                pinAnnotation.tintColor = .green
                pinAnnotation.animatesWhenAdded = true
                pinAnnotation.canShowCallout = true                
                return pinAnnotation
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let view = mapData.mapView
        
        view.showsUserLocation = true
        view.delegate = context.coordinator
        
        return view
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
