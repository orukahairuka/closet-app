//
//  SetsView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/20.
//

import SwiftUI
import SwiftData

struct SetBuilderView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @Query private var allItems: [ClosetItemModel]

    @State private var selectedItemIDs: Set<UUID> = []
    @State private var expandedCategories: Set<Category> = [] // ← 初期は全部閉じる
    @State private var setName: String = ""
    @State private var selectedSeason: Season = .spring
    @State private var selectedTPO: TPO = .school

    // グリッド列の定義を調整
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    // カードサイズをさらに小さく調整
    private let cardWidth: CGFloat = (UIScreen.main.bounds.width - 110) / 3
    private let cardHeight: CGFloat = 120

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                // MARK: - セット名入力
                TextField("セット名を入力", text: $setName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                Divider()

                // MARK: - 季節 / TPO
                section(title: "季節") {
                    Picker("季節", selection: $selectedSeason) {
                        ForEach(Season.allCases) { season in
                            Text(season.displayName).tag(season)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Divider()

                section(title: "TPO") {
                    Picker("TPO", selection: $selectedTPO) {
                        ForEach(TPO.allCases) { tpo in
                            Text(tpo.displayName).tag(tpo)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Divider()

                // MARK: - カテゴリ別の折りたたみ表示
                ForEach(Category.allCases) { category in
                    let filteredItems = allItems.filter { $0.category == category }

                    if !filteredItems.isEmpty {
                        DisclosureGroup(
                            isExpanded: Binding(
                                get: { expandedCategories.contains(category) },
                                set: { isOpen in
                                    if isOpen {
                                        expandedCategories.insert(category)
                                    } else {
                                        expandedCategories.remove(category)
                                    }
                                }
                            ),
                            content: {
                                LazyVGrid(columns: columns, spacing: 12) {
                                    ForEach(filteredItems) { item in
                                        ClosetCardView(
                                            item: item.toEntity(),
                                            isSelected: selectedItemIDs.contains(item.id),
                                            onTap: {
                                                if selectedItemIDs.contains(item.id) {
                                                    selectedItemIDs.remove(item.id)
                                                } else {
                                                    selectedItemIDs.insert(item.id)
                                                }
                                            },
                                            customWidth: cardWidth,
                                            customHeight: cardHeight
                                        )
                                    }
                                }
                                .padding(.top, 8)
                            },
                            label: {
                                HStack {
                                    Image(iconName(for: category))
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.black)
                                        .colorMultiply(.black)

                                    Text(category.displayName)
                                        .font(.headline)
                                }
                                .contentShape(Rectangle()) // ラベル全体タップ可能
                            }
                        )
                        .padding(.horizontal)
                        .padding(.top, 12)
                    }
                }

                // MARK: - 保存ボタン（アニメーション付き）
                SaveButtonView {
                    let newSet = CoordinateSetModel(
                        name: setName,
                        itemIDs: Array(selectedItemIDs),
                        season: selectedSeason,
                        tpoTag: selectedTPO
                    )
                    context.insert(newSet)
                    try? context.save()
                    print("✅ セット '\(setName)' を保存しました（ID: \(newSet.id)）")
                    dismiss()
                }
                .disabled(setName.isEmpty)
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
        }
    }

    // Picker用の共通セクション
    @ViewBuilder
    private func section<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content()
                .pickerStyle(.menu)
                .tint(.primary)
        }
    }

    // カテゴリ用アイコン
    private func iconName(for category: Category) -> String {
        switch category {
        case .bag: return "navigatebar_bags"
        case .shoes: return "navigatebar_shoes"
        case .tops: return "navigatebar_tops"
        case .outer: return "navigatebar_outer"
        case .bottoms: return "navigatebar_bottoms"
        case .onePiece: return "navigatebar_onepiece"
        }
    }
}
