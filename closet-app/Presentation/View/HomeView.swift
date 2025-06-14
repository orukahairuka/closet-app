//
//  HomeView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/12.
//

import SwiftUI
import _SwiftData_SwiftUI

enum HomeNavigation: Hashable {
    case addItem
}

struct HomeView: View {
    @State private var navigationPath = NavigationPath()
    @Query private var closetItems: [ClosetItemModel]  // SwiftDataからアイテム取得
    @StateObject private var weatherViewModel = WeatherViewModel(
        useCase: FetchCurrentWeatherUseCase(repository: WeatherRepository())
    )

    @State private var isWeatherVisible = false

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: 24) {
                        // ✅ 上部に天気表示
                        WeatherView(viewModel: weatherViewModel, isVisible: $isWeatherVisible)
                            .frame(height: 300) // 固定して目立たせる
                            .padding(.top, 50)
                        // ✅ コーデ提案（天気取得済みであれば表示）
                        if let weather = weatherViewModel.weatherInfo {
                            CoordinateSuggestionView(
                                viewModel: CoordinateSuggestionViewModel(
                                    items: closetItems.map { $0.toEntity() },
                                    weather: weather
                                )
                            )
                        }
                        // ✅ カテゴリ選択ビュー
                        CloseSelectView()

                    }
                    .padding(.bottom, 80) // FABボタン分の余白
                }

                // ✅ 追加ボタン
                Button(action: {
                    navigationPath.append(HomeNavigation.addItem)
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.blue))
                        .shadow(radius: 5)
                }
                .padding()
            }
            .navigationDestination(for: HomeNavigation.self) { route in
                switch route {
                case .addItem:
                    AddClosetItemView()
                }
            }
            .onAppear {
                isWeatherVisible = false
                Task {
                    await weatherViewModel.fetch()
                    isWeatherVisible = true
                }
            }
        }
    }
}
