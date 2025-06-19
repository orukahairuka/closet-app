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

    var body: some View {
        ZStack(alignment: .bottom) {
            currentView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .animation(.easeInOut, value: selectedTab)

            CustomTabBar(selectedTab: $selectedTab, animation: animation)
        }
        .ignoresSafeArea(.keyboard)
    }

    // View切り替え用の関数
    @ViewBuilder
    private func currentView() -> some View {
        switch selectedTab {
        case .closet:
            CloseSelectView()
        case .weather:
            WeatherTabWrapper(closetItems: closetItems)
        case .add:
            AddClosetItemView()
        case .ml:
            CoreMLView()
        }
    }

}
