import SwiftUI

struct OutfitSpotlightMockView: View {
    @State private var recommendedSet: [MockClosetItem] = OutfitSpotlightMockView.randomMockSet()

    // ✅ 固定のモックデータ（あなたのセット）
    private let mySets: [[MockClosetItem]] = [
        [
            MockClosetItem(id: UUID(), imageName: "preset_tops_1", seasonLabel: "春"),
            MockClosetItem(id: UUID(), imageName: "preset_bottoms_2", seasonLabel: "春"),
            MockClosetItem(id: UUID(), imageName: "preset_shoes_3", seasonLabel: "春")
        ],
        [
            MockClosetItem(id: UUID(), imageName: "preset_outer_4", seasonLabel: "冬"),
            MockClosetItem(id: UUID(), imageName: "preset_bottoms_5", seasonLabel: "冬"),
            MockClosetItem(id: UUID(), imageName: "preset_shoes_1", seasonLabel: "冬")
        ]
    ]

    var body: some View {
        ZStack {
            LinearGradient(colors: [.pink.opacity(0.1), .blue.opacity(0.1)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 32) {
                // MARK: - 今日のおすすめセット
                VStack(alignment: .leading, spacing: 16) {
                    Text("🌟 今日のおすすめセット（AI分析）")
                        .font(.title2.bold())
                        .padding(.leading, 16)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(recommendedSet, id: \.id) { item in
                                MockClosetCardView(item: item)
                            }
                        }
                        .padding(.horizontal)
                    }

                    Button("他の選択肢を見る") {
                        recommendedSet = OutfitSpotlightMockView.randomMockSet()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.leading)
                }

                // MARK: - あなたのセット（固定）
                VStack(alignment: .leading, spacing: 16) {
                    Text("🧳 あなたのセット")
                        .font(.title3.bold())
                        .padding(.leading, 16)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 24) {
                            ForEach(mySets.indices, id: \.self) { index in
                                HStack(spacing: 12) {
                                    ForEach(mySets[index]) { item in
                                        MockClosetCardView(item: item)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                Spacer()
            }
            .padding(.top)
        }
    }

    // ✅ おすすめセット（毎回ランダム）
    static func randomMockSet() -> [MockClosetItem] {
        let categories = ["tops", "bottoms", "shoes"]
        return categories.map { category in
            let index = Int.random(in: 1...6)
            return MockClosetItem(
                id: UUID(),
                imageName: "preset_\(category)_\(index)",
                seasonLabel: ["春", "夏", "秋", "冬"].randomElement()!
            )
        }
    }
}

// ✅ モック用データ構造
struct MockClosetItem: Identifiable {
    let id: UUID
    let imageName: String
    let seasonLabel: String
}

// ✅ カードView（大きめ画像＋ラベル付き）
struct MockClosetCardView: View {
    let item: MockClosetItem

    private let cardWidth: CGFloat = 140
    private let cardHeight: CGFloat = 200

    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: cardWidth, height: cardHeight)
                .clipped()
                .cornerRadius(12)

            Text(item.seasonLabel)
                .font(.caption2)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.black.opacity(0.4))
                .cornerRadius(8)
                .padding([.top, .leading], 8)
        }
        .frame(width: cardWidth, height: cardHeight)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
    }
}

