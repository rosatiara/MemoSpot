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
    var place: CLPlacemark
    var address: String?
    
    init(place: CLPlacemark) {
        self.place = place
    }
}
