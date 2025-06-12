//
//  ClosetCardView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/12.
//

import SwiftUI

struct ClosetCardView: View {
    let item: ClosetItem

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
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

            Text(item.category.displayName)
                .font(.headline)
            Text(item.season.displayName)
                .font(.subheadline)
                .foregroundColor(.secondary)

            if let memo = item.memo {
                Text(memo)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }

        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
    }
}
