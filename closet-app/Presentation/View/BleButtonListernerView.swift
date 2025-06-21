//
//  BleButtonListernerView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/22.
//

import SwiftUI

struct BleTemperatureView: View {
    @StateObject private var viewModel = BleTemperatureViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("🌡️ 温度受信テスト")
                .font(.title)

            if let temp = viewModel.temperature {
                Text("現在の温度: \(String(format: "%.1f", temp)) ℃")
                    .font(.title2)
                    .bold()
            } else {
                Text("温度を受信中...")
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
    }
}
