//
//  FetchCurrentWeatherUseCase.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/12.
//

import Foundation

final class FetchCurrentWeatherUseCase {
    private let repository: WeatherRepositoryProtocol

    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> WeatherEntity {
        try await repository.fetchCurrentWeather()
    }
}
