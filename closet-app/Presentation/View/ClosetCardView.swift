//
//  ClosetCardView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/12.
//

import SwiftUI

struct ClosetCardView: View {
    let item: ClosetItemEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 画像
            if let data = item.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                    .clipped()
                    .cornerRadius(12)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 100)
                    .overlay(Text("No Image").foregroundColor(.gray))
            }

            // カテゴリ・季節
            Text(item.category.displayName)
                .font(.headline)
            Text(item.season.displayName)
                .font(.subheadline)
                .foregroundColor(.secondary)

            // メモ（省略表示）
            if let memo = item.memo {
                Text(memo)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .truncationMode(.tail)
            }

            Spacer() // 下にスペース追加で高さ調整
        }
        .padding()
        .frame(height: 220) // ← 高さを統一
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
    }
}
