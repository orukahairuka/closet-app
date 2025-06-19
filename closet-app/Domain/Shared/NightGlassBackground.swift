//
//  NightGlassBackground.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/19.
//

import SwiftUI

struct NightGlassBackground: View {
    var body: some View {
        ZStack {
            // 💜 グラデーション：紫中心＋青〜ピンクを広く分布
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 50/255, green: 30/255, blue: 100/255),   // 深めの紫（夜）
                    Color(red: 90/255, green: 60/255, blue: 160/255),   // 中間の明るい紫
                    Color(red: 140/255, green: 80/255, blue: 170/255),  // 紫よりの赤紫
                    Color(red: 200/255, green: 140/255, blue: 200/255), // ピンク控えめ
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // ✨ ふんわり白光
            RadialGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.06), Color.clear]),
                center: .topLeading,
                startRadius: 120,
                endRadius: 500
            )

            // 🌫 グラスっぽい光のぼかし
            Circle()
                .fill(Color.white.opacity(0.04))
                .frame(width: 280, height: 280)
                .blur(radius: 80)
                .offset(x: -100, y: -250)

            Circle()
                .fill(Color.white.opacity(0.03))
                .frame(width: 220, height: 220)
                .blur(radius: 60)
                .offset(x: 140, y: 280)
        }
    }
}
