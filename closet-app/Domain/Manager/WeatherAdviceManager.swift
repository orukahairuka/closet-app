//
//  WeatherAdviceManager.swift
//  closet-app
//
//  Created by shorei on 2025/06/21.
//

import Foundation
import GoogleGenerativeAI

final class WeatherAdviceManager {
    private let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)

    enum WeatherAdviceError: Error {
        case responseParsingFailed
        case emptyResponce
        case networkError(Error)
    }

    func getAdviceForWeather(temperature: Double, condition: String) async throws -> String {
        let promptText = """
        あなたはプロのファッションアドバイザーです。
        
        以下の気象条件に対して、快適に過ごすための服装のポイントや工夫を**日本語で1文・50文字以内**でアドバイスしてください。
        
        【条件】
        気温: \(temperature)℃
        天気: \(condition)
        
        【制約】
        - 「気温」「天気」などの説明を繰り返さない
        - 「Tシャツ」「カーディガン」などの服のアイテム名、または、「薄手の素材」「通気性のある服」「重ね着しやすい服」など表現を使っても良い
        - 日差し、風、湿度など天候に応じた注意点・対策も含めてOK
        - 「〜しましょう」「〜がおすすめです」など丁寧語で自然に締めてください
        - 出力はアドバイス本文のみ。他の説明は不要
        """


        do {
            let response = try await model.generateContent(promptText)

            if let advice = response.text?.trimmingCharacters(in: .whitespacesAndNewlines), !advice.isEmpty {
                return advice
            } else {
                throw WeatherAdviceError.emptyResponce
            }
        } catch {
            throw WeatherAdviceError.networkError(error)
        }
    }

}
