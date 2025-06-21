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
    @Namespace private var categoryTabAnimation


    private let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            VStack {
                // カテゴリタブビュー
                categoryTabView()
                

                // 選択されたカテゴリのコンテンツ
                categoryContent(for: selectedCategory)
            }
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
            .padding(.vertical, 10)
        }
        .frame(height: 80)
        .modifier(PurpleTabBarBackgroundModifier())  // ← ここ！
    }


    // 個別のタブアイテム
    private func categoryTabItem(category: Category) -> some View {
        VStack {
            Image(categoryIcon(for: category))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)


            Text(category.displayName)
                .font(.caption)
                .bold()
        }
        .foregroundColor(.white)
        .padding(8)
        .background(
            ZStack {
                if selectedCategory == category {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.25))
                        .matchedGeometryEffect(id: "selectedCategory", in: categoryTabAnimation)
                }
            }
        )
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedCategory = category
            }
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
                        ClosetCardView(item: item.toEntity()) // カードは Entity 用
                    }
                    .buttonStyle(PlainButtonStyle())
                }


            }
            .padding()
        }
    }


    private func categoryIcon(for category: Category) -> String {
        switch category {
        case .bag: return "navigaitonbar_bags"
        case .shoes: return "navigaitonbar_shoes"
        case .tops: return "navigaitonbar_tops"
        case .accessory: return "navigaitonbar_accessories"
        case .outer: return "navigaitonbar_outer"
        case .bottoms: return "navigaitonbar_bottoms"
        case .onePiece: return "navigaitonbar_onepiece"
        case .setup: return "navigaitonbar_setup"
        }
    }
}
