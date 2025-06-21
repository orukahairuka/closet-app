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

    private let mockIndoorTemp: Double = 24.5

    var body: some View {
        if let weather = viewModel.weatherInfo {
            HStack(alignment: .top, spacing: 16) {

                // --- 左側: 「外の天気」カード ---
                VStack(alignment: .center, spacing: 8) {
                    // 天気アイコン
                    ZStack {
                        Circle()
                            .fill(Color(.systemBlue).opacity(0.15))
                            .frame(width: 80, height: 80)
                            .scaleEffect(isVisible ? 1.0 : 0.1)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isVisible)

                        Image(systemName: weather.symbolName)
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .scaleEffect(isVisible ? 1.0 : 0.5)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.5), value: isVisible)
                    }

                    // 外の気温
                    Text("\(String(format: "%.1f", weather.temperature))℃")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                        .offset(y: isVisible ? 0 : -20)
                        .opacity(isVisible ? 1 : 0)
                        .animation(.easeOut(duration: 0.8).delay(0.2), value: isVisible)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.regularMaterial)
                        .opacity(isVisible ? 1 : 0)
                        .animation(.easeOut(duration: 0.5), value: isVisible)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(Color(.systemGray4), lineWidth: 1)
                        .opacity(0.5)
                )
                .shadow(color: .black.opacity(0.12), radius: 16, x: 0, y: 6)

                // --- 右側: 「室内の情報」カード ---
                VStack(alignment: .center, spacing: 8) {
                    // 家のアイコン
                    ZStack {
                        Circle()
                            .fill(Color(.systemGray).opacity(0.15))
                            .frame(width: 80, height: 80)
                            .scaleEffect(isVisible ? 1.0 : 0.1)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.1), value: isVisible)

                        Image(systemName: "house.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                            .foregroundStyle(Color.black)
                            .scaleEffect(isVisible ? 1.0 : 0.5)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.5).delay(0.1), value: isVisible)
                    }

                    // 室内の気温
                    Text("\(String(format: "%.1f", mockIndoorTemp))℃")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                        .offset(y: isVisible ? 0 : -20)
                        .opacity(isVisible ? 1 : 0)
                        .animation(.easeOut(duration: 0.8).delay(0.3), value: isVisible)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.regularMaterial)
                        .opacity(isVisible ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(0.05), value: isVisible)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(Color(.systemGray4), lineWidth: 1)
                        .opacity(0.5)
                )
                .shadow(color: .black.opacity(0.12), radius: 16, x: 0, y: 6)
            }
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
