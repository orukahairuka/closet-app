//
//  AddClosetItemUseCase.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/14.
//

import Foundation

protocol AddClosetItemUseCaseProtocol {
    func execute(item: ClosetItemEntity) throws
}

final class AddClosetItemUseCase: AddClosetItemUseCaseProtocol {
    private let repository: ClosetItemRepositoryProtocol

    init(repository: ClosetItemRepositoryProtocol) {
        self.repository = repository
    }

    func execute(item: ClosetItemEntity) throws {
        try repository.add(item)
    }
}
