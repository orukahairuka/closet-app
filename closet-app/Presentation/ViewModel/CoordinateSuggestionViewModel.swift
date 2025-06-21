//
//  CoordinateSuggestionViewModel.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/14.
//

import Foundation
import Combine

class CoordinateSuggestionViewModel: ObservableObject {
    private let useCase = SuggestCoordinateUseCase()
    private let items: [ClosetItemEntity]
    private let weather: WeatherEntity

    @Published var suggestedCoordinates: [SuggestedCoordinate] = []
    @Published var aiAdvice: String = "読み込み中..."
    @Published var isLoading: Bool = false

    init(items: [ClosetItemEntity], weather: WeatherEntity) {
        self.items = items
        self.weather = weather

        loadSuggestions()
        loadAIAdvice()
    }

    private func loadSuggestions() {
        suggestedCoordinates = useCase.execute(items: items, weather: weather)
    }

    private func loadAIAdvice() {
        isLoading = true

        Task { @MainActor in
            let advice = await useCase.getWeatherAdvice(weather: weather)
            self.aiAdvice = advice
            self.isLoading = false
        }
    }
}
