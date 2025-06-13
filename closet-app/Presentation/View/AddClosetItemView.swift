//
//  AddClosetItemView.swift
//  closet-app
//
//  Created by shorei on 2025/06/12.
//

import SwiftUI
import SwiftData

struct AddClosetItemView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss  // ← これを追加！

    @State private var selectedCategory: Category = .tops
    @State private var selectedSeason: Season = .spring
    @State private var image: UIImage? = nil
    @State private var showImagePicker = false
    @State private var urlText: String = ""
    @State private var memo: String = ""

    var body: some View {
        Form {
            Section(header: Text("画像")) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                }
                Button("画像を選択") {
                    showImagePicker = true
                }
            }

            Picker("カテゴリ", selection: $selectedCategory) {
                ForEach(Category.allCases) { category in
                    Text(category.displayName).tag(category)
                }
            }

            Picker("季節", selection: $selectedSeason) {
                ForEach(Season.allCases) { season in
                    Text(season.displayName).tag(season)
                }
            }

            TextField("商品URL", text: $urlText)
                .keyboardType(.URL)
                .autocapitalization(.none)

            TextField("メモ", text: $memo)

            Button("保存") {
                let data = image?.jpegData(compressionQuality: 0.8)
                let item = ClosetItemModel(
                    imageData: data,
                    category: selectedCategory,
                    season: selectedSeason,
                    productURL: URL(string: urlText),
                    memo: memo.isEmpty ? nil : memo
                )
                context.insert(item)
                print("✅ 保存したアイテム: (item.category), (item.season)")
                dismiss()
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $image)
        }
    }
}
