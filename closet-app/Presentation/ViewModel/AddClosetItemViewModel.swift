//
//  AddClosetItemViewModel.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/14.
//
import Foundation
import UIKit

final class AddClosetItemViewModel: ObservableObject {
    @Published var selectedCategory: Category = .tops
    @Published var selectedSeason: Season = .spring
    @Published var image: UIImage?
    @Published var urlText: String = ""
    @Published var memo: String = ""

    private let useCase: AddClosetItemUseCaseProtocol

    init(useCase: AddClosetItemUseCaseProtocol) {
        self.useCase = useCase
    }

    func save() throws {
        let entity = ClosetItemEntity(
            imageData: image?.jpegData(compressionQuality: 0.8),
            category: selectedCategory,
            season: selectedSeason,
            productURL: URL(string: urlText),
            memo: memo.isEmpty ? nil : memo
        )
        try useCase.execute(item: entity)
    }
}
