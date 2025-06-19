//
//  ClosetCardView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/12.
//

import SwiftUI

struct ClosetCardView: View {
    let item: ClosetItemEntity

    // 横2列に並べる用サイズ
    private let cardWidth: CGFloat = (UIScreen.main.bounds.width / 2) - 24
    private let cardHeight: CGFloat = 220

    var body: some View {
        ZStack(alignment: .topLeading) {
            // 画像本体
            if let data = item.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: cardWidth, height: cardHeight)
                    .clipped()
                    .cornerRadius(12)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: cardWidth, height: cardHeight)
                    .overlay(Text("No Image").foregroundColor(.gray))
            }

            // 左上：季節ラベル
            Text(item.season.displayName)
                .font(.caption2)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.black.opacity(0.4))
                .cornerRadius(8)
                .padding([.top, .leading], 8)

            // 右上：いいねハート
            HStack {
                Spacer()
                VStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 28, height: 28)
                        .overlay(
                            Image(systemName: "heart")
                                .font(.system(size: 14))
                                .foregroundColor(.red)
                        )
                        .padding(.top, 8)
                        .padding(.trailing, 8)
                    Spacer()
                }
            }
        }
        .frame(width: cardWidth, height: cardHeight)
        .background(Color.white.opacity(0.0001)) // 背景タップ対応
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}


#Preview {
    Group {
        ClosetCardView(item: .init(
            id: UUID(),
            imageData: nil,
            category: .tops,
            season: .spring,
            productURL: nil
        ))

        ClosetCardView(item: .init(
            id: UUID(),
            imageData: UIImage(named: "sample_shoes")?.pngData(),
            category: .shoes,
            season: .summer,
            productURL: nil
        ))
    }
    .previewLayout(.sizeThatFits)
    .padding()
}
