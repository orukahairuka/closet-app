//
//  Tab.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/19.
//

import Foundation

enum Tab: Int, CaseIterable {
    case closet, weather, add, ml

    var title: String {
        switch self {
        case .closet: return "クローゼット"
        case .weather: return "天気"
        case .add: return "追加"
        case .ml: return "AIコーデ"
        }
    }

    var icon: String {
        switch self {
        case .closet: return "tshirt"
        case .weather: return "cloud.sun"
        case .add: return "plus.circle"
        case .ml: return "brain.head.profile"
        }
    }
}
