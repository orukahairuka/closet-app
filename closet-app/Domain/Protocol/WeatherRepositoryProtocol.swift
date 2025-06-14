//
//  WeatherRepositoryProtocol.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/12.
//

import Foundation

protocol WeatherRepositoryProtocol {
    func fetchCurrentWeather() async throws -> WeatherEntity
}
