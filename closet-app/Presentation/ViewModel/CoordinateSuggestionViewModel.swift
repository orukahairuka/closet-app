//
//  CoordinateSuggestionViewModel.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/14.
//

import Foundation

final class CoordinateSuggestionViewModel: ObservableObject {
    @Published var suggestedCoordinates: [SuggestedCoordinate] = []
    @Published var clothingLevel: ClothingLevel = .normal

    private let allItems: [ClosetItemEntity]
    private let weather: WeatherEntity

    init(items: [ClosetItemEntity], weather: WeatherEntity) {
        self.allItems = items
        self.weather = weather
        suggest()
    }

    func suggest() {
        clothingLevel = ClothingLevelUseCase().execute(temperature: weather.temperature)
        suggestedCoordinates = SuggestCoordinateUseCase().execute(
            items: allItems,
            weather: weather,
            maxCount: 10
        )
        print("提案されたコーデ数: \(suggestedCoordinates.count)")  // ← ここ
    }

}
