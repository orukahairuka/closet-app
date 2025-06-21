//
//  CoordinateSuggestionView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/14.
//

import SwiftUI

struct CoordinateSuggestionView: View {
    @ObservedObject var viewModel: CoordinateSuggestionViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // AIアドバイスの吹き出し
            VStack(alignment: .leading, spacing: 8) {
                Text("今日のコーディネートアドバイス")
                    .font(.headline)
                    .padding(.horizontal)

                HStack(alignment: .top) {
                    Image(systemName: "bubble.left.fill")
                        .foregroundColor(.blue.opacity(0.7))
                        .font(.title2)

                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )

                        if viewModel.isLoading {
                            ProgressView()
                                .padding()
                        } else {
                            Text(viewModel.aiAdvice)
                                .padding()
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)

            LottieView(animationName: "navigator", loopMode: .loop)
                .frame(height: 200)
                .padding(.horizontal)

        }
        .padding(.vertical)
    }
}
