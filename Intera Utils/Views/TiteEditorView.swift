//
//  TiteEditorView.swift
//  Intera Utils
//
//  Created by Astemir Eleev on 19.12.2022.
//

import SwiftUI

struct TiteEditorView: View {

    var pdfView: PDFKitRepresentedView?
    @Binding var convertionQuality: ConvertionQualityView.Quality
    @Binding var url: URL?
    @Binding var exportingCollection: [ImageDocument]
    @Binding var showingImporter: Bool
    @Binding var showingExporter: Bool
    
    var body: some View {
        Button(action: { showingImporter.toggle() }) {
            Image(systemName: "doc.on.doc")
            Text("Open .pdf file")
        }
        Button(action: {
            showingExporter.toggle()
            Task {
                if let pdfView {
                    exportingCollection = []
                    for index in 0..<pdfView.pageCount() {
                        exportingCollection += [
                            .init(image: pdfView.render(at: index, dimensions: .half), quality: convertionQuality.value, name: "\(index + 1)")
                        ]
                    }
                }
            }
        }) {
            Image(systemName: "square.and.arrow.down.on.square")
            Text("Convert to .jpeg")
        }
        .disabled(url == nil)

    }
}
