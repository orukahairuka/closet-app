//
//  HomeView.swift
//  closet-app
//
//  Created by 櫻井絵理香 on 2025/06/12.
//

import SwiftUI

enum HomeNavigation: Hashable {
    case addItem
}

struct HomeView: View {
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    WeatherView()
                        .padding(.top, 50)
                    CloseSelectView()
                        .padding(.top, 20)
                    ClosetItemListView()
                }

                Button(action: {
                    navigationPath.append(HomeNavigation.addItem)
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.blue))
                        .shadow(radius: 5)
                }
                .padding()
            }
            .navigationDestination(for: HomeNavigation.self) { route in
                switch route {
                case .addItem:
                    AddClosetItemView()
                }
            }
        }
    }
}
