//
//  CoordinateAIManager.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/21.
//

import Foundation
import SwiftUI
import GoogleGenerativeAI


// CoordinateAIManager.swift

import Foundation
import SwiftUI
import GoogleGenerativeAI


//テスト用のView

// GeminiResultView.swift

import SwiftUI
import SwiftData

struct GeminiResultView: View {
    @Query private var allSets: [CoordinateSetModel]
    @State private var recommendations: [(UUID, String)] = []

    var body: some View {
        VStack(spacing: 20) {
            Text("Geminiが選んだおすすめコーデ")
                .font(.title2)
                .fontWeight(.bold)

            if recommendations.isEmpty {
                Text("まだ読み込まれていません")
                    .foregroundColor(.gray)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(recommendations, id: \.0) { (id, reason) in
                            if let set = allSets.first(where: { $0.id == id }) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(set.name)
                                        .font(.headline)
                                    HStack {
                                        Text("季節: \(String(describing: set.season))")
                                        Spacer()
                                        Text("TPO: \(String(describing: set.tpoTag))")
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                    Text("💬 \(reason)")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                        .padding(.top, 4)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .shadow(radius: 2)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }

            Button("AIにおすすめを聞く") {
                Task {
                    let mockCoords = allSets.map { CoordinateDTO(from: $0) }
                    let aiManager = CoordinateAIManager(fetchWeatherUseCase: FetchCurrentWeatherUseCase(repository: WeatherRepository()))

                    print("🟡 コーデ候補数: \(mockCoords.count)")

                    let result = await aiManager.fetchAndSend(
                        availableCoordinates: mockCoords,
                        tpo: "school",
                        season: "summer"
                    )

                    print("🟢 表示対象: \(result)")
                    recommendations = result
                }
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 40)
        }
        .padding(.top)
    }
}
