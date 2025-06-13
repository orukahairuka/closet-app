//
//  ClosetItemRepository.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/14.
//

// Data/Repository/ClosetItemRepository.swift

import Foundation
import SwiftData

final class ClosetItemRepository: ClosetItemRepositoryProtocol {
    
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func add(_ item: ClosetItemEntity) throws {
        let model = item.toModel()
        context.insert(model)
    }

    func delete(id: UUID) throws {
        let fetch = FetchDescriptor<ClosetItem>(predicate: #Predicate { $0.id == id })
        if let target = try context.fetch(fetch).first {
            context.delete(target)
            try context.save()
        }
    }
}
