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
            ForEach(Tab.allCases, id: \.self) { tab in
                Spacer()

                Button(action: {
                    withAnimation(.spring()) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 4) {
                        ZStack {
                            if selectedTab == tab {
                                Circle()
                                    .fill(Color.white.opacity(0.15))
                                    .frame(width: 44, height: 44)
                                    .shadow(color: .white.opacity(0.4), radius: 4)
                                    .matchedGeometryEffect(id: "circle", in: animation)
                            }

                            Image(systemName: tab.icon)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(selectedTab == tab ? .white : .white.opacity(0.7))
                        }
                        Text(tab.title)
                            .font(.caption2)
                            .foregroundColor(selectedTab == tab ? .white : .white.opacity(0.7))
                    }
                }

                Spacer()
            }
        }
        .padding(.vertical, 12)
        .background(
            Color.clear
                .modifier(SunsetPurpleTabBarBackgroundModifier())
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 2)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }
}
