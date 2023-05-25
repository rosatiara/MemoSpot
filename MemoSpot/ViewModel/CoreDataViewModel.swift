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
    
    @Published var placeList: [PlaceEntity] = []
    let manager = PersistenceController.shared
    
    func fetchPlaces() {
        let request: NSFetchRequest<PlaceEntity> = PlaceEntity.fetchRequest()
        
        do {
            placeList = try manager.container.viewContext.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
        print(placeList)
    }
    
    func isDataEmpty() -> Bool {
        return placeList.isEmpty
    }
    
    func addPlaceNameData(placeName: String) {
        let newPlaceName = PlaceEntity(context: manager.container.viewContext)
        newPlaceName.placeName = placeName
        
        saveChanges()
    }
    
    func addNoteData(note: String) {
        let newNote = PlaceEntity(context: manager.container.viewContext)
        newNote.placeNote = note
        
        saveChanges()
    }
    
    func addPlaceCoordinateData(longitude: Double, latitude: Double) {
        let newPlaceCoordinate = PlaceEntity(context: manager.container.viewContext)
        newPlaceCoordinate.longitude = longitude
        newPlaceCoordinate.latitude = latitude
        
        saveChanges()
    }
    
    func saveNote(longitude: Double, latitude: Double, placeName: String, placeNote: String) {
        if !placeNote.isEmpty {
            let newNote = PlaceEntity(context: manager.container.viewContext)
            newNote.latitude = latitude
            newNote.longitude = longitude
            newNote.placeName = placeName
            newNote.placeNote = placeNote
            
            saveChanges()
            
            // add annotation
            let mapViewModel = MapViewModel()
            mapViewModel.addAnnotationMarker(latitude: latitude, longitude: longitude, title: placeName)
            
            // for debugging purposes
            print("data saved successfully")
            print(placeName)
            print(placeNote)
            print(latitude)
            print(longitude)
            fetchPlaces()
        }
    }

    
    private func saveChanges() {
        do {
            try manager.container.viewContext.save()
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
