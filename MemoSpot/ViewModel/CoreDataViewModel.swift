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
    
    // check if there is no data added yet
    func isPlaceEmpty() -> Bool {
        return placeList.isEmpty
    }
    
    func getPlaceName() -> String {
        if isPlaceEmpty() {
            return "Empty"
        }
        else {
            return placeList.first!.placeName ?? "error"

        }
    }
    
    func addPlaceName(name: String) -> String {
        let newPlace = PlaceEntity(context: manager.container.viewContext)
        newPlace.placeName = name
        save()
        fetchPlaces()
        return name
    }
    
    func save() {
        withAnimation(Animation.default) {
            do {
                try manager.container.viewContext.save()
            }
            
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // executed when 'Save Review' button clicked
    func saveCoordinate(latitude: Double, longitude: Double) {
    }

}
