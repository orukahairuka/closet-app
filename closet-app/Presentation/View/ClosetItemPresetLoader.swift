//
//  ClosetItemPresetLoader.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/22.
//

import Foundation
import SwiftUI
import SwiftData

final class ClosetItemPresetLoader {
    static func insertPresetItemsIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<ClosetItemModel>()
        guard let isEmpty = try? context.fetch(descriptor).isEmpty, isEmpty else {
            print("📦 プリセットは既に存在しています")
            return
        }

        print("🔧 プリセットを追加します")

        let presets: [(String, Category)] = [
            // 👕 tops
            ("preset_tops_1", .tops),
            ("preset_tops_2", .tops),

            // 👖 bottoms
            ("preset_bottoms_1", .bottoms),
            ("preset_bottoms_2", .bottoms),

            // 👟 shoes
            ("preset_shoes_1", .shoes),
            ("preset_shoes_2", .shoes),

            // 👜 bag
            ("preset_bag_1", .bag),
            ("preset_bag_2", .bag),

            // 👗 onePiece
            ("preset_onepiece_1", .onePiece),
            ("preset_onepiece_2", .onePiece),

            // 🧥 outer
            ("preset_outer_1", .outer),
            ("preset_outer_2", .outer)
        ]

        for (imageName, category) in presets {
            guard let uiImage = UIImage(named: imageName),
                  let imageData = uiImage.jpegData(compressionQuality: 0.8) else {
                print("⚠️ 画像 \(imageName) が読み込めません")
                continue
            }

            let newItem = ClosetItemModel(
                imageData: imageData,
                category: category,
                season: .spring,
                productURL: nil,
                tpoTag: .school
            )
            context.insert(newItem)
        }

        try? context.save()
        print("✅ プリセットアイテムを保存しました")
    }
}
