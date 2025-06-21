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
            VStack(spacing: 20) {
                // 天気アイコン
                ZStack {
                    Circle()
                        .fill(Color(.systemBlue).opacity(0.15))
                        .frame(width: 120, height: 120)
                        .scaleEffect(isVisible ? 1.0 : 0.1)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isVisible)

                    Image(systemName: weather.symbolName)
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .scaleEffect(isVisible ? 1.0 : 0.5)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.5), value: isVisible)
                }

                // 気温表示
                Text("\(String(format: "%.1f", weather.temperature))℃")
                    .font(.system(size: 52, weight: .bold))
                    .foregroundColor(.primary)
                    .offset(y: isVisible ? 0 : -20)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: isVisible)
            }
            .padding(32)
            .frame(minWidth: 220)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .fill(.regularMaterial)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeOut(duration: 0.5), value: isVisible)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 32)
                    .strokeBorder(Color(.systemGray4), lineWidth: 1)
                    .opacity(0.5)
            )
            .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 8)
        } else if viewModel.isLoading {
            LoadingView()
        } else if let error = viewModel.errorMessage {
            ErrorView(message: error)
        }
    }
}

// ローディング表示の改善
struct LoadingView: View {
    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(1.5)
                .padding(.bottom, 4)
            Text("天気情報を取得中...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(32)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

// エラー表示の改善
struct ErrorView: View {
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.orange)

            Text("天気情報の取得に失敗しました")
                .font(.headline)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(32)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}
