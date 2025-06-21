//
//  WeatherTabWrapper.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/19.
//

import SwiftUI

public struct WeatherTabWrapper: View {
    let closetItems: [ClosetItemModel]

    @StateObject private var weatherViewModel = WeatherViewModel(
        useCase: FetchCurrentWeatherUseCase(repository: WeatherRepository())
    )
    @State private var isWeatherVisible = false

    public var body: some View {
        VStack(spacing: 0) { // スペーシングを0に設定
            WeatherView(viewModel: weatherViewModel, isVisible: $isWeatherVisible)
                .frame(height: 100) // 高さを少し減らして上部余白を削減
                .padding(.top, 0) // 上部パディングを削除
                .padding(.bottom, 100)

            if let weather = weatherViewModel.weatherInfo {
                CoordinateSuggestionView(
                    viewModel: CoordinateSuggestionViewModel(
                        items: closetItems.map { $0.toEntity() },
                        weather: weather
                    )
                )
            }
        }
        .onAppear {
            isWeatherVisible = false
            Task {
                await weatherViewModel.fetch()
                isWeatherVisible = true
            }
        }
    }
}
