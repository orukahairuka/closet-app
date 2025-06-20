//
//  Tab.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/19.
//

enum Tab: CaseIterable {
    case closet
    case weather
    case add

    var icon: String {
        switch self {
        case .closet: return "tshirt.fill"
        case .weather: return "cloud.sun.fill"
        case .add: return "square.grid.2x2.fill"
        }
    }

    var title: String {
        switch self {
        case .closet: return "クローゼット"
        case .weather: return "天気"
        case .add: return "セット"
        }
    }
}
