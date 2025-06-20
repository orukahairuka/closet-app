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

struct PurpleTabBarBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 120/255, green: 80/255, blue: 200/255),   // 濃い紫
                        Color(red: 180/255, green: 100/255, blue: 220/255),  // 中間紫ピンク
                        Color(red: 230/255, green: 150/255, blue: 230/255)   // ピンク寄りラベンダー
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
    }
}


struct SunsetPurpleTabBarBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        let cuteRightColor = Color(red: 215/255, green: 150/255, blue: 235/255) // 少し濃いめラベンダーピンク
        let middleMutedColor = Color(red: 170/255, green: 120/255, blue: 210/255) // 濃いめくすみ紫

        content
            .background(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: cuteRightColor, location: 0.0),         // 左
                        .init(color: middleMutedColor, location: 0.5),       // 中央
                        .init(color: cuteRightColor, location: 1.0)          // 右
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
    }
}

