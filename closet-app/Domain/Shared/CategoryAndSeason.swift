//
//  CategoryAndSeason.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/14.
//
import Foundation

enum Category: String, CaseIterable, Identifiable, Codable, Equatable {
    var id: String { self.rawValue }

    case tops, bottoms, outer, onePiece, shoes, bag

    var displayName: String {
        switch self {
        case .tops: return "トップス"
        case .bottoms: return "ボトムス"
        case .outer: return "アウター"
        case .onePiece: return "ワンピース"
        case .shoes: return "シューズ"
        case .bag: return "バッグ"
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

enum TPO: Int16, CaseIterable, Identifiable, Codable {
    case office, school, date, outing, home, event

    var id: Int16 { self.rawValue }

    var displayName: String {
        switch self {
        case .office: return "オフィス"
        case .school: return "通学"
        case .date: return "デート"
        case .outing: return "おでかけ"
        case .home: return "自宅"
        case .event: return "イベント"
        }
    }
}
