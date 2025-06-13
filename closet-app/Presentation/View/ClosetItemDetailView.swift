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

    let item: ClosetItemModel  // ← 直接受け取る

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
        ScrollView {
            VStack(spacing: 24) {

                // 画像セクション
                VStack {
                    Text("アイテム画像")
                        .font(.headline)

                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                            .frame(height: 180)
                            .shadow(radius: 4)

                        if let newImage = viewModel.newImage {
                            Image(uiImage: newImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                        } else if let data = viewModel.item.imageData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.gray)
                        }
                    }

                    Button("画像を変更") {
                        showImagePicker = true
                    }
                    .buttonStyle(.bordered)
                    .padding(.top, 8)
                }

                // 基本情報
                VStack(alignment: .leading, spacing: 16) {
                    Text("カテゴリ")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.bottom, 4)
                    Picker("カテゴリ", selection: $viewModel.item.category) {
                        ForEach(Category.allCases) { category in
                            Text(category.displayName).tag(category)
                        }
                    }

                    Text("季節")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.bottom, 4)
                    Picker("季節", selection: $viewModel.item.season) {
                        ForEach(Season.allCases) { season in
                            Text(season.displayName).tag(season)
                        }
                    }
                }

                // 商品URL
                VStack(alignment: .leading, spacing: 12) {
                    Text("商品ページのURL")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.bottom, 4)

                    TextField("https://example.com", text: $viewModel.urlText)
                        .textFieldStyle(.roundedBorder)

                    if let url = viewModel.item.productURL, !url.absoluteString.isEmpty {
                        Link("▶︎ 商品ページを開く", destination: url)
                            .font(.callout)
                            .foregroundColor(.blue)
                    }
                }

                // メモ
                VStack(alignment: .leading, spacing: 12) {
                    Text("メモ")
                        .font(.subheadline)

                    TextField("お気に入りポイントなど", text: Binding(
                        get: { viewModel.item.memo ?? "" },
                        set: { viewModel.item.memo = $0 }
                    ))
                    .textFieldStyle(.roundedBorder)
                }

                /// 保存ボタン
                Button {
                    viewModel.saveChanges()
                    dismiss()
                } label: {
                    Text("保存する")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

                // 削除ボタン
                Button(role: .destructive) {
                    showDeleteConfirm = true
                } label: {
                    Text("削除する")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(12)
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
        .navigationTitle("アイテム編集")
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $viewModel.newImage)
        }
        .onAppear {
            print("✅ DetailView appeared")

            configureViewModelIfNeeded()
        }

    }
}
