//
//  AddClosetItemView.swift
//  closet-app
//
//  Created by shorei on 2025/06/12.
//

import SwiftUI
import SwiftData

struct AddClosetItemView: View {
    @Environment(\.modelContext) private var context

    @State private var selectedCategory: Category = .tops
    @State private var selectedSeason: Season = .spring
    @State private var image: UIImage? = nil
    @State private var showImagePicker = false
    @State private var urlText: String = ""
    @State private var selectedSetID: UUID? = nil
    @State private var selectedTPO: TPO = .office
    @State private var showAddSetSheet = false
    @Binding var allSets: [CoordinateSetModel]
    @State private var showCameraView = false
    @StateObject private var captureModel = AVCaptureViewModel()


    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                // MARK: - 画像選択
                VStack(alignment: .leading, spacing: 12) {
                    Text("アイテム画像")
                        .font(.headline)
                        .foregroundStyle(.primary)

                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                            .frame(height: 200)

                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 180)
                                .cornerRadius(8)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.secondary)
                        }
                    }

                    HStack {
                        Spacer()

                        Button("画像を選択") {
                            showImagePicker = true
                        }
                        .buttonStyle(.bordered)
                        .tint(.accentColor)

                        Spacer()

                        Button(action: {
                            showCameraView = true
                        }) {
                            Image(systemName: "camera")
                                .font(.title)
                                .foregroundColor(.accentColor)
                                .padding(8)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(Circle())
                        }
                    }

                }

                Divider()

                // MARK: - カテゴリ
                section(title: "カテゴリ") {
                    Picker("カテゴリ", selection: $selectedCategory) {
                        ForEach(Category.allCases) { category in
                            Text(category.displayName).tag(category)
                        }
                    }
                }

                Divider()

                // MARK: - 季節
                section(title: "季節") {
                    Picker("季節", selection: $selectedSeason) {
                        ForEach(Season.allCases) { season in
                            Text(season.displayName).tag(season)
                        }
                    }
                }

                Divider()

                // MARK: - URL
                VStack(alignment: .leading, spacing: 12) {
                    Text("商品URL")
                        .font(.headline)
                    TextField("https://example.com", text: $urlText)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                }

                Divider()

                // MARK: - TPO
                section(title: "TPO") {
                    Picker("TPO", selection: $selectedTPO) {
                        ForEach(TPO.allCases) { tpo in
                            Text(tpo.displayName).tag(tpo)
                        }
                    }
                }

                SaveButtonView {
                    saveItem()
                }
                .frame(height: 50)
                .tint(.accentColor)
                .padding(.bottom)
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $image)
        }
        .sheet(isPresented: $showAddSetSheet) {
            AddSetSheetView { newSet in
                context.insert(newSet)
                try? context.save()
                allSets.append(newSet)
                selectedSetID = newSet.id
            }
        }
        .sheet(isPresented: $showCameraView) {
            NavigationStack {
                ContentView(captureModel: captureModel) {
                    showCameraView = false
                }
            }
        }
    }

    // Picker用の共通セクション
    @ViewBuilder
    private func section<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content()
                .pickerStyle(.menu)
                .tint(.primary)
        }
    }

    private func saveItem() {
        let data = image?.jpegData(compressionQuality: 0.8)
        let newItem = ClosetItemModel(
            imageData: data,
            category: selectedCategory,
            season: selectedSeason,
            productURL: URL(string: urlText),
            tpoTag: selectedTPO
        )
        context.insert(newItem)

        if let selectedID = selectedSetID,
           let set = allSets.first(where: { $0.id == selectedID }) {
            set.itemIDs.append(newItem.id)
        }

        try? context.save()
    }
}
