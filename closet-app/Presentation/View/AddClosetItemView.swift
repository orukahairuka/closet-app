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
    @Environment(\.dismiss) private var dismiss

    @State private var selectedCategory: Category = .tops
    @State private var selectedSeason: Season = .spring
    @State private var image: UIImage? = nil
    @State private var showImagePicker = false
    @State private var urlText: String = ""
    @State private var selectedSetID: UUID? = nil
    @State private var selectedTPO: TPO = .office
    @State private var showAddSetSheet = false
    @Binding var allSets: [CoordinateSetModel] // ✅ 親Viewからセット情報を受け取る



    var body: some View {
        ZStack {
            NightGlassBackground()

            ScrollView {
                VStack(spacing: 28) {
                    // MARK: - 画像選択
                    VStack(spacing: 12) {
                        Text("アイテム画像")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                                .frame(height: 200)
                                .shadow(color: .white.opacity(0.1), radius: 10)

                            if let image = image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 160)
                                    .cornerRadius(16)
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }

                        Button("画像を選択") {
                            showImagePicker = true
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.white.opacity(0.3))
                    }
                    .frame(maxWidth: .infinity)

                    // MARK: - カテゴリ
                    glassSection(title: "カテゴリ") {
                        Picker("カテゴリ", selection: $selectedCategory) {
                            ForEach(Category.allCases) { category in
                                Text(category.displayName).tag(category)
                            }
                        }
                        .pickerStyle(.menu)
                        .foregroundColor(.white)
                    }

                    // MARK: - 季節
                    glassSection(title: "季節") {
                        Picker("季節", selection: $selectedSeason) {
                            ForEach(Season.allCases) { season in
                                Text(season.displayName).tag(season)
                            }
                        }
                        .pickerStyle(.menu)
                        .foregroundColor(.white)
                    }

                    // MARK: - URL
                    glassSection(title: "商品URL") {
                        TextField("https://example.com", text: $urlText)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                    }

                    glassSection(title: "所属セット") {
                        Picker("セットを選択", selection: $selectedSetID) {
                            Text("選択しない").tag(UUID?.none)

                            ForEach(allSets) { set in
                                Text(set.name).tag(Optional(set.id))
                            }

                            Text("＋ 新しいセットを作成").tag(UUID?.some(UUID()))  // ダミー
                        }
                        .pickerStyle(.menu)
                        .onChange(of: selectedSetID) { newValue in
                            if let newValue, !allSets.contains(where: { $0.id == newValue }) {
                                showAddSetSheet = true
                                selectedSetID = nil
                            }
                        }
                    }


                    glassSection(title: "TPO") {
                        Picker("TPO", selection: $selectedTPO) {
                            ForEach(TPO.allCases) { tpo in
                                Text(tpo.displayName).tag(tpo)
                            }
                        }
                        .pickerStyle(.menu)
                    }


                    SaveButtonView {
                        let data = image?.jpegData(compressionQuality: 0.8)
                        let newItem = ClosetItemModel(
                            imageData: data,
                            category: selectedCategory,
                            season: selectedSeason,
                            productURL: URL(string: urlText),
                            tpoTag: selectedTPO
                        )

                        context.insert(newItem)

                        if let selectedID = selectedSetID,
                           let set = allSets.first(where: { $0.id == selectedID }) {
                            set.itemIDs.append(newItem.id)
                        }

                        try? context.save()
                        dismiss()
                    }
                    .frame(height: 60)
                    .padding(.bottom, 160) // ✅ 下部余白でTabBarを避ける
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(image: $image)
                }
            }
            .navigationTitle("アイテム追加")
            .sheet(isPresented: $showAddSetSheet) {
                AddSetSheetView { newSet in
                    context.insert(newSet)
                    try? context.save()
                    allSets.append(newSet)        // ✅ 即反映
                           selectedSetID = newSet.id     // ✅ 選択更新
                }
            }

        }
    }
    // MARK: - グラス風セクション共通
    @ViewBuilder
    private func glassSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            content()
        }
        .padding()
        .frame(maxWidth: .infinity) // ✅ 横幅を統一
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(color: .white.opacity(0.05), radius: 4)
    }
}
