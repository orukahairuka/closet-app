//
//  ClothingLevelUseCase.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/14.
//

import Foundation

final class ClothingLevelUseCase {
    func execute(temperature: Double) -> ClothingLevel {
        switch temperature {
        case ..<6:
            return .veryCold
        case 6..<11:
            return .cold
        case 11..<21:
            return .normal
        case 21..<27:
            return .warm
        default:
            return .hot
        }
    }
}
