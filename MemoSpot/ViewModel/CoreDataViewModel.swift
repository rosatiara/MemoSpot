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
    @Published var placeNote: String = ""
    
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
    
    func addPlaceCoordinate(longitude: Double, latitude: Double) {
    }
    
    
    func savePlace(longitude: Double, latitude: Double, placeName: String, placeNote: String) {
        let newNote = PlaceEntity(context: manager.container.viewContext)
        newNote.latitude = latitude
        newNote.longitude = longitude
        newNote.placeName = placeName
        newNote.placeNote = placeNote
        
        save()
        fetchPlaces()
    }
    
    func isDataEmpty() -> Bool {
        return placeList.isEmpty
    }
    
    func addPlaceNameData(placeName: String) {
        let newPlaceName = PlaceEntity(context: manager.container.viewContext)
        newPlaceName.placeName = placeName
        
        save()
        fetchPlaces()
    }
    
    func addNoteData(note: String) {
        let newNote = PlaceEntity(context: manager.container.viewContext)
        newNote.placeNote = note
        save()
        fetchPlaces()
    }
    
    func addPlaceCoordinateData(longitude: Double, latitude: Double) {
        let newPlaceCoordinate = PlaceEntity(context: manager.container.viewContext)
        
        newPlaceCoordinate.longitude = longitude
        newPlaceCoordinate.latitude = latitude
        
        save()
        fetchPlaces()
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
    
    
    
}
