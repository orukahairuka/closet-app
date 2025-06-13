//
//  ClosetItemRepositoryProtocol.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/14.
//

import Foundation

protocol ClosetItemRepositoryProtocol {
    func add(_ item: ClosetItemEntity) throws
    func delete(id: UUID) throws
}
