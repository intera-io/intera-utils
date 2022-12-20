//
//  PDFKitRepresentedView.swift
//  Intera Utils
//
//  Created by Astemir Eleev on 19.12.2022.
//

import Foundation
import SwiftUI
import PDFKit
import Combine

struct PDFKitRepresentedView: UIViewRepresentable {
    typealias UIViewType = PDFView
    
    let url: URL?
    let data: Data?
    let singlePage: Bool
    @Binding var displayMode: PDFDisplayMode
    private var view: UIViewType?
    
    init(
        url: URL,
        singlePage: Bool = false,
        displayMode: Binding<PDFDisplayMode>,
        isPreviewMode: Bool = false
    ) {
        self.url = url
        self.singlePage = singlePage
        data = nil
        self._displayMode = displayMode
        
        view = prepare()
        
        if isPreviewMode {
            view?.autoScales = true
            view?.displayDirection = .vertical
            view?.pageShadowsEnabled = true
            view?.displaysPageBreaks = true
            view?.displayBox = .artBox
        }
    }
    
    init(
        data: Data,
        singlePage: Bool = false,
        displayMode: Binding<PDFDisplayMode>
    ) {
        self.data = data
        self.singlePage = singlePage
        url = nil
        self._displayMode = displayMode
        
        view = prepare()
    }
    
    func makeUIView(context _: UIViewRepresentableContext<PDFKitRepresentedView>) -> UIViewType {
        view?.autoScales = true
        view?.displayMode = displayMode
        return view!
    }
    
    func updateUIView(_ pdfView: UIViewType, context _: UIViewRepresentableContext<PDFKitRepresentedView>) {
        pdfView.document = prepare().document
        pdfView.displayMode = displayMode
    }
    
    func pageCount() -> Int {
        view?.document?.pageCount ?? 0
    }
    
    func page(at index: Int) -> PDFPage? {
        view?.document?.page(at: index)
    }
    
    func allPages(withThumbnailsOfSize size: CGSize, for displaybox: PDFDisplayBox) -> [PageModel] {
        var pages: [PageModel] = []
        for index in (0..<pageCount()) {
            guard let page = view?.document?.page(at: index) else {
                continue
            }
            pages += [PageModel(page: page, thimbnail: page.thumbnail(of: size, for: displaybox))]
        }
        return pages
    }
    
    struct PageModel: Identifiable {
        var id: UUID { .init() }
        let page: PDFPage
        let thimbnail: UIImage
    }
    
    func render(at index: Int, dimensions: ConvertionSizeView.Size = .original, backgroundColor: UIColor = .clear) -> UIImage? {
        guard let page = page(at: index) else {
            return nil
        }
        // Fetch the page rect for the page we want to render
        let pageRect = page.bounds(for: .mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        
        let img = renderer.image { ctx in
            // Set and fill the background color
            backgroundColor.set()
           
            ctx.fill(CGRect(x: 0, y: 0, width: pageRect.width, height: pageRect.height))
            // Translate the context so that we only draw the `cropRect`
            ctx.cgContext.translateBy(x: -pageRect.origin.x, y: pageRect.size.height - pageRect.origin.y)

            // Flip the context vertically because the Core Graphics coordinate system starts from the bottom
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            
            // Draw the PDF page
            page.draw(with: .mediaBox, to: ctx.cgContext)
        }
        
        var size: CGSize = img.size
        
        switch dimensions {
        case .quarter:
            size = CGSize(width: size.width / 4, height: size.height / 4)
            return img.scalePreservingAspectRatio(targetSize: size)
        case .half:
            size = CGSize(width: size.width / 2, height: size.height / 2)
            return img.scalePreservingAspectRatio(targetSize: size)
        case .original:
            return img
        }
    }
    
    private func prepare() -> PDFView {
        let pdfView = PDFView()
        switch (url, data) {
        case (let url, nil):
            pdfView.document = PDFDocument(url: url!)
        case (nil, let data):
            pdfView.document = PDFDocument(data: data!)
        default:
            fatalError()
        }
        
        return pdfView
    }
}
