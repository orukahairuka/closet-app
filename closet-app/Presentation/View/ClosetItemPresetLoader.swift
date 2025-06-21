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


        print("🔧 プリセットを追加します")

        // カテゴリ別に複数の画像を用意
        let presets: [(String, Category)] = [
            // 👕 tops
            ("preset_tops_1", .tops), ("preset_tops_2", .tops),
            ("preset_tops_3", .tops), ("preset_tops_4", .tops),
            ("preset_tops_5", .tops), ("preset_tops_6", .tops),

            // 👖 bottoms
            ("preset_bottoms_1", .bottoms), ("preset_bottoms_2", .bottoms),
            ("preset_bottoms_3", .bottoms), ("preset_bottoms_4", .bottoms),
            ("preset_bottoms_5", .bottoms), ("preset_bottoms_6", .bottoms),

            // 👟 shoes
            ("preset_shoes_1", .shoes), ("preset_shoes_2", .shoes),
            ("preset_shoes_3", .shoes), ("preset_shoes_4", .shoes),
            ("preset_shoes_5", .shoes), ("preset_shoes_6", .shoes),

            // 👜 bag
            ("preset_bag_1", .bag), ("preset_bag_2", .bag),
            ("preset_bag_3", .bag), ("preset_bag_4", .bag),
            ("preset_bag_5", .bag), ("preset_bag_6", .bag),

            // 👗 onePiece
            ("preset_onepiece_1", .onePiece), ("preset_onepiece_2", .onePiece),
            ("preset_onepiece_3", .onePiece), ("preset_onepiece_4", .onePiece),
            ("preset_onepiece_5", .onePiece), ("preset_onepiece_6", .onePiece),

            // 🧥 outer
            ("preset_outer_1", .outer), ("preset_outer_2", .outer),
            ("preset_outer_3", .outer), ("preset_outer_4", .outer),
            ("preset_outer_5", .outer), ("preset_outer_6", .outer)
        ]


        for (imageName, category) in presets {
            if let uiImage = UIImage(named: imageName) {
                print("✅ 読み込めた: \(imageName)")
                if let imageData = uiImage.jpegData(compressionQuality: 0.8) {
                    let newItem = ClosetItemModel(
                        imageData: imageData,
                        category: category,
                        season: .spring,
                        productURL: nil,
                        tpoTag: .school
                    )
                    context.insert(newItem)
                } else {
                    print("❌ JPEG変換失敗: \(imageName)")
                }
            } else {
                print("⚠️ 読み込めない画像: \(imageName)")
            }
        }


        try? context.save()
        print("✅ プリセットアイテムを保存しました")
    }
}
