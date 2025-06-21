//
//  CustomTabBarView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/21.
//

import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedTab: Tab
    var animation: Namespace.ID

    var body: some View {
        ZStack {
            // 🟥 タブバー（前面）
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    CustomTabBar(
                        selectedTab: $selectedTab,
                        animation: animation
                    )
                    .frame(width: 280)         // ⬅ 少しだけ広げて中央寄りに
                    .offset(x: -20)             // ⬅ 少し右寄せを緩める
                }
                .padding(.bottom, 0)         // ⬇ 全体を下に
            }

            // 🟦 天気ボタン（背面）
            VStack {
                Spacer()
                HStack {
                    CustomButton(
                        action: { selectedTab = .weather },
                        isSelected: selectedTab == .weather,
                        animation: animation
                    )
                    .offset(x: -80, y: 50)     // ⬅ 左へ -40, ⬇ さらに下へ +10
                    Spacer()
                }
                .padding(.bottom, -8)         // ⬇ 全体をさらに下に
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
