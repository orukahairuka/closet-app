//
//  CategoryAndSeason.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/14.
//
import Foundation

enum Category: String, CaseIterable, Identifiable, Codable, Equatable {
    var id: String { self.rawValue }

    case tops, bottoms, outer, onePiece, setup, shoes, bag, accessory

    var displayName: String {
        switch self {
        case .tops: return "トップス"
        case .bottoms: return "ボトムス"
        case .outer: return "アウター"
        case .onePiece: return "ワンピース"
        case .setup: return "セットアップ"
        case .shoes: return "シューズ"
        case .bag: return "バッグ"
        case .accessory: return "アクセサリー"
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
