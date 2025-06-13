////
////  SwiftData.swift
////  closet-app
////
////  Created by shorei on 2025/06/12.
////
//
//import SwiftData
//import Foundation
//
//@Model
//class ClosetItemModel {
//	var id: UUID
//	var imageData: Data?     // 画像（UIImageをDataに変換して保存）
//	var category: Category   // トップス・ボトムスなど
//	var season: Season       // 春夏秋冬
//	var productURL: URL?     // 商品URL（任意）
//	var memo: String?        // バックやセットアップの補足情報など
//
//	init(
//		imageData: Data? = nil,
//		category: Category,
//		season: Season,
//		productURL: URL? = nil,
//		memo: String? = nil
//	) {
//		self.id = UUID()
//		self.imageData = imageData
//		self.category = category
//		self.season = season
//		self.productURL = productURL
//		self.memo = memo
//	}
//}
//
//enum Category: String, Codable, CaseIterable, Identifiable {
//	case bag, shoes, tops, accessory, outer, bottoms, onePiece, setup
//
//	var id: String { rawValue }
//
//	var displayName: String {
//		switch self {
//		case .bag: return "バック"
//		case .shoes: return "シューズ"
//		case .tops: return "トップス"
//		case .accessory: return "アクセサリー"
//		case .outer: return "アウター"
//		case .bottoms: return "ボトムス"
//		case .onePiece: return "ワンピース"
//		case .setup: return "セットアップ"
//		}
//	}
//}
//
//enum Season: String, Codable, CaseIterable, Identifiable {
//	case spring, summer, autumn, winter
//
//	var id: String { rawValue }
//
//	var displayName: String {
//		switch self {
//		case .spring: return "春"
//		case .summer: return "夏"
//		case .autumn: return "秋"
//		case .winter: return "冬"
//		}
//	}
//}
