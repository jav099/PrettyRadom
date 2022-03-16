//
//  RadomApp.swift
//  Radom
//
//  Created by Javier Contreras on 3/12/22.
//

import SwiftUI

@main
struct RadomApp: App {
    // FIXME
    @StateObject var placementSettings = PlacementSettings()
    var body: some Scene {
        WindowGroup {
            TabMenuView()
                .environmentObject(placementSettings)
        }
    }
}
