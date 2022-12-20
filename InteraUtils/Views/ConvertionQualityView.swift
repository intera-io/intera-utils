//
//  ConvertionQualityView.swift
//  Intera Utils
//
//  Created by Astemir Eleev on 19.12.2022.
//

import Foundation
import SwiftUI

struct ConvertionQualityView: View {
    enum Quality: String, CaseIterable, Identifiable {
        case low, mid, high, original
        var id: Self { self }
        
        var value: CGFloat {
            switch self {
            case .low:
                return 0.25
            case .mid:
                return 0.5
            case .high:
                return 0.75
            case .original:
                return 1.0
            }
        }
    }

    @Binding var selection: Quality
    
    var body: some View {
        Picker("Convertion Quality", selection: $selection) {
            HStack {
                Image(systemName: "s.circle.fill")
                Text("25%")
            }
            .tag(Quality.low)
            
            HStack {
                Image(systemName: "m.circle.fill")
                Text("50%")
            }
            .tag(Quality.mid)
            
            HStack {
                Image(systemName: "l.circle.fill")
                Text("75%")
            }
            .tag(Quality.high)
            
            HStack {
                Image(systemName: "o.circle.fill")
                Text("100%")
            }
            .tag(Quality.original)
        }
    }
    
}
