//
//  CoordinateSuggestionView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/14.
//

import SwiftUI

struct CoordinateSuggestionView: View {
    @ObservedObject var viewModel: CoordinateSuggestionViewModel

    var body: some View {
        VStack(spacing: 20) {
            // 服装レベル表示
            Text("服装レベルは……")
                .font(.headline)

            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { level in
                    Circle()
                        .fill(level <= viewModel.clothingLevel.rawValue ? levelColor(level) : Color.gray.opacity(0.2))
                        .frame(width: 12, height: 12)
                }
            }

            // コーデパターンの表示
            if let coordinate = viewModel.suggestedCoordinate {
                Text("提案パターン：\(patternLabel(for: coordinate.pattern))")
                    .font(.subheadline)

                // アイテムカード表示
                ForEach(coordinate.items, id: \.id) { item in
                    ClosetCardView(item: item.toModel())
                }

            } else {
                Text("該当するコーデが見つかりませんでした")
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }

    private func levelColor(_ level: Int) -> Color {
        switch level {
        case 1: return .blue
        case 2: return .cyan
        case 3: return .green
        case 4: return .orange
        case 5: return .red
        default: return .gray
        }
    }

    private func patternLabel(for pattern: CoordinatePattern) -> String {
        switch pattern {
        case .topBottomShoes: return "トップス + ボトムス + シューズ"
        case .setupShoes: return "セットアップ + シューズ"
        case .onepieceShoes: return "ワンピース + シューズ"
        }
    }
}
