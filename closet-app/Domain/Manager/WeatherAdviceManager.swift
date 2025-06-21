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
                あなたはファッションアドバイザーです。以下の条件に基づいて、50文字以内の短い服装アドバイスを日本語で考えてください:
                
                気温: \(temperature)℃
                天気: \(condition)
                
                服装の選び方のヒントを簡潔に教えてください。余計な説明は省き、アドバイスのみを返してください。
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
