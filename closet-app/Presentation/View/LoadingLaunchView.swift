//
//  loadingView.swift
//  closet-app
//
//  Created by 前田 梨緒 on 2025/06/15.
//

import SwiftUI
import Lottie
import SwiftData
import PopupView


public struct LoadingLaunchView: View {
    @EnvironmentObject var recommendationState: RecommendationState
    @State private var isReady = false
    @Environment(\.modelContext) private var context

    let aiManager = CoordinateAIManager(fetchWeatherUseCase: FetchCurrentWeatherUseCase(repository: WeatherRepository()))

    public var body: some View {
        if isReady {
            AnyView(
                MainTabView()
                    .environmentObject(recommendationState)
                    .modelContext(context) // 👈これが必須！
                    .popup(isPresented: Binding(
                        get: { recommendationState.showPopup },
                        set: { recommendationState.showPopup = $0 }
                    )) {
                        if let first = recommendationState.recommendedSets.first {
                            RecommendedPopupView(setID: first.0, reason: first.1)
                            RecommendedPopupView(setID: first.0, reason: first.1)
                                .modelContext(context)

                        } else {
                            EmptyView()
                        }
                    } customize: {
                        $0
                            .type(.floater())
                            .position(.bottom)
                            .autohideIn(5)
                            .closeOnTapOutside(true)
                    }
            )
        } else {
            AnyView(
                VStack(spacing: 32) {
                    LottieView {
                      try await LottieAnimation.named("loading")
                    }
                    .looping()
                    .frame(width: 200, height: 200)

                    Text("loading...")
                        .fontWeight(.light)
                        .font(.system(size: 32))
                        .foregroundColor(Color.gray)
                }
                .task {
                    await loadRecommendation()
                    withAnimation {
                        isReady = true
                    }
                }
            )
        }
    }

    private func loadRecommendation() async {
        let coords = await loadCoordinateDTOs()
        let result = await aiManager.fetchAndSend(
            availableCoordinates: coords,
            tpo: "school",
            season: "summer"
        )
        recommendationState.recommendedSets = result
        recommendationState.lastUpdated = Date()
        recommendationState.showPopup = true
    }

    private func loadCoordinateDTOs() async -> [CoordinateDTO] {
        let context = try? ModelContext(ModelContainer(for: CoordinateSetModel.self))
        let fetch = try? context?.fetch(FetchDescriptor<CoordinateSetModel>())
        return (fetch ?? []).map { CoordinateDTO(from: $0) }
    }
}



import SwiftUI
import SwiftData

struct RecommendedPopupView: View {
    let setID: UUID
    let reason: String

    @Query private var allSets: [CoordinateSetModel]

    var body: some View {
        if let set = allSets.first(where: { $0.id == setID }) {
            VStack(alignment: .leading, spacing: 8) {
                Text("🎉 今日のおすすめコーデ")
                    .font(.headline)
                Text(set.name)
                    .font(.title3)
                    .bold()
                Text("TPO: \(String(describing: set.tpoTag)), 季節: \(String(describing: set.season))")
                    .font(.subheadline)
                Text("💬 \(reason)")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial))
            .padding()
        }
    }
}
