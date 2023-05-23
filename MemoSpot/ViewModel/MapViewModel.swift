//
//  MapViewModel.swift
//  MemoSpot
//
//  Created by Rosa Tiara Galuh on 18/05/23.
//

import SwiftUI
import MapKit
import CoreLocation

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var mapView = MKMapView()
    @Published var region: MKCoordinateRegion!
    @Published var permissionDenied = false
    @Published var mapType: MKMapType = .standard
    @Published var searchedText = ""
    @Published var places: [Place] = []
    @Published var selectedPlace: Place?
    @Published var selectedPlaceAddress: Place?
    @Published var annotations: [MKPointAnnotation] = []
    
    
    // location permission
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied:
            permissionDenied.toggle()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            manager.requestLocation()
        default:
            ()
            
        }
    }
    
    // error checking
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // current user's location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        self.mapView.setRegion(self.region, animated: true)
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
    }
    
    // change map type
    func updateMapType() {
        if mapType == .standard {
            mapType = .hybrid
            mapView.mapType = mapType
        } else {
            mapType = .standard
            mapView.mapType = mapType
        }
    }
    
    // recenter map to current location
    func recenterMap() {
        guard let _ = region else {
            return
        }
        mapView.setRegion(region, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
    
    // display search results
    func searchPlaces() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchedText
        
        MKLocalSearch(request: request).start { (response, _) in
            guard let result = response else {return}
            
            self.places = result.mapItems.compactMap({ (item) -> Place? in
                return Place(place: item.placemark)
            })
        }
    }
    
    func selectPlace(place: Place) {
        searchedText = ""
        guard let coordinate = place.place.location?.coordinate else { return }
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        pointAnnotation.title = place.place.name ?? "No name"
        
        
        mapView.addAnnotation(pointAnnotation)
        
        // map scale view
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
        
        // get address from selected place
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        // for address
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else {
                print("Reverse geocoding error:", error!.localizedDescription)
                return
            }
            guard let placemark = placemarks?.first else {
                print("No placemark found for the location")
                return
            }
            
            let address = self.formatAddress(placemark: placemark) // address formatting
            DispatchQueue.main.async {
                self.selectedPlace = place
                self.selectedPlace?.address = address
            }
        }
        
        let name = pointAnnotation.title ?? "No name"
        let longitude = location.coordinate.longitude
        let latitude = location.coordinate.latitude
        
        
    }
    
    // format address with comma separator
    private func formatAddress(placemark: CLPlacemark) -> String {
        var addressComponents: [String] = []
        
        if let thoroughfare = placemark.thoroughfare {
            addressComponents.append(thoroughfare)
        }
        if let subThoroughfare = placemark.subThoroughfare {
            addressComponents.append(subThoroughfare)
        }
        if let locality = placemark.locality {
            addressComponents.append(locality)
        }
        if let administrativeArea = placemark.administrativeArea {
            addressComponents.append(administrativeArea)
        }
        if let postalCode = placemark.postalCode {
            addressComponents.append(postalCode)
        }
        if let country = placemark.country {
            addressComponents.append(country)
        }
        
        return addressComponents.joined(separator: ", ")
    }
    
    func addAnnotationMarker(latitude: Double, longitude: Double, title: String) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        pointAnnotation.title = title
        
        annotations.append(pointAnnotation)
        
        // update the map view with all stored annotations
        mapView.addAnnotations(annotations)
        
        // set region to show the annotation
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
    
}

/*
 Get address (reverse geocoding)
 https://stackoverflow.com/questions/52519860/how-to-convert-coordinates-to-address-using-swift
 
 */

