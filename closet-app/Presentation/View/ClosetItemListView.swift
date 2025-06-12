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

    // 2列レイアウト
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(items) { item in
                    ClosetCardView(item: item)
                }
            }
            .padding()
        }
        .navigationTitle("登録アイテム")
    }
}
