//
//  WeatherView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/12.
//
import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel(
        useCase: FetchCurrentWeatherUseCase(repository: WeatherRepository())
    )
    @State private var isVisible = false

    var body: some View {
        ZStack {
            if let weather = viewModel.weatherInfo {
                // 天気に応じた背景
                LinearGradient(
                    gradient: Gradient(colors: backgroundColors(for: weather.symbolName)),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                .animation(.easeInOut, value: weather.symbolName)

                VStack(spacing: 16) {
                    Image(systemName: weather.symbolName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .scaleEffect(isVisible ? 1.0 : 0.5)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isVisible)

                    Text("\(String(format: "%.1f", weather.temperature))℃")
                        .font(.system(size: 48, weight: .bold))
                        .offset(y: isVisible ? 0 : -20)
                        .opacity(isVisible ? 1 : 0)
                        .animation(.easeOut(duration: 1), value: isVisible)

                    Text(weather.condition)
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 32))
                .shadow(radius: 20)
                .padding()
            } else if viewModel.isLoading {
                ProgressView("読み込み中...")
            } else if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red)
            }
        }
        .onAppear {
            isVisible = false
            Task {
                await viewModel.fetch()
                isVisible = true
            }
        }
    }

    private func backgroundColors(for symbol: String) -> [Color] {
        switch symbol {
        case "cloud.rain.fill": return [Color.blue.opacity(0.7), Color.gray.opacity(0.5)]
        case "sun.max.fill": return [Color.orange, Color.yellow]
        case "cloud.snow.fill": return [Color.white.opacity(0.8), Color.gray.opacity(0.4)]
        default: return [Color.green.opacity(0.4), Color.blue.opacity(0.3)]
        }
    }
}
