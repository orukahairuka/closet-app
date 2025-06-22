//
//  SaveButtonView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/19.
//

import SwiftUI

struct SaveButtonView: View {
    let action: () -> Void  // 保存処理を外部から受け取る
    var bodyText: String = "保存する"

    @State private var isAnimating = false
    @State private var taskDone = false
    @State private var submitScale: CGFloat = 1

    var body: some View {
        ZStack {
            // ✅ 背景の丸いボタン
            RoundedRectangle(cornerRadius: isAnimating ? 46 : 20)
                .fill(Color.green)
                .frame(width: isAnimating ? 92 : UIScreen.main.bounds.width - 64, height: 60) // ← 92 or 大きい幅
                .scaleEffect(submitScale)
                .animation(.easeInOut(duration: 0.3), value: isAnimating)
                .onTapGesture {
                    if !isAnimating {
                        startSaving()
                    }
                }

            // ✅ チェックマーク（保存後）
            Tick(scaleFactor: 0.7)
                .trim(from: 0, to: taskDone ? 1 : 0)
                .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .opacity(isAnimating ? 1 : 0)
                .animation(.easeOut(duration: 0.3), value: taskDone)

            // ✅ テキスト（通常表示）
            Text(bodyText)
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .opacity(isAnimating ? 0 : 1)
                .scaleEffect(isAnimating ? 0.7 : 1)
                .animation(.easeOut(duration: 0.3), value: isAnimating)
        }
        .frame(maxWidth: .infinity, alignment: .center) // ✅ 中央寄せを強制
    }


    private func startSaving() {
        toggleIsAnimating()

        // ✔マーク表示
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            taskDone = true
        }

        // 保存実行＆戻る
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            taskDone = false
            toggleIsAnimating()
            action()
        }

        animateButton()
    }

    private func animateButton() {
        withAnimation(.easeInOut(duration: 0.3)) {
            submitScale = 1.2
        }
        withAnimation(.easeInOut(duration: 0.3).delay(0.3)) {
            submitScale = 1.0
        }
    }

    private func toggleIsAnimating() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.9)) {
            isAnimating.toggle()
        }
    }
}

struct Tick: Shape {
    var scaleFactor: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width * scaleFactor
        let height = rect.height * scaleFactor

        path.move(to: CGPoint(x: rect.minX + width * 0.1, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - height * 0.1))
        path.addLine(to: CGPoint(x: rect.maxX - width * 0.1, y: rect.minY + height * 0.1))

        return path
    }
}
