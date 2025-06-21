//
//  CoordinateSuggestionView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/14.
//

import SwiftUI

struct CoordinateSuggestionView: View {
    @ObservedObject var viewModel: CoordinateSuggestionViewModel
    // モックデータを格納する配列
    private let mockAdvices = [
        "今日は気温が上がりそうです。薄手の上着を持っていくと良いでしょう。明るい色のトップスと合わせるとさわやかな印象になります。",
        "今日は少し肌寒いかもしれません。長袖のシャツやセーターがおすすめです。重ね着すると、寒暖差に対応できますよ。",
        "雨の予報があります。撥水性のあるジャケットや、汚れにくい素材の靴を選ぶと安心です。折りたたみ傘も忘れずに。",
        "暑くなりそうな一日です。通気性の良い素材を選び、日差しが強いので帽子やサングラスがあると便利でしょう。",
        "季節の変わり目で寒暖差が大きいです。レイヤードスタイルで調整できるようにすると良いでしょう。明るい色のアイテムを取り入れるとこの季節にぴったりです。"
    ]

    @State private var currentAdvice: String = ""

    var body: some View {
        ZStack(alignment: .top) {
            // キャラクターアニメーション部分（下に配置）
            LottieView(animationName: "navigator", loopMode: .loop)
                .frame(height: 180)
                .padding(.horizontal, 24)
                .padding(.top, 160) // キャラクターの表示位置を下げる

            // アドバイスの吹き出し部分（上に配置）
            VStack(alignment: .leading, spacing: 15) {
                HStack(spacing: 10) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.purple)
                        .font(.system(size: 18))
                    Text("今日の服装アドバイス")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 16)

                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 20)
                } else {
                    SpeechBubble(text: currentAdvice)
                        .padding(.horizontal, 12)
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 12)
        }
        .frame(maxHeight: 260) // 全体の高さを制限
        .onAppear {
            // 表示時にモックデータからランダムにアドバイスを選択
            currentAdvice = mockAdvices.randomElement() ?? "今日も素敵な一日をお過ごしください。"
        }
    }
}

struct SpeechBubble: View {
    var text: String

    var body: some View {
        VStack(spacing: 0) {
            // 吹き出し本体
            Text(text)
                .foregroundColor(.black)
                .font(.body)
                .lineSpacing(4)
                .padding(18)
                .background(Color(.systemGray6))
                .cornerRadius(18)
                .shadow(color: .gray.opacity(0.25), radius: 5, x: 0, y: 3)

            // 三角形
            Rectangle()
                .fill(Color(.systemGray6))
                .frame(width: 16, height: 16)
                .rotationEffect(.degrees(45))
                .offset(y: -8)
                .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 2)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.bottom, 8)
    }
}
