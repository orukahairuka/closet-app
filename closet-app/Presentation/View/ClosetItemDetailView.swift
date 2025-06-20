//
//  ClosetItemDetailView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/12.
//

import SwiftUI
import SwiftData

struct ClosetItemDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var showImagePicker = false
    @State private var showDeleteConfirm = false
    @Query private var allSets: [CoordinateSetModel]
    @State private var selectedSetID: UUID? = nil


    let item: ClosetItemModel
    @StateObject private var viewModel: ClosetItemDetailViewModel

    init(item: ClosetItemModel) {
        self.item = item
        _viewModel = StateObject(wrappedValue: ClosetItemDetailViewModel())
    }

    private func configureViewModelIfNeeded() {
        if viewModel.item.id != item.id {
            let repository = ClosetItemRepository(context: context)
            let deleteUseCase = DeleteClosetItemUseCase(repository: repository)
            viewModel.setUp(item: item, context: context, deleteUseCase: deleteUseCase)
        }
    }

    var body: some View {
        ZStack {
            NightGlassBackground() // 背景にガラス風のレイヤー

            ScrollView {
                VStack(spacing: 28) {
                    // MARK: - 画像セクション
                    VStack(spacing: 12) {
                        Text("アイテム画像")
                            .font(.headline)
                            .foregroundStyle(.white)

                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                                .frame(height: 200)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(color: .white.opacity(0.1), radius: 10)

                            if let newImage = viewModel.newImage {
                                Image(uiImage: newImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 160)
                                    .cornerRadius(16)
                            } else if let data = viewModel.item.imageData, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
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

                        Button("画像を変更") {
                            showImagePicker = true
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.white.opacity(0.3))
                    }

                    // MARK: - 基本情報
                    VStack(alignment: .leading, spacing: 20) {
                        glassSection(title: "カテゴリ") {
                            Picker("カテゴリ", selection: $viewModel.item.category) {
                                ForEach(Category.allCases) { category in
                                    Text(category.displayName).tag(category)
                                }
                            }
                            .pickerStyle(.menu) // ← セグメントからメニューに変更
                        }

                        glassSection(title: "季節") {
                            Picker("季節", selection: $viewModel.item.season) {
                                ForEach(Season.allCases) { season in
                                    Text(season.displayName).tag(season)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }

                    // MARK: - URL
                    glassSection(title: "商品ページのURL") {
                        TextField("https://example.com", text: $viewModel.urlText)
                            .textFieldStyle(.roundedBorder)

                        if let url = viewModel.item.productURL, !url.absoluteString.isEmpty {
                            Link("▶︎ 商品ページを開く", destination: url)
                                .foregroundColor(.blue)
                        }
                    }

                    glassSection(title: "所属セット") {
                        Picker("セットを選択", selection: $selectedSetID) {
                            Text("選択しない").tag(UUID?.none)

                            ForEach(allSets) { set in
                                Text(set.name).tag(Optional(set.id))
                            }

                            Text("＋ 新しいセットを作成").tag(UUID?.some(UUID()))  // 特殊なIDで処理
                        }
                        .pickerStyle(.menu)
                    }

                    glassSection(title: "TPO") {
                        Picker("TPO", selection: $viewModel.selectedTPO) {
                            ForEach(TPO.allCases) { tpo in
                                Text(tpo.displayName).tag(tpo)
                            }
                        }
                        .pickerStyle(.menu)
                    }


                    SaveButtonView {
                        // 新しい画像がある場合は上書き
                        if let newImage = viewModel.newImage {
                            viewModel.item.imageData = newImage.jpegData(compressionQuality: 0.8)
                        }

                        // URLとTPOを更新
                        viewModel.item.productURL = URL(string: viewModel.urlText)
                        viewModel.item.tpoTag = viewModel.selectedTPO

                        // セットに追加（既に所属していなければ）
                        if let selectedID = selectedSetID,
                           let set = allSets.first(where: { $0.id == selectedID }),
                           !set.itemIDs.contains(viewModel.item.id) {
                            set.itemIDs.append(viewModel.item.id)
                        }

                        try? context.save()
                        dismiss()
                    }

                    .frame(height: 60)



                    // MARK: - 削除ボタン
                    Button(role: .destructive) {
                        showDeleteConfirm = true
                    } label: {
                        Text("削除する")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                    .confirmationDialog("本当に削除しますか？", isPresented: $showDeleteConfirm) {
                        Button("削除する", role: .destructive) {
                            do {
                                try viewModel.deleteItem()
                                dismiss()
                            } catch {
                                print("❌ 削除失敗: \(error)")
                            }
                        }
                        Button("キャンセル", role: .cancel) { }
                    }
                }
                .padding()
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $viewModel.newImage)
            }
            .onAppear {
                configureViewModelIfNeeded()

                // このアイテムが含まれるセットがあれば初期選択
                if let matchedSet = allSets.first(where: { $0.itemIDs.contains(item.id) }) {
                    selectedSetID = matchedSet.id
                }
            }

            .navigationTitle("アイテム編集")
        }
    }

    // MARK: - グラス風セクション共通View
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
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(color: .white.opacity(0.05), radius: 4)
    }
}
