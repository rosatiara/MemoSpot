//
//  MemoSpotApp.swift
//  MemoSpot
//
//  Created by Rosa Tiara Galuh on 18/05/23.
//

import SwiftUI

@main
struct MemoSpotApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
