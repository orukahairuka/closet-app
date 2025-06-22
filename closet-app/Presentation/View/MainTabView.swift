//
//  MainTabView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/19.
//

import SwiftUI
import _SwiftData_SwiftUI
import FloatingButton


enum FullScreenPage {
    case none
    case addItem
    case buildSet
}

struct MainTabView: View {
    @State private var selectedTab: Tab = .weather
    @Namespace private var animation
    @Query private var closetItems: [ClosetItemModel]
    @State private var allSets: [CoordinateSetModel] = []
    @State private var fullScreenPage: FullScreenPage = .none

    @State private var isFabMenuOpen: Bool = false

    var body: some View {
        // ✅ NavigationStack を全体に追加（遷移が効くように）
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                NightGlassBackground()

                currentView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .animation(.easeInOut(duration: 0.25), value: selectedTab)

                CustomTabBarView(selectedTab: $selectedTab, animation: animation)


                fabMenu
                    .padding(.bottom, 80)
                    .padding(.trailing, 6)

                // ポップアップ表示エリア
                if fullScreenPage != .none {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .zIndex(1)

                    VStack(spacing: 0) {
                        // 閉じるボタン
                        HStack(alignment: .center) {
                            Text(titleFor(page: fullScreenPage))
                                .font(.largeTitle.bold())
                                .foregroundStyle(.primary)

                            Spacer()

                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    fullScreenPage = .none
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(.red.opacity(0.8))
                            }
                        }
                        .padding(.bottom, 16)

                        Group {
                            switch fullScreenPage {
                            case .addItem:
                                AddClosetItemView(allSets: $allSets)
                            case .buildSet:
                                SetBuilderView()
                            case .none:
                                EmptyView()
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(.systemBackground))
                            .shadow(radius: 10)
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 90)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                    .zIndex(2)
                }
            }
            .ignoresSafeArea(.keyboard)
        }
    }

    // 表示するページに応じたタイトルを返すヘルパー関数
    private func titleFor(page: FullScreenPage) -> String {
        switch page {
        case .addItem:
            return "アイテム追加"
        case .buildSet:
            return "セット作成"
        case .none:
            return ""
        }
    }

    @ViewBuilder
    private func currentView() -> some View {
        switch selectedTab {
        case .closet:
            CloseSelectView()
        case .weather:
            WeatherTabWrapper(closetItems: closetItems)
        case .add:
            OutfitSpotlightMockView()
        }
    }

    private var fabMenu: some View {
        // メインボタンの見た目を定義
        let mainButton = AnyView(
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isFabMenuOpen.toggle()
                }
            }) {
                Image(systemName: isFabMenuOpen ? "xmark" : "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(isFabMenuOpen ? 45 : 0))
                    .animation(.easeInOut(duration: 0.3), value: isFabMenuOpen)
            }
                .padding(20)
                .background(Circle().fill(Color.purple))
                .shadow(radius: 4)
        )

        // サブボタンの配列を定義
        let subButtons = [
            // セット作成ボタン
            AnyView(createSubButton(imageName: "closet-set", label: "セット", action: {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isFabMenuOpen = false
                    fullScreenPage = .buildSet
                }
            })),
            // アイテム追加ボタン
            AnyView(createSubButton(imageName: "tshirt", label: "アイテム", action: {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isFabMenuOpen = false
                    fullScreenPage = .addItem
                }
            }))
        ]

        return FloatingButton(
            mainButtonView: mainButton,
            buttons: subButtons,
            isOpen: $isFabMenuOpen
        )
        .straight()
        .direction(.top)
        .spacing(16)
        .initialScaling(0.0)     // ✅ 閉じた状態でのスケール（0で非表示）
        .initialOpacity(0.0)     // ✅ 閉じた状態での透明度（0で非表示）
        .animation(.easeInOut(duration: 0.3))  // ✅ アニメーション設定
    }

    // サブボタンのビューを生成するヘルパー関数（修正版）
    private func createSubButton(imageName: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                imageView(for: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)

                Text(label)
                    .font(.subheadline.bold())
                    .minimumScaleFactor(0.8)
            }
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(
                Capsule()
                    .fill(Color.purple.opacity(0.8))
            )
            .shadow(radius: 4)
        }
    }

    // ✅ システムアイコンかどうか判定して Image を切り替える
    private func imageView(for imageName: String) -> Image {
        if UIImage(systemName: imageName) != nil {
            return Image(systemName: imageName)
        } else {
            return Image(imageName)
        }
    }

}
