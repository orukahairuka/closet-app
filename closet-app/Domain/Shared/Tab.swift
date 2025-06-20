//
//  Tab.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/19.
//

import Foundation

enum Tab: Int, CaseIterable {
    case closet, weather, add, set

    var title: String {
        switch self {
        case .closet: return "クローゼット"
        case .weather: return "天気"
        case .add: return "追加"
        case .set: return "服のセット"
        }
    }

    var icon: String {
        switch self {
        case .closet: return "tshirt"
        case .weather: return "cloud.sun"
        case .add: return "plus.circle"
        case .set: return "brain.head.profile"
        }
    }
}
