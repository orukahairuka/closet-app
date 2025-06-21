//
//  StartupInitializerView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/22.
//

import SwiftUI
import SwiftData

struct StartupInitializerView: View {
    @Environment(\.modelContext) private var context
    @State private var isReady = false

    var body: some View {
        Group {
            if isReady {
                MainTabView()
            } else {
                loadingView()
                    .task {
                        ClosetItemPresetLoader.insertPresetItemsIfNeeded(context: context)
                        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1秒待機
                        withAnimation {
                            isReady = true
                        }
                    }
            }
        }
    }
}
