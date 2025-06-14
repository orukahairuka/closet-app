//
//  SuggestCoordinateUseCase.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/14.
//

import Foundation

enum CoordinatePattern {
    case topBottomShoes
    case onepieceShoes
    case setupShoes
}

struct SuggestedCoordinate {
    let items: [ClosetItemEntity]
    let pattern: CoordinatePattern
}

final class SuggestCoordinateUseCase {
    func execute(
      items: [ClosetItemEntity],
      weather: WeatherEntity,
      isLoose: Bool,
      maxCount: Int = 10
    ) -> [SuggestedCoordinate] {
        let temperature = weather.temperature
        let condition = weather.condition

        let filtered = items.filter { item in
            let seasonMatch = matchSeason(item.season, temperature: temperature, isLoose: isLoose)
            let rainMatch = condition.contains("雨") ? (item.memo?.contains("防水") ?? false || isLoose) : true
            return seasonMatch && rainMatch
        }

        let tops = filtered.filter { $0.category == .tops }
        let bottoms = filtered.filter { $0.category == .bottoms }
        let shoes = filtered.filter { $0.category == .shoes }
        let setups = filtered.filter { $0.category == .setup }
        let onePieces = filtered.filter { $0.category == .onePiece }


        var coordinates: [SuggestedCoordinate] = []

        for _ in 0..<maxCount {
            let options: [CoordinatePattern] = [
                (!tops.isEmpty && !bottoms.isEmpty && !shoes.isEmpty) ? .topBottomShoes : nil,
                (!setups.isEmpty && !shoes.isEmpty) ? .setupShoes : nil,
                (!onePieces.isEmpty && !shoes.isEmpty) ? .onepieceShoes : nil
            ].compactMap { $0 }

            guard let pattern = options.randomElement() else { continue }

            let selectedItems: [ClosetItemEntity] = {
                switch pattern {
                case .topBottomShoes:
                    return [tops.randomElement(), bottoms.randomElement(), shoes.randomElement()].compactMap { $0 }
                case .setupShoes:
                    return [setups.randomElement(), shoes.randomElement()].compactMap { $0 }
                case .onepieceShoes:
                    return [onePieces.randomElement(), shoes.randomElement()].compactMap { $0 }
                }
            }()

            if selectedItems.count >= 2 {
                coordinates.append(SuggestedCoordinate(items: selectedItems, pattern: pattern))
            }
        }

        return coordinates
    }


    private func matchSeason(_ season: Season, temperature: Double, isLoose: Bool) -> Bool {
        if isLoose {
            // 緩めの判定
            switch season {
            case .winter: return temperature < 12
            case .autumn: return 8..<20 ~= temperature
            case .spring: return 12..<28 ~= temperature
            case .summer: return temperature >= 22
            }
        } else {
            // 厳しめの判定
            switch season {
            case .winter: return temperature < 10
            case .autumn: return 10..<18 ~= temperature
            case .spring: return 15..<25 ~= temperature
            case .summer: return temperature >= 25
            }
        }
    }

}
