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
        VStack(alignment: .leading, spacing: 16) {
            // 服装レベル（ドットグラデ）
            Text("服装レベルは……")
                .font(.headline)

            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { level in
                    Circle()
                        .fill(color(for: level, selected: viewModel.clothingLevel.rawValue))
                        .frame(width: 14, height: 14)
                }
            }

            // 横スクロールでコーデ提案表示
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 24) {
                    ForEach(viewModel.suggestedCoordinates) { coordinate in
                        VStack(spacing: 8) {
                            Text("コーデパターン: \(patternLabel(for: coordinate.pattern))")
                                .font(.subheadline)

                            ForEach(coordinate.items, id: \.id) { item in
                                ClosetCardView(item: item)
                                    .frame(height: 150) // 👈 追加して表示保証
                            }
                        }
                        .padding()
                        .background(Color.yellow.opacity(0.2)) // 👈 確認用
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .frame(width: 240)
                    }

                }
                .padding(.horizontal)
            }

            // 再提案ボタン
            Button("別のコーデを提案する") {
                viewModel.suggest()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 16)
        }
        .padding(.vertical)
    }

    private func color(for level: Int, selected: Int) -> Color {
        guard level <= selected else { return .white }
        switch selected {
        case 1, 2: return .blue
        case 3: return .green
        case 4: return .orange
        case 5: return .red
        default: return .gray
        }
    }

    private func patternLabel(for pattern: CoordinatePattern) -> String {
        switch pattern {
        case .topBottomShoes: return "トップス＋ボトムス＋シューズ"
        case .setupShoes: return "セットアップ＋シューズ"
        case .onepieceShoes: return "ワンピース＋シューズ"
        }
    }
}
