//
//  ClosetItemMapper.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/14.
//

import Foundation

extension ClosetItemModel {
    func toEntity() -> ClosetItemEntity {
        ClosetItemEntity(
            id: self.id,
            imageData: self.imageData,
            category: self.category,
            season: self.season,
            productURL: self.productURL,
            tpoTag: self.tpoTag,
        )
    }
}

extension ClosetItemEntity {
    func toModel() -> ClosetItemModel {
        ClosetItemModel(
            id: self.id,
            imageData: self.imageData,
            category: self.category,
            season: self.season,
            productURL: self.productURL,
            tpoTag: self.tpoTag
        )
    }
}
