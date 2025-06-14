//
//  ClothingLevel.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/14.
//

import Foundation

enum ClothingLevel: Int {
    case veryCold = 1    // 超厚着（真冬）
    case cold = 2        // 厚着（冬）
    case normal = 3      // 普通
    case warm = 4        // 薄着（春秋）
    case hot = 5         // 超薄着（夏）

    var label: String {
        switch self {
        case .veryCold: return "🧥 厚着（真冬）"
        case .cold: return "🧣 少し寒め"
        case .normal: return "👕 普通"
        case .warm: return "👚 少し暑め（薄着）"
        case .hot: return "👙 暑いので超薄着（真夏）"
        }
    }
}
