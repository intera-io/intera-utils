//
//  PDFPreview.swift
//  Intera Utils
//
//  Created by Astemir Eleev on 19.12.2022.
//

import SwiftUI

struct PDFPreview: View {
   
    // MARK: - Properties
    
    @Binding private var pages: [PageModel]
    var width: CGFloat
    
    // MARK: - Conformance to View protocol
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [.init(.fixed(width))]) {
                ForEach(pages, id: \.id) { data in
                    cell(for: data)
                }
            }
            .padding()
            .overlay(alignment: .center) {
               emptyState
            }
            .fixedSize()
        }
        .transition(.move(edge: .leading))
    }
    
    // MARK: - Methods
    
    @ViewBuilder
    private var emptyState: some View {
        if pages.isEmpty {
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
    
    private func cell(for data: PageModel) -> some View {
        VStack {
            Image(uiImage: data.thimbnail)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width)
            
            Text(data.page.label ?? "err")
                .foregroundColor(.gray)
                .font(.system(.headline, design: .rounded))
        }
    }
}
