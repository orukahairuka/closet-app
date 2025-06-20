//
//  CoordinateSetModel.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/20.
//
//これは AIに送るためのモデル

import Foundation
import SwiftData

@Model
class CoordinateSetModel: Identifiable {
    var id: UUID
    var name: String  // セットの名前（例: 春の通学コーデ）
    var itemIDs: [UUID]
    var season: Season
    var tpoTag: TPO  // 例: "通学", "オフィス", "デート"
    var createdAt: Date

    init(id: UUID = UUID(), name: String, itemIDs: [UUID], season: Season, tpoTag: TPO, createdAt: Date = .now) {
        self.id = id
        self.name = name
        self.itemIDs = itemIDs
        self.season = season
        self.tpoTag = tpoTag
        self.createdAt = createdAt
    }
}
