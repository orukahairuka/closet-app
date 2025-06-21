//
//  closet_appApp.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/11.
//

import SwiftUI

@main
struct closet_appApp: App {
    @State private var showLoading = true

    var body: some Scene {
        WindowGroup {
            Group {
                if showLoading {
                    loadingView()
                        .task {
                            try? await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 2秒待つ
                            withAnimation {
                                showLoading = false
                            }
                        }
                } else {
                    MainTabView()
                }
            }
        }
        .modelContainer(for: [ClosetItemModel.self, CoordinateSetModel.self])
    }
}
