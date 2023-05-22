//
//  Place.swift
//  MemoSpot
//
//  Created by Rosa Tiara Galuh on 18/05/23.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
    var id = UUID().uuidString
    var place: CLPlacemark // Updated property name
    var address: String? // Add address property
        
        init(place: CLPlacemark) {
            self.place = place
        }
}
