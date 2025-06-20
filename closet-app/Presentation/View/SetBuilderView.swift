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

    private let columns = [GridItem(.adaptive(minimum: 160), spacing: 16)]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // MARK: - セット名入力
                TextField("セット名を入力", text: $setName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                // MARK: - 季節 / TPO
                VStack(spacing: 12) {
                    Picker("季節", selection: $selectedSeason) {
                        ForEach(Season.allCases) { season in
                            Text(season.displayName).tag(season)
                        }
                    }
                    .pickerStyle(.segmented)

                    Picker("TPO", selection: $selectedTPO) {
                        ForEach(TPO.allCases) { tpo in
                            Text(tpo.displayName).tag(tpo)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .padding(.horizontal)

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
                                LazyVGrid(columns: columns, spacing: 16) {
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
                                            }
                                        )
                                    }
                                }
                                .padding(.top, 8)
                            },
                            label: {
                                HStack {
                                    Image(systemName: iconName(for: category))
                                        .frame(width: 20)

                                    Text(category.displayName)
                                        .font(.headline)

                                    Spacer()

                                    Image(systemName: expandedCategories.contains(category) ? "chevron.down" : "chevron.right")
                                        .foregroundColor(.gray)
                                        .font(.subheadline)
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
            .padding(.top)
        }
        .navigationTitle("セット作成")
    }

    // カテゴリ用アイコン
    private func iconName(for category: Category) -> String {
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
