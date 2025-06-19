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
                                    .fill(Color.blue.opacity(0.2))
                                    .frame(width: 44, height: 44)
                                    .matchedGeometryEffect(id: "circle", in: animation)
                            }

                            Image(systemName: tab.icon)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(selectedTab == tab ? .blue : .gray)
                        }
                        Text(tab.title)
                            .font(.caption2)
                            .foregroundColor(selectedTab == tab ? .blue : .gray)
                    }
                }

                Spacer()
            }
        }
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(radius: 5)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 10)
    }
}
