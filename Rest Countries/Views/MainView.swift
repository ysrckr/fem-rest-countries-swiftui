//
//  MainView.swift
//  Rest Countries
//
//  Created by Yaşar Çakır on 27.08.2025.
//

import SwiftUI

struct MainView: View {
    let code: String
    var body: some View {
        NavigationStack() {
            CountriesView()
        }
    }
}

#Preview {
    MainView(code: "TR")
}
