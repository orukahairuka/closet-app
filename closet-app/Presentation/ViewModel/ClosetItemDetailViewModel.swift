//
//  ClosetItemDetailViewModel.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/14.
//
// Presentation/ViewModel/ClosetItemDetailViewModel.swift
import Foundation
import SwiftData
import UIKit

final class ClosetItemDetailViewModel: ObservableObject {
    @Published var item: ClosetItemModel
    @Published var newImage: UIImage?
    @Published var urlText: String = ""
    @Published var selectedTPO: TPO = .school
    @Published var selectedSetID: UUID?



    private var context: ModelContext?
    private var deleteUseCase: DeleteClosetItemUseCaseProtocol?

    // デフォルトの初期化（StateObjectの仮初期化用）
    init() {
        // 仮のデータ（中身は何でもOK）
        self.item = ClosetItemModel(category: .tops, season: .spring, tpoTag: .office)
    }

    /// 実際のデータをViewのbody内で注入する
    func setUp(item: ClosetItemModel,
               context: ModelContext,
               deleteUseCase: DeleteClosetItemUseCaseProtocol,
               allSets: [CoordinateSetModel]) {
        self.item = item
        self.context = context
        self.deleteUseCase = deleteUseCase
        self.urlText = item.productURL?.absoluteString ?? ""
        self.selectedTPO = item.tpoTag

        // 所属セットIDを初期化
        self.selectedSetID = allSets.first(where: { $0.itemIDs.contains(item.id) })?.id
    }

    func updateSetMembership(allSets: [CoordinateSetModel]) {
        guard let selectedID = selectedSetID else { return }

        if let set = allSets.first(where: { $0.id == selectedID }),
           !set.itemIDs.contains(item.id) {
            set.itemIDs.append(item.id)
        }
    }


    func saveChanges() {
        if let newImage = newImage {
            item.imageData = newImage.jpegData(compressionQuality: 0.8)
        }
        item.productURL = URL(string: urlText)
        item.tpoTag = selectedTPO
        try? context?.save()
    }

    func deleteItem() throws {
        guard let deleteUseCase else { return }
        try deleteUseCase.execute(id: item.id)
    }
}

