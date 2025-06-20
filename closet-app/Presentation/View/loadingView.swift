//
//  loadingView.swift
//  closet-app
//
//  Created by 前田 梨緒 on 2025/06/15.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let animationName: String
    let loopMode: LottieLoopMode
    let subdirectory: String?

    init(animationName: String, loopMode: LottieLoopMode = .playOnce, subdirectory: String? = nil) {
        self.animationName = animationName
        self.loopMode = loopMode
        self.subdirectory = subdirectory
    }

    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)

        let animationView = Lottie.LottieAnimationView()
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.translatesAutoresizingMaskIntoConstraints = false

        // アニメーションの読み込み
        let animation: Lottie.LottieAnimation?
        if let subdirectory = subdirectory {
            animation = Lottie.LottieAnimation.named(animationName, subdirectory: subdirectory)
        } else {
            animation = Lottie.LottieAnimation.named(animationName)
        }

        animationView.animation = animation
        animationView.play()

        view.addSubview(animationView)

        // AutoLayoutでビューにフィットさせる
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // 状態の変化に応じて処理を加えたいときに使う
    }
}


/*
import SwiftUI
import Lottie


struct LottieView: UIViewRepresentable {
    var name: String

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let animationView = LottieAnimationView(name: name)
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
        return view
    }
    

    func updateUIView(_ uiView: UIView, context: Context) {}
}
struct ContentView: View {
    var body: some View {
        LottieView(name: "loading")
            .frame(width: 600, height: 600)
    }
}
*/

struct loadingView: View {
    @State private var isActive = false
    var body: some View {
        if isActive {
//            HomeView()
        } else {
            LottieView(animationName: "loading", loopMode: .loop)
                .frame(width: 200, height: 200)
            Text("loading...")
                .fontWeight(.light)
                .font(.system(size: 40))
                .foregroundColor(Color.gray)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }

        }
    }
}
#Preview {
    loadingView()
}
