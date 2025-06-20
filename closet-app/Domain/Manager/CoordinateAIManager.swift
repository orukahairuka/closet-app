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

final class CoordinateAIManager {
    private let fetchWeatherUseCase: FetchCurrentWeatherUseCase
    private let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)

    init(fetchWeatherUseCase: FetchCurrentWeatherUseCase) {
        self.fetchWeatherUseCase = fetchWeatherUseCase
    }

    func fetchAndSend(availableCoordinates: [CoordinateDTO], tpo: String, season: String) async -> [UUID] {
        do {
            let weather = try await fetchWeatherUseCase.execute()

            let promptData = CoordinatePrompt(
                userCondition: .init(
                    officeTemp: 25.0,
                    officeHumidity: 60.0,
                    outsideTemp: weather.temperature,
                    outsideHumidity: 55.0,
                    season: season,
                    tpo: tpo
                ),
                availableCoordinates: availableCoordinates
            )

            let promptText = makePromptText(from: promptData)
            print("📤 Geminiへのプロンプト:\n\(promptText)")

            let response = try await model.generateContent(promptText)

            if let text = response.text {
                print("📥 Geminiの返答:\n\(text)")
            } else {
                print("⚠️ Geminiからの応答が空です")
            }

            guard let text = response.text,
                  let data = text.data(using: .utf8),
                  let decoded = try? JSONDecoder().decode(AIResponse.self, from: data)
            else {
                print("❌ Geminiレスポンスが不正 or デコードに失敗")
                return []
            }

            print("✅ デコードされたID: \(decoded.recommendedSetIDs)")
            return decoded.recommendedSetIDs.compactMap { UUID(uuidString: $0) }

        } catch {
            print("❌ Gemini通信エラー: \(error)")
            return []
        }
    }

    private func makePromptText(from prompt: CoordinatePrompt) -> String {
        var text = """
        以下の候補の中から、TPOと季節・気温・湿度を考慮して最も適していると思うコーデセットを最大3つ選んでください。
        結果は必ず次の形式のJSONだけで返してください。他の文字や解説は一切つけないでください：

        { "recommendedSetIDs": ["UUID1", "UUID2", "UUID3"] }

        条件：
        外気温：\(prompt.userCondition.outsideTemp)℃
        外湿度：\(prompt.userCondition.outsideHumidity)%
        オフィス気温：\(prompt.userCondition.officeTemp)℃
        オフィス湿度：\(prompt.userCondition.officeHumidity)%
        季節：\(prompt.userCondition.season)
        TPO：\(prompt.userCondition.tpo)

        候補：
        """

        for coord in prompt.availableCoordinates {
            text += "\n- id: \(coord.id), name: \(coord.name), season: \(coord.season), tpo: \(coord.tpoTag)"
        }

        return text
    }

}

//テスト用のView

// GeminiResultView.swift

import SwiftUI
import SwiftData

struct GeminiResultView: View {
    @Query private var allSets: [CoordinateSetModel]
    @State private var recommendedIDs: [UUID] = []

    var body: some View {
        VStack(spacing: 20) {
            Text("Geminiが選んだおすすめコーデ")
                .font(.title2)
                .fontWeight(.bold)

            if recommendedIDs.isEmpty {
                Text("まだ読み込まれていません")
                    .foregroundColor(.gray)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(allSets.filter { recommendedIDs.contains($0.id) }) { set in
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
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .shadow(radius: 2)
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

                    let ids = await aiManager.fetchAndSend(
                        availableCoordinates: mockCoords,
                        tpo: "school",
                        season: "summer"
                    )

                    print("🟢 表示対象ID: \(ids)")
                    recommendedIDs = ids
                }
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 40)
        }
        .padding(.top)
    }
}
