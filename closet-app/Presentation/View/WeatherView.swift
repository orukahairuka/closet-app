//
//  WeatherView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/12.
//
import SwiftUI
import SwiftData

struct WeatherView: View {
    @Query private var closetItems: [ClosetItemModel] // 追加
    @StateObject private var viewModel = WeatherViewModel(
        useCase: FetchCurrentWeatherUseCase(repository: WeatherRepository())
    )
    @State private var isVisible = false

    var body: some View {
        ScrollView {
            if let weather = viewModel.weatherInfo {
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
                        .foregroundColor(.secondary)
                }
                .padding(32)
                .background(.regularMaterial.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 32))
                .shadow(color: .black.opacity(0.2), radius: 24, x: 0, y: 10)

                if let weather = viewModel.weatherInfo {
                    CoordinateSuggestionView(
                        viewModel: CoordinateSuggestionViewModel(
                            items: closetItems.map { $0.toEntity() },
                            weather: weather
                        )
                    )
                }
            } else if viewModel.isLoading {
                ProgressView("読み込み中...")
            } else if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red)
            }
        }
        .padding()
        .onAppear {
            isVisible = false
            Task {
                await viewModel.fetch()
                isVisible = true
            }
        }
    }
}
