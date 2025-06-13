//
//  ClosesSelectView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/12.
//

import SwiftUI
import Parchment
import SwiftData

struct CloseSelectView: View {
    @Query private var items: [ClosetItemModel]
    @State private var selectedCategory: Category = .tops  // デフォルト値を設定

    private let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]

    var body: some View {
        VStack {
            // カテゴリタブビュー
            categoryTabView()

            // 選択されたカテゴリのコンテンツ
            categoryContent(for: selectedCategory)
        }
    }

    // タブビューを別関数に分離して簡略化
    private func categoryTabView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(Category.allCases) { category in
                    categoryTabItem(category: category)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 70)
        .background(Color.gray.opacity(0.1))
    }

    // 個別のタブアイテム
    private func categoryTabItem(category: Category) -> some View {
        VStack {
            Image(systemName: categoryIcon(for: category))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)

            Text(category.displayName)
                .font(.caption)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(selectedCategory == category ? Color.blue.opacity(0.2) : Color.clear)
        )
        .foregroundColor(selectedCategory == category ? .blue : .primary)
        .onTapGesture {
            selectedCategory = category
        }
    }

    private func categoryContent(for category: Category) -> some View {
        let filteredItems = items.filter {
            print("item.category = \($0.category), selected = \(category)")
            return $0.category == category
        }

        return ScrollView {
            if filteredItems.isEmpty {
                Text("このカテゴリにはアイテムがありません")
                    .foregroundColor(.gray)
                    .padding()
            }

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(filteredItems) { item in
                    NavigationLink(destination: ClosetItemDetailView(item: item)) {
                        ClosetCardView(item: item)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }


    private func categoryIcon(for category: Category) -> String {
        switch category {
        case .bag: return "bag.fill"
        case .shoes: return "shoe.fill"
        case .tops: return "tshirt.fill"
        case .accessory: return "circle.hexagongrid.fill"
        case .outer: return "person.crop.rectangle.fill"
        case .bottoms: return "figure.walk"
        case .onePiece: return "figure.dress.line"
        case .setup: return "person.fill"
        }
    }
}
