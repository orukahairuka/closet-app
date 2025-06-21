//
//  WeatherView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/12.
//

import SwiftUI
import SwiftData

struct WeatherView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @Binding var isVisible: Bool

    var body: some View {
        if let weather = viewModel.weatherInfo {
            VStack(spacing: 12) { // スペーシングを減らす（20→12）
                // 天気アイコン
                ZStack {
                    Circle()
                        .fill(Color(.systemBlue).opacity(0.15))
                        .frame(width: 90, height: 90) // サイズを小さく（120→90）
                        .scaleEffect(isVisible ? 1.0 : 0.1)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isVisible)

                    Image(systemName: weather.symbolName)
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55, height: 55) // サイズを小さく（70→55）
                        .scaleEffect(isVisible ? 1.0 : 0.5)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.5), value: isVisible)
                }

                // 気温表示
                Text("\(String(format: "%.1f", weather.temperature))℃")
                    .font(.system(size: 42, weight: .bold)) // フォントサイズを小さく（52→42）
                    .foregroundColor(.primary)
                    .offset(y: isVisible ? 0 : -20)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: isVisible)
            }
            .padding(.vertical, 20) // 上下のパディングを削減（32→20）
            .padding(.horizontal, 24) // 左右のパディングも調整（32→24）
            .frame(minWidth: 180) // 最小幅を調整（220→180）
            .background(
                RoundedRectangle(cornerRadius: 28) // 角丸も少し小さく
                    .fill(.regularMaterial)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeOut(duration: 0.5), value: isVisible)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .strokeBorder(Color(.systemGray4), lineWidth: 1)
                    .opacity(0.5)
            )
            .shadow(color: .black.opacity(0.12), radius: 16, x: 0, y: 6) // 影も調整
            .fixedSize(horizontal: false, vertical: true) // 必要な高さだけ確保
        } else if viewModel.isLoading {
            LoadingView()
        } else if let error = viewModel.errorMessage {
            ErrorView(message: error)
        }
    }
}

// ローディング表示もコンパクトに
struct LoadingView: View {
    var body: some View {
        VStack(spacing: 8) { // スペーシング調整
            ProgressView()
                .scaleEffect(1.2) // サイズ調整
                .padding(.bottom, 2)
            Text("天気情報を取得中...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(24) // パディング調整
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

// エラー表示もコンパクトに
struct ErrorView: View {
    let message: String

    var body: some View {
        VStack(spacing: 8) { // スペーシング調整
            Image(systemName: "exclamationmark.triangle")
                .font(.title2) // サイズ小さく
                .foregroundColor(.orange)

            Text("天気情報の取得に失敗")
                .font(.headline)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.footnote) // サイズ調整
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(24) // パディング調整
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .frame(maxWidth: 280) // 幅を制限
    }
}
