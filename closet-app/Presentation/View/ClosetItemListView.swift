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

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(items) { item in
                        NavigationLink {
                            ClosetItemDetailView(item: item)
                        } label: {
                            ClosetCardView(item: item)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("登録アイテム")
        }
    }
}
