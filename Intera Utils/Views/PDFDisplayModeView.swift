//
//  PDFDisplayModeView.swift
//  Intera Utils
//
//  Created by Astemir Eleev on 19.12.2022.
//

import SwiftUI
import PDFKit

struct PDFDisplayModeView: View {
    @Binding var selection: PDFDisplayMode
    
    var body: some View {
        Picker("DisplayMode", selection: $selection) {
            
            Text("Single Page")
                .tag(PDFDisplayMode.singlePage)
            Text("Single Page Continuous")
                .tag(PDFDisplayMode.singlePageContinuous)
            Text("Two Up")
                .tag(PDFDisplayMode.twoUp)
            Text("Two Up Continuous")
                .tag(PDFDisplayMode.twoUpContinuous)
        }
    }    
}
