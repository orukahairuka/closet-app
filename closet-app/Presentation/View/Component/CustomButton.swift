//
//  CustomButton.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/21.
//

import SwiftUI

struct CustomButton: View {
    var action: () -> Void
    var isSelected: Bool
    var animation: Namespace.ID

    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                action()
            }
        }) {
            ZStack {
                // 外円（白の縁取り）
                Circle()
                    .stroke(Color.white.opacity(0.8), lineWidth: 6)
                    .frame(width: 200, height: 200)

                // 内円（サーモンピンク・赤寄り）
                Circle()
                    .fill(Color(red: 244/255, green: 140/255, blue: 140/255)) // #F48C8C
                    .frame(width: 190, height: 190)

                // アイコン（白系）
                Image("weather_robot_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 125, height: 125)
                    .foregroundColor(isSelected ? .white : .white.opacity(0.7))
                    .offset(x: 35, y: -20)
            }






        }
    }
}
