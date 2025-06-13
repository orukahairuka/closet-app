//
//  DeleteClosetItemUseCase.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/14.
//

import Foundation

protocol DeleteClosetItemUseCaseProtocol {
    func execute(id: UUID) throws
}

final class DeleteClosetItemUseCase: DeleteClosetItemUseCaseProtocol {
    private let repository: ClosetItemRepositoryProtocol

    init(repository: ClosetItemRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: UUID) throws {
        try repository.delete(id: id)
    }
}
