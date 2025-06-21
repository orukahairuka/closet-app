//
//  MainTabView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/19.
//

import SwiftUI
import _SwiftData_SwiftUI

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
                    .padding(.bottom, 90)
                    .padding(.trailing, 24)

                if fullScreenPage != .none {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .zIndex(1)

                    VStack(alignment: .trailing, spacing: 0) {
                        // 閉じるボタン
                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    fullScreenPage = .none
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white.opacity(0.9))
                                    .padding()
                            }
                        }

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
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(.ultraThinMaterial)
                                .shadow(radius: 10)
                        )
                        .padding(.horizontal)
                    }
                    .transition(.move(edge: .trailing))
                    .zIndex(2)
                }
            }
            .ignoresSafeArea(.keyboard)
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
            SetsPreviewView()
        }
    }

    private var fabMenu: some View {
        VStack(spacing: 16) {
            // セット作成ボタン
            Button(action: {
                withAnimation {
                    fullScreenPage = .buildSet
                }
            }) {
                Image(systemName: "square.grid.2x2.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
                    .padding(20)
                    .background(Circle().fill(Color.purple))
                    .shadow(radius: 4)
            }
            .padding(.bottom, 10)


            // アイテム追加ボタン
            Button(action: {
                withAnimation {
                    fullScreenPage = .addItem
                }
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
                    .padding(20)
                    .background(Circle().fill(Color.purple))
                    .shadow(radius: 4)
            }
        }
        .padding(.bottom, 80) // 👈 少し上に移動（調整可）
    }

}

