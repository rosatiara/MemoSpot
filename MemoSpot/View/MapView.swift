//
//  MapView.swift
//  MemoSpot
//
//  Created by Rosa Tiara Galuh on 18/05/23.
//

import SwiftUI
import MapKit
import Foundation

struct MapView: UIViewRepresentable {
    
    @EnvironmentObject var mapData: MapViewModel
    @FetchRequest(entity: PlaceEntity.entity(), sortDescriptors: []) var placeList: FetchedResults<PlaceEntity>
    
    class Coordinator: NSObject, MKMapViewDelegate {
        let mapData: MapViewModel
        
        init(mapData: MapViewModel) {
            self.mapData = mapData
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !annotation.isKind(of: MKUserLocation.self) else {
                return nil
            }
            
            let identifier = "CustomAnnotationView"
            var pinAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if pinAnnotation == nil {
                pinAnnotation = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                pinAnnotation?.canShowCallout = true
                
                let detailLabel = UILabel()
                detailLabel.numberOfLines = 0 /// allow multiple lines of text
                detailLabel.font = UIFont.systemFont(ofSize: 12)
                detailLabel.text = annotation.subtitle ?? ""
                pinAnnotation?.detailCalloutAccessoryView = detailLabel
            } else {
                pinAnnotation?.annotation = annotation
            }
            return pinAnnotation
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(mapData: mapData)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let view = mapData.mapView
        
        view.showsUserLocation = true
        view.delegate = context.coordinator
        
        return view
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        for place in placeList {
            let coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            /// for callout
            annotation.title = place.placeName
            annotation.subtitle = place.placeNote
            uiView.addAnnotation(annotation)
        }
    }
    
}
