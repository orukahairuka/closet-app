//
//  CoordinateSuggestionView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/14.
//

import SwiftUI

struct CoordinateSuggestionView: View {
    @ObservedObject var viewModel: CoordinateSuggestionViewModel

    @State private var currentAdvice: String = ""

    var body: some View {
        ZStack(alignment: .top) {
            // キャラクターアニメーション部分（下に配置）
            LottieView(animationName: "navigator", loopMode: .loop)
                .frame(height: 270)
                .padding(.horizontal, 24)
                .padding(.top, 140) // キャラクターの表示位置を下げる

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
                    SpeechBubble(text: viewModel.aiAdvice)
                        .padding(.horizontal, 12)
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 12)
        }
        .frame(maxHeight: 350) // 全体の高さを制限
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
