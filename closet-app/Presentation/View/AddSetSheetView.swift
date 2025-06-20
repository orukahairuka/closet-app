//
//  AddSetSheetView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/20.
//

import SwiftUI

struct AddSetSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var selectedSeason: Season = .spring
    @State private var selectedTPO: TPO = .school
    @State private var allSets: [CoordinateSetModel] = []


    var onComplete: (CoordinateSetModel) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("セット名")) {
                    TextField("例: 春の通学コーデ", text: $name)
                }

                Section(header: Text("季節")) {
                    Picker("季節", selection: $selectedSeason) {
                        ForEach(Season.allCases) { season in
                            Text(season.displayName).tag(season)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section(header: Text("TPO")) {
                    Picker("TPO", selection: $selectedTPO) {
                        ForEach(TPO.allCases) { tpo in
                            Text(tpo.displayName).tag(tpo)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            .navigationTitle("新しいセット")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        let newSet = CoordinateSetModel(
                            name: name,
                            itemIDs: [],
                            season: selectedSeason,
                            tpoTag: selectedTPO
                        )
                        onComplete(newSet)
                        dismiss()
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
            }
        }
    }
}
