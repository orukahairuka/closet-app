//
//  ClosetItemModel.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/14.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class ClosetItemModel: Identifiable {
    var id: UUID
    var imageData: Data?
    var category: Category
    var season: Season
    var productURL: URL?
    var memo: String?

    init(
        id: UUID = UUID(),
        imageData: Data? = nil,
        category: Category,
        season: Season,
        productURL: URL? = nil,
        memo: String? = nil
    ) {
        self.id = id
        self.imageData = imageData
        self.category = category
        self.season = season
        self.productURL = productURL
        self.memo = memo
    }
}
