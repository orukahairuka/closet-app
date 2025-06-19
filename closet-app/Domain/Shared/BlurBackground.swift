//
//  BlurBackground.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/19.
//

import SwiftUI

struct BlurBackground: View {
    var cornerRadius: CGFloat = 0

    var body: some View {
        ZStack {
            // 🌟 白ベースで透明感を出す
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(Color.white.opacity(0.3))  // ← 白ベースへ変更

            // グラスモーフィズムのぼかし（ライトスタイル）
            VisualEffectBlur(blurStyle: .systemUltraThinMaterialLight)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))

            // 白いアウトライン（うっすら）
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(Color.white.opacity(0.2), lineWidth: 0.6)
        }
    }
}

struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}



