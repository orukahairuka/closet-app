//
//  SetsPreviewView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/20.
//

//
//  SetsPreviewView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/20.
//

import SwiftUI
import SwiftData

struct SetsPreviewView: View {
    @Environment(\.modelContext) private var context
    @Query private var allSets: [CoordinateSetModel]

    var body: some View {
        NavigationStack {
            ZStack {
                NightGlassBackground() // 🌌 背景グラデーション

                ScrollView {
                    LazyVStack(spacing: 24) {
                        ForEach(allSets) { set in
                            VStack(alignment: .leading, spacing: 12) {
                                // ✅ アイテム画像（横スクロール）
                                HStack(spacing: 12) {
                                    ForEach(items(for: set).prefix(3), id: \.id) { item in
                                        if let data = item.imageData,
                                           let uiImage = UIImage(data: data) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 140)
                                                .clipped()
                                                .cornerRadius(12)
                                                .background(Color.white)
                                                .shadow(radius: 3)
                                        } else {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(width: 100, height: 140)
                                                .overlay(Text("No Image").foregroundColor(.white))
                                        }
                                    }
                                }
                                .padding(.horizontal, 8)


                                // ✅ テキスト情報
                                Text(set.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                HStack {
                                    Text("季節: \(set.season.displayName)")
                                    Spacer()
                                    Text("TPO: \(set.tpoTag.displayName)")
                                }
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 4)
                            .padding(.horizontal)
                        }

                        if allSets.isEmpty {
                            Text("作成されたセットがありません")
                                .foregroundColor(.gray)
                                .padding(.top, 40)
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("コーデ一覧")
        }
    }

    // 📦 itemIDs に一致する ClosetItemModel を取得
    private func items(for set: CoordinateSetModel) -> [ClosetItemModel] {
        let fetchDescriptor = FetchDescriptor<ClosetItemModel>()
        let allItems = (try? context.fetch(fetchDescriptor)) ?? []
        return allItems.filter { set.itemIDs.contains($0.id) }
    }
}
