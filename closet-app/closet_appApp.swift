

import SwiftUI

@main
struct closet_appApp: App {
    var body: some Scene {
        WindowGroup {
            StartupInitializerView()
        }
        .modelContainer(for: [ClosetItemModel.self, CoordinateSetModel.self])
    }
}
