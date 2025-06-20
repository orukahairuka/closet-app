//
//  CoordinateDTO.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/21.
//

import Foundation

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

// Geminiから返ってくるID一覧
struct AIResponse: Decodable {
    let recommendedSetIDs: [String]
}
