//
//  SaveButtonView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/19.
//

import SwiftUI

struct SaveButtonView: View {
    let animationDuration: TimeInterval = 0.3

    @State private var isAnimating = false
    @State private var taskDone = false
    @State private var submitScale: CGFloat = 1

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ZStack {
                RoundedRectangle(cornerRadius: isAnimating ? 46 : 20)
                    .fill(Color.green)
                    .frame(width: isAnimating ? 92 : 300, height: 92)
                    .scaleEffect(submitScale)
                    .onTapGesture {
                        if !isAnimating {
                            startSavingAnimation()
                        }
                    }

                // ✅ ✔マークだけ
                Tick(scaleFactor: 0.7)
                    .trim(from: 0, to: taskDone ? 1 : 0)
                    .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .animation(.easeOut(duration: 0.3), value: taskDone)

                Text("保存する")
                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .opacity(isAnimating ? 0 : 1)
                    .scaleEffect(isAnimating ? 0.7 : 1)
                    .animation(.easeOut(duration: animationDuration), value: isAnimating)
            }
        }
    }

    private func startSavingAnimation() {
        toggleIsAnimating()

        // ✔を出すタイミング（すぐ）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.taskDone = true
        }

        // ✔を戻すタイミング
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.taskDone = false
            toggleIsAnimating()
        }

        animateButton()
    }

    private func animateButton() {
        withAnimation(.easeInOut(duration: 0.3)) {
            self.submitScale = 1.2
        }
        withAnimation(.easeInOut(duration: 0.3).delay(0.3)) {
            self.submitScale = 1.0
        }
    }

    private func toggleIsAnimating() {
        withAnimation(.spring(response: animationDuration * 1.25, dampingFraction: 0.9)) {
            self.isAnimating.toggle()
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
