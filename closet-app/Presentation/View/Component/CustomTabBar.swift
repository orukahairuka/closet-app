//
//  CustomTabBar.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/19.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    var animation: Namespace.ID

    var body: some View {
        HStack {
            Spacer() // ← 左端に余白

            HStack(spacing: 32) { // ← 少し広めに
                ForEach(Tab.allCases.filter { $0 != .weather }, id: \.self) { tab in
                    Button(action: {
                        withAnimation(.spring()) {
                            selectedTab = tab
                        }
                    }) {
                        VStack(spacing: 4) {
                            ZStack {
                                Circle()
                                    .fill(selectedTab == tab ? Color.white.opacity(0.15) : Color.clear)
                                    .frame(width: 44, height: 44)
                                    .shadow(color: selectedTab == tab ? Color.white.opacity(0.4) : .clear, radius: 4)


                                Image(systemName: tab.icon)
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(selectedTab == tab ? .white : .white.opacity(0.7))
                            }


                            Text(tab.title)
                                .font(.caption2)
                                .foregroundColor(selectedTab == tab ? .white : .white.opacity(0.7))
                        }
                    }
                }
            }

            Spacer() // ← 右端にも余白
        }
        .frame(width: 370)
        .padding(.vertical, 12)
        .background(
            Color.clear
                .modifier(PurpleTabBarBackgroundModifier()) // ← こっちに変更
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 2)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }
}

