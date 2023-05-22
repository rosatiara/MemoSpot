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
    
    func saveNote() {
        let newNote = PlaceEntity(context: manager.container.viewContext)
        newNote.latitude = latitude
        newNote.longitude = longitude
        newNote.placeName = placeName
        newNote.placeNote = placeNote
        
        save()
        fetchPlaces()
        
        // Reset the input fields after saving
        latitude = 0.0
        longitude = 0.0
        placeName = ""
        placeNote = ""
    }
    
    func isDataEmpty() -> Bool {
        return placeList.isEmpty
    }
    
    func getName() -> String {
        guard(!placeList.isEmpty) else { return " " }
        
        return placeList.first!.placeName ?? "No review"
    }
    
    func getCoordinate(longitude: Double, latitude: Double) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func addNote(note: String) {
        let newNote = PlaceEntity(context: manager.container.viewContext)
        newNote.placeNote = note
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
