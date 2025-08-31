//
//  LabelValueTextView.swift
//  Rest Countries
//
//  Created by Yaşar Çakır on 30.08.2025.
//

import SwiftUI

struct LabelValueTextView: View {
    let label: String
    let value: String
    var font: Font? = .footnote
    var body: some View {
        HStack(spacing: 4) {
            Text("\(label):")
                .font(font)
                .foregroundStyle(.primary)
                .fontWeight(.semibold)
            
            Text(value)
                .font(font)
                .fontWeight(.regular)
                .foregroundStyle(.primary)
        }
        
       
    }
}

#Preview {
    LabelValueTextView(label: "Label", value: "Value")
}
