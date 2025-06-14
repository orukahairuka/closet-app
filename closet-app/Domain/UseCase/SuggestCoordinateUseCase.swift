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

struct SuggestedCoordinate: Identifiable {
    let id = UUID()
    let items: [ClosetItemEntity]
    let pattern: CoordinatePattern
}

final class SuggestCoordinateUseCase {
    func execute(
        items: [ClosetItemEntity],
        weather: WeatherEntity,
        maxCount: Int = 10
    ) -> [SuggestedCoordinate] {
        let temperature = weather.temperature

        // 季節スコアをベースにフィルタ（ゆるめ）
        let filtered = items.filter { item in
            let score = seasonMatchScore(season: item.season, temperature: temperature)
            return score >= 0.5  // ← ゆるめ（1.0が完全一致、0.0はミスマッチ）
        }

        let tops = filtered.filter { $0.category == .tops }
        let bottoms = filtered.filter { $0.category == .bottoms }
        let shoes = filtered.filter { $0.category == .shoes }
        let setups = filtered.filter { $0.category == .setup }
        let onePieces = filtered.filter { $0.category == .onePiece }

        var coordinates: [SuggestedCoordinate] = []

        for _ in 0..<maxCount {
            let patterns: [CoordinatePattern] = [
                (!tops.isEmpty && !bottoms.isEmpty && !shoes.isEmpty) ? .topBottomShoes : nil,
                (!setups.isEmpty && !shoes.isEmpty) ? .setupShoes : nil,
                (!onePieces.isEmpty && !shoes.isEmpty) ? .onepieceShoes : nil
            ].compactMap { $0 }

            guard let selectedPattern = patterns.randomElement() else { continue }

            let selectedItems: [ClosetItemEntity] = {
                switch selectedPattern {
                case .topBottomShoes:
                    return [tops.randomElement(), bottoms.randomElement(), shoes.randomElement()].compactMap { $0 }
                case .setupShoes:
                    return [setups.randomElement(), shoes.randomElement()].compactMap { $0 }
                case .onepieceShoes:
                    return [onePieces.randomElement(), shoes.randomElement()].compactMap { $0 }
                }
            }()

            if selectedItems.count >= 2 {
                coordinates.append(SuggestedCoordinate(items: selectedItems, pattern: selectedPattern))
            }
        }

        return coordinates
    }

    /// 季節と気温のマッチ度を [0.0, 1.0] で数値化（高いほどその季節に合っている）
    private func seasonMatchScore(season: Season, temperature: Double) -> Double {
        let centerTemp: Double
        switch season {
        case .winter: centerTemp = 5   // 冬物の中心温度
        case .autumn: centerTemp = 15
        case .spring: centerTemp = 20
        case .summer: centerTemp = 28
        }

        let diff = abs(centerTemp - temperature)
        let score = max(0.0, 1.0 - (diff / 15.0))  // 差が15℃以上ならスコア0
        return score
    }
}
