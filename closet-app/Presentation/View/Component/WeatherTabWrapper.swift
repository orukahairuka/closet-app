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
        ScrollView {
            VStack(spacing: 24) {
                WeatherView(viewModel: weatherViewModel, isVisible: $isWeatherVisible)
                    .frame(height: 300)
                    .padding(.top, 50)

                if let weather = weatherViewModel.weatherInfo {
                    CoordinateSuggestionView(
                        viewModel: CoordinateSuggestionViewModel(
                            items: closetItems.map { $0.toEntity() },
                            weather: weather
                        )
                    )
                }
            }
            .padding(.bottom, 80)
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

