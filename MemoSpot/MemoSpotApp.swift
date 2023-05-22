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
    @StateObject var viewModel = CoreDataViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(viewModel) // for CoreData
        }
    }
}
