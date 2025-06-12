//
//  WeatherRepository.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/12.
//

import Foundation
import WeatherKit
import CoreLocation

final class WeatherRepository: WeatherRepositoryProtocol {
    private let service = WeatherService()
    private let location = CLLocation(latitude: 35.663613, longitude: 139.732293) // 六本木

    func fetchCurrentWeather() async throws -> WeatherInfo {
        let weather = try await service.weather(for: location)

        return WeatherInfo(
            temperature: weather.currentWeather.temperature.value,
            condition: weather.currentWeather.condition.description,
            symbolName: weather.currentWeather.symbolName
        )
    }
}
