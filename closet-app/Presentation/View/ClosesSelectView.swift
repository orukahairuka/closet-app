//
//  ClosesSelectView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/12.
//

import SwiftUI
import Parchment

struct CloseSelectView: View {
    var body: some View {
        VStack {
            //天気予報画面
            WeatherView()
            //服の選択画面
            PageView {
                Page { state in
                    Image(systemName: "house.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .scaleEffect(1 + 0.5 * abs(state.progress))
                } content: {
                    Text("ホーム")
                        .font(.largeTitle)
                }

                Page { state in
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .scaleEffect(1 + 0.5 * abs(state.progress))
                } content: {
                    Text("設定")
                        .font(.largeTitle)
                }

                Page { state in
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .scaleEffect(1 + 0.5 * abs(state.progress))
                } content: {
                    Text("プロフィール")
                        .font(.largeTitle)
                }
            }
            .menuItemSize(.fixed(width: 60, height: 60))
            .indicatorColor(.blue)
            .menuPosition(.top)
        }
    }
}
