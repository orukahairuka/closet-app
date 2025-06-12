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

    @Bindable var item: ClosetItem

    @State private var showImagePicker = false
    @State private var newImage: UIImage?
    @State private var urlText: String = ""

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

                        if let newImage = newImage {
                            Image(uiImage: newImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                        } else if let data = item.imageData, let uiImage = UIImage(data: data) {
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
                    Picker("カテゴリ", selection: $item.category) {
                        ForEach(Category.allCases) { category in
                            Text(category.displayName).tag(category)
                        }
                    }

                    Text("季節")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.bottom, 4)
                    Picker("季節", selection: $item.season) {
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

                    TextField("https://example.com", text: Binding(
                        get: { item.productURL?.absoluteString ?? "" },
                        set: {
                            item.productURL = URL(string: $0)
                            urlText = $0
                        }
                    ))
                    .textFieldStyle(.roundedBorder)

                    if let url = item.productURL, !url.absoluteString.isEmpty {
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
                        get: { item.memo ?? "" },
                        set: { item.memo = $0 }
                    ))
                    .textFieldStyle(.roundedBorder)
                }

                // 保存ボタン
                Button(action: {
                    if let newImage = newImage {
                        item.imageData = newImage.jpegData(compressionQuality: 0.8)
                    }
                    try? context.save()
                    dismiss()
                }) {
                    Text("保存する")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.top, 20)

            }
            .padding()
        }
        .navigationTitle("アイテム編集")
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $newImage)
        }
        .background(
            LinearGradient(
                colors: [Color.white.opacity(0.9), Color.green.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}
