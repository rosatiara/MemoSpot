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
    @StateObject var coreDataViewModel = CoreDataViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(coreDataViewModel) // for CoreData
                .onAppear {
                    coreDataViewModel.fetchPlaces()
                }
        }
    }
}
