//
//  HomeView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/12.
//

import SwiftUI

struct HomeView: View {
    @State private var isPresentingAddItem = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    WeatherView()
                        .padding(.top, 50)
                    CloseSelectView()
                        .padding(.top, 20)
                }

                // Floating Action Button
                Button(action: {
                    isPresentingAddItem = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.blue))
                        .shadow(radius: 5)
                }
                .padding()
                .sheet(isPresented: $isPresentingAddItem) {
                    AddItemView()
                }
            }
        }
    }
}
