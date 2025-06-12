//
//  AddItemView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/12.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("アイテムを追加")
                .font(.title)

            // ここに入力フォームを追加予定
            Button("閉じる") {
                dismiss()
            }
        }
        .padding()
    }
}
