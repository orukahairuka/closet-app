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
            HStack(alignment: .center, spacing: 16) {
                // 左側: 天気アイコン
                ZStack {
                    Circle()
                        .fill(Color(.systemBlue).opacity(0.15))
                        .frame(width: 90, height: 90)
                        .scaleEffect(isVisible ? 1.0 : 0.1)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isVisible)

                    Image(systemName: weather.symbolName)
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55, height: 55)
                        .scaleEffect(isVisible ? 1.0 : 0.5)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.5), value: isVisible)
                }

                // 右側: 気温表示
                Text("\(String(format: "%.1f", weather.temperature))℃")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.primary)
                    .offset(y: isVisible ? 0 : -20)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: isVisible)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 24)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(.regularMaterial)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeOut(duration: 0.5), value: isVisible)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .strokeBorder(Color(.systemGray4), lineWidth: 1)
                    .opacity(0.5)
            )
            .shadow(color: .black.opacity(0.12), radius: 16, x: 0, y: 6)
            .fixedSize(horizontal: true, vertical: true)

        } else if viewModel.isLoading {
            LoadingView()
        } else if let error = viewModel.errorMessage {
            ErrorView(message: error)
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 8) {
            ProgressView()
                .scaleEffect(1.2)
                .padding(.bottom, 2)
            Text("天気情報を取得中...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(24)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct ErrorView: View {
    let message: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle")
                .font(.title2)
                .foregroundColor(.orange)

            Text("天気情報の取得に失敗")
                .font(.headline)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(24)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .frame(maxWidth: 280)
    }
}
