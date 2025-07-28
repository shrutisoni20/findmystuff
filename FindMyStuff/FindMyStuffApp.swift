//
//  FindMyStuffApp.swift
//  FindMyStuff
//
//  Created by Shruti Soni on 28/07/25.
//

import SwiftUI

@main
struct FindMyStuffApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
