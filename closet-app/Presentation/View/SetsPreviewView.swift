//
//  SetsPreviewView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/20.
//

import SwiftUI
import SwiftData

struct SetsPreviewView: View {
    @Query private var allSets: [CoordinateSetModel]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(allSets) { set in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(set.name)
                                    .font(.headline)
                                Spacer()
                                Text(set.createdAt, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            HStack {
                                Text("季節: \(set.season.displayName)")
                                Spacer()
                                Text("TPO: \(set.tpoTag.displayName)")
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                            Text("含まれるアイテム数: \(set.itemIDs.count) 点")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)
                    }

                    if allSets.isEmpty {
                        Text("作成されたセットがありません")
                            .foregroundColor(.gray)
                            .padding(.top, 40)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("コーデ一覧")
        }
    }
}
