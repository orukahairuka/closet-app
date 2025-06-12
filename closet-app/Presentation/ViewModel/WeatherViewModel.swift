//
//  WeatherViewModel.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/12.
//

import SwiftUI
import WeatherKit

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var weatherInfo: WeatherInfo?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let useCase: FetchCurrentWeatherUseCase

    init(useCase: FetchCurrentWeatherUseCase) {
        self.useCase = useCase
    }

    func fetch() async {
        isLoading = true
        do {
            self.weatherInfo = try await useCase.execute()
        } catch {
            self.errorMessage = "取得失敗: \(error.localizedDescription)"
        }
        isLoading = false
    }
}

