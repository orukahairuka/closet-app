//
//  closet_appApp.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/11.
//

import SwiftUI

@main
struct closet_appApp: App {
    var body: some Scene {
        WindowGroup {
            LoadingLaunchView()
                .environmentObject(RecommendationState())
        }
        .modelContainer(for: [ClosetItemModel.self, CoordinateSetModel.self]) // ✅ ここ大事
    }
}
