//
//  ClosetItemListView.swift
//  closet-app
//
//  Created by shorei on 2025/06/12.
//

import SwiftUI
import SwiftData

struct ClosetItemListView: View {
    @Query private var items: [ClosetItem]

    var body: some View {
        List(items) { item in
            HStack {
                if let data = item.imageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                VStack(alignment: .leading) {
                    Text(item.category.displayName)
                    Text(item.season.displayName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("登録アイテム")
    }
}
