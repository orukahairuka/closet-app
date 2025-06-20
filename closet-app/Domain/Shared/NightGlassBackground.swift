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
            // 💜 明るめ紫をベースに、白に近づけたグラデーション
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 230/255, green: 220/255, blue: 255/255), // 白に近いラベンダー
                    Color(red: 240/255, green: 230/255, blue: 255/255), // ほぼ白
                    Color.white
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // ✨ ラベンダーがかった白い光のぼかし（自然な拡がり）
            RadialGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.05), Color.clear]),
                center: .topLeading,
                startRadius: 100,
                endRadius: 400
            )

            // 🌫 少し紫が入ったぼかし光
            Circle()
                .fill(Color.purple.opacity(0.04))
                .frame(width: 240, height: 240)
                .blur(radius: 60)
                .offset(x: -80, y: -220)

            Circle()
                .fill(Color.purple.opacity(0.03))
                .frame(width: 200, height: 200)
                .blur(radius: 50)
                .offset(x: 100, y: 250)
        }
    }
}
