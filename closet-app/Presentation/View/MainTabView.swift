//
//  MainTabView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/19.
//

import SwiftUI
import _SwiftData_SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .closet
    @Namespace private var animation
    @Query private var closetItems: [ClosetItemModel]
    @State private var allSets: [CoordinateSetModel] = []  // ✅ 状態はここで持つ


    var body: some View {
        NavigationStack {  // ← 🔧 追加！
            ZStack(alignment: .bottom) {
                NightGlassBackground()
                currentView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .animation(.easeInOut, value: selectedTab)

                CustomTabBar(selectedTab: $selectedTab, animation: animation)
            }
            .ignoresSafeArea(.keyboard)
        }
    }

    @ViewBuilder
    private func currentView() -> some View {
        switch selectedTab {
        case .closet:
            CloseSelectView()
        case .weather:
            WeatherTabWrapper(closetItems: closetItems)
        case .add:
            AddClosetItemView(allSets: $allSets)
        case .ml:
            CoreMLView()
        }
    }
}
