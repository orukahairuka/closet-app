//
//  CustomButton.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/21.
//

import SwiftUI

struct CustomButton: View {
    var action: () -> Void
    var isSelected: Bool
    var animation: Namespace.ID

    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                action()
            }
        }) {
            ZStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: 190, height: 190)

                Image(systemName: Tab.weather.icon)
                    .font(.system(size: 50, weight: .bold))                // ⬅ 少し小さく
                    .foregroundColor(isSelected ? .white : .white.opacity(0.7))
                    .alignmentGuide(.top) { _ in 0 }                       // ← （あってもOK）
                    .offset(x: 30, y: -30)                                 // ⬅ 右上へ移動
                      // ⬅ 右上にずらす
            }
        }
    }
}
