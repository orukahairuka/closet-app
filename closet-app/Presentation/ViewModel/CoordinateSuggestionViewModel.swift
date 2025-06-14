//
//  CoordinateSuggestionViewModel.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/14.
//

import Foundation
import SwiftUI

final class CoordinateSuggestionViewModel: ObservableObject {
    @Published var suggestedCoordinate: SuggestedCoordinate?
    @Published var clothingLevel: ClothingLevel = .normal

    private let allItems: [ClosetItemEntity]
    private let weather: WeatherEntity

    init(items: [ClosetItemEntity], weather: WeatherEntity) {
        self.allItems = items
        self.weather = weather
        suggest()
    }

    func suggest() {
        // 服装レベル算出
        clothingLevel = ClothingLevelUseCase().execute(temperature: weather.temperature)

        // コーデ提案
        suggestedCoordinate = SuggestCoordinateUseCase().execute(items: allItems, weather: weather)
    }
}
