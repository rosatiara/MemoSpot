//
//  CoreDataViewModel.swift
//  MemoSpot
//
//  Created by Rosa Tiara Galuh on 19/05/23.
//

import CoreData
import Foundation
import UIKit
import SwiftUI
import MapKit
import CoreLocation


class CoreDataViewModel: ObservableObject {
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    @Published var placeName: String = ""
    @Published var review: String = ""
    
    let manager = PersistenceController.shared
    
    @Published var placeList: [PlaceEntity] = []
    
    func fetchPlaces() {
        let request = NSFetchRequest<PlaceEntity>(entityName: "PlaceEntity")
        
        withAnimation(Animation.default) {
            do {
                placeList = try manager.container.viewContext.fetch(request)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
        
    func getPlaceReview() -> String {
        guard(!placeList.isEmpty) else { return " " }
        
        return placeList.first!.review ?? "No review"
    }
    
    func getPlaceName() -> String {
        guard(!placeList.isEmpty) else { return " " }
        
        return placeList.first!.placeName ?? "No review"
    }
    
    func addCoordinate(longitude: Double, latitude: Double) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func saveReview() {
        withAnimation(Animation.default) {
            do {
                try manager.container.viewContext.save()
            }
            
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
