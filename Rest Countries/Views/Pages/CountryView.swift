//
//  CountryView.swift
//  Rest Countries
//
//  Created by Yaşar Çakır on 27.08.2025.
//

import SwiftUI

struct CountryView: View {
    let code: String
    var body: some View {
        Text(code)
    }
}

#Preview {
    CountryView(code: "TR")
}
