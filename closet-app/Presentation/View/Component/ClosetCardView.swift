//
//  ClosetCardView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/12.
//

import SwiftUI

struct ClosetCardView: View {
    let item: ClosetItemEntity
    var isSelected: Bool = false       // ← 追加
    var onTap: (() -> Void)? = nil   // ← オプショナルに

    
    // 横2列に並べる用サイズ
    private let cardWidth: CGFloat = (UIScreen.main.bounds.width / 2) - 24
    private let cardHeight: CGFloat = 220
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // 背景＋画像
            Group {
                if let data = item.imageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: cardWidth, height: cardHeight)
                        .clipped()
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .overlay(Text("No Image").foregroundColor(.gray))
                }
            }
            .frame(width: cardWidth, height: cardHeight)
            .cornerRadius(12)

            // 左上：季節ラベル
            Text(item.season.displayName)
                .font(.caption2)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.black.opacity(0.4))
                .cornerRadius(8)
                .padding([.top, .leading], 8)

            // ✅ 選択オーバーレイ＆チェックマーク
            if isSelected {
                // 半透明黒オーバーレイ（全体サイズで）
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.4))
                    .frame(width: cardWidth, height: cardHeight)

                // チェックマーク（中央）
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .frame(width: cardWidth, height: cardHeight)
            }
        }
        
        .frame(width: cardWidth, height: cardHeight)
        
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)


        .onTapGesture {
            onTap?()
        }
    }
}
