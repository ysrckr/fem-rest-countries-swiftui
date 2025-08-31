//
//  MainView.swift
//  Rest Countries
//
//  Created by Yaşar Çakır on 27.08.2025.
//

import SwiftUI

struct MainView: View {
    @Environment(\.colorScheme) var colorScheme
    let code: String
    var body: some View {
        NavigationStack() {
            CountriesView()
                
        }
        .tint(colorScheme == .dark ? .white : .black)
    }
}

#Preview {
    MainView(code: "TR")
}
