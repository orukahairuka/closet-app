//
//  ClosetItemEntity.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/14.
//

import Foundation

struct ClosetItemEntity: Hashable, Identifiable {
    let id: UUID
    let imageData: Data?
    let category: Category
    let season: Season
    let productURL: URL?
    init(
        id: UUID = UUID(),
        imageData: Data?,
        category: Category,
        season: Season,
        productURL: URL?,
    ) {
        self.id = id
        self.imageData = imageData
        self.category = category
        self.season = season
        self.productURL = productURL
    }
}
