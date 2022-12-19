//
//  ConvertionSizeView.swift
//  Intera Utils
//
//  Created by Astemir Eleev on 19.12.2022.
//

import SwiftUI

struct ConvertionSizeView: View {
    enum Size: String, CaseIterable, Identifiable {
        case quarter, half, original
        var id: Self { self }
    }

    @Binding var selection: Size
    
    var body: some View {
        Picker("Convertion Size", selection: $selection) {
            HStack {
                Image(systemName: "rectangle.split.2x2.fill")
                Text("25%")
            }
            .tag(Size.quarter)
            
            HStack {
                Image(systemName: "rectangle.tophalf.inset.filled")
                Text("50%")
            }
            .tag(Size.half)
            
            HStack {
                Image(systemName: "rectangle.inset.filled")
                Text("100%")
            }
            .tag(Size.original)
        }
    }
    
}
