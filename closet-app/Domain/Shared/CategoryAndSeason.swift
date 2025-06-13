//
//  CategoryAndSeason.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/14.
//
import Foundation

enum Category: String, Codable, CaseIterable, Identifiable {
    case bag, shoes, tops, accessory, outer, bottoms, onePiece, setup

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .bag: return "バック"
        case .shoes: return "シューズ"
        case .tops: return "トップス"
        case .accessory: return "アクセサリー"
        case .outer: return "アウター"
        case .bottoms: return "ボトムス"
        case .onePiece: return "ワンピース"
        case .setup: return "セットアップ"
        }
    }
}

enum Season: String, Codable, CaseIterable, Identifiable {
    case spring, summer, autumn, winter

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .spring: return "春"
        case .summer: return "夏"
        case .autumn: return "秋"
        case .winter: return "冬"
        }
    }
}
