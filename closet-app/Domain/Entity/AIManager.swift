//  CoordinateDTO.swift
//  closet-app
//
//  Created by 樽井絵理香 on 2025/06/21.

import Foundation
import GoogleGenerativeAI
import Combine

struct CoordinateDTO: Codable {
    let id: String
    let name: String
    let season: String
    let tpoTag: String

    init(from model: CoordinateSetModel) {
        self.id = model.id.uuidString
        self.name = model.name
        self.season = String(describing: model.season)
        self.tpoTag = String(describing: model.tpoTag)
    }
}

// Geminiに送るプロンプト全体
struct CoordinatePrompt: Codable {
    struct UserCondition: Codable {
        let officeTemp: Double
        let officeHumidity: Double
        let outsideTemp: Double
        let outsideHumidity: Double
        let season: String
        let tpo: String
    }

    let userCondition: UserCondition
    let availableCoordinates: [CoordinateDTO]
}

// Geminiから返ってくるIDと理由
struct AIRecommendation: Decodable {
    let id: String
    let reason: String
}

struct AIResponse: Decodable {
    let recommendations: [AIRecommendation]
}


final class CoordinateAIManager {
    private let fetchWeatherUseCase: FetchCurrentWeatherUseCase
    private let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)

    init(fetchWeatherUseCase: FetchCurrentWeatherUseCase) {
        self.fetchWeatherUseCase = fetchWeatherUseCase
    }

    func fetchAndSend(availableCoordinates: [CoordinateDTO], tpo: String, season: String) async -> [(UUID, String)] {
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

            if let rawText = response.text {
                print("📥 Geminiの返答（生）:\n\(rawText)")
            }

            let cleanText = response.text?
                .replacingOccurrences(of: "```json", with: "")
                .replacingOccurrences(of: "```", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)

            guard let jsonData = cleanText?.data(using: .utf8),
                  let decoded = try? JSONDecoder().decode(AIResponse.self, from: jsonData) else {
                print("❌ Geminiレスポンスが不正 or デコードに失敗")
                return []
            }

            if decoded.recommendations.isEmpty {
                print("⚠️ Geminiが空の推薦を返しました。強制的に1件出力します。")
                if let fallback = availableCoordinates.first,
                   let fallbackUUID = UUID(uuidString: fallback.id) {
                    return [(fallbackUUID, "条件に最も近いセットを選びました")]
                }
            }

            return decoded.recommendations.compactMap { rec in
                guard let uuid = UUID(uuidString: rec.id) else { return nil }
                return (uuid, rec.reason)
            }

        } catch {
            print("❌ Gemini通信エラー: \(error)")
            return []
        }
    }

    private func makePromptText(from prompt: CoordinatePrompt) -> String {
        var text = """
        あなたはJSON形式だけを出力するAIです。以下のコーデ候補から、条件に最も適しているセットを最大3つ推薦してください。
        完全に一致するセットがない場合でも、条件に近い順に必ず最大3つを出力してください。

        出力形式:
        {
          "recommendations": [
            { "id": "UUID1", "reason": "理由1" },
            { "id": "UUID2", "reason": "理由2" }
          ]
        }

        条件:
        外気温: \(prompt.userCondition.outsideTemp)℃
        外湿度: \(prompt.userCondition.outsideHumidity)%
        オフィス気温: \(prompt.userCondition.officeTemp)℃
        オフィス湿度: \(prompt.userCondition.officeHumidity)%
        季節: \(prompt.userCondition.season)
        TPO: \(prompt.userCondition.tpo)

        候補:
        """

        for coord in prompt.availableCoordinates {
            text += "\n- id: \(coord.id), name: \(coord.name), season: \(coord.season), tpo: \(coord.tpoTag)"
        }

        text += "\n※他の文章を含めず、JSONのみを返してください。候補が少なくても1件以上は必ず出力してください。"
        return text
    }
}



final class RecommendationState: ObservableObject {
    @Published var recommendedSets: [(UUID, String)] = []
    @Published var lastUpdated: Date? = nil
    @Published var showPopup: Bool = false

    func shouldUpdateRecommendation() -> Bool {
        guard let last = lastUpdated else { return true }
        return Date().timeIntervalSince(last) > 6 * 60 * 60
    }
}

