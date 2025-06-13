//
//  ClosetItemMapper.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/14.
//

import Foundation

extension ClosetItem {
    func toEntity() -> ClosetItemEntity {
        ClosetItemEntity(
            id: self.id,
            imageData: self.imageData,
            category: self.category,
            season: self.season,
            productURL: self.productURL,
            memo: self.memo
        )
    }
}

extension ClosetItemEntity {
    func toModel() -> ClosetItem {
        ClosetItem(
            imageData: self.imageData,
            category: self.category,
            season: self.season,
            productURL: self.productURL,
            memo: self.memo
        )
    }
}
