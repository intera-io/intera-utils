//
//  ContentView.swift
//  Intera Utils
//
//  Created by Astemir Eleev on 12.12.2022.
//

import SwiftUI
import PDFKit
import Combine
import UniformTypeIdentifiers

typealias PageModel = PDFKitRepresentedView.PageModel
let width: CGFloat = 100
let thumbnailSize = CGSize(width: 200, height: 200)

struct ContentView: View {

    // MARK: - Properties
    
    @SceneStorage("display-mode") private var displayModeSelection: PDFDisplayMode = .twoUpContinuous
    @SceneStorage("convertion-quality") private var convertionQuality: ConvertionQualityView.Quality = .original
    @SceneStorage("convertion-size") private var convertionSize: ConvertionSizeView.Size = .original

    @State private var isPreviewSidebarVisible: Bool = true
    
    @State private var pages: [PageModel] = []
    
    @State private var showingExporter = false
    @State private var exportingCollection: [ImageDocument] = []
    
    @State private var showingImporter = false
    @State private var url: URL? = nil
    
    var pdfView: PDFKitRepresentedView {
        PDFKitRepresentedView(url: url!, displayMode: $displayModeSelection)
    }
    
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    var emptyState: some View {
        VStack {
            Image(systemName: "doc")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width)
                .foregroundColor(.gray)
            Text("Import a .pdf")
                .font(.system(.title, design: .rounded, weight: .bold))
        }
    }
    
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarLeading) {
            Button(action: {
                withAnimation {
                    isPreviewSidebarVisible.toggle()
                }
            }) {
                Image(systemName: "sidebar.squares.leading")
            }
            .disabled(url == nil)
        }
        
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            PDFDisplayModeView(selection: $displayModeSelection)
                .disabled(url == nil)
            Divider()
                .rotationEffect(.degrees(-90))
        }
        
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Group {
                ConvertionQualityView(selection: $convertionQuality)
                ConvertionSizeView(selection: $convertionSize)
            }
            .disabled(url == nil)
        }
    }
    
    // MARK: - Computed Properties
    
    var body: some View {
        NavigationStack {
            ZStack {
                if url != nil {
                    HStack {
                        if isPreviewSidebarVisible {
                            PDFKitRepresentedView(
                                url: url!,
                                singlePage: true,
                                displayMode: .constant(.singlePageContinuous),
                                isPreviewMode: true
                            )
                            .frame(width: width)
                        }
                        pdfView
                    }
                    .task(priority: .userInitiated) {
                        Task {
                            pages = pdfView.allPages(withThumbnailsOfSize: thumbnailSize, for: .artBox)
                        }
                    }
                } else {
                    emptyState
                }
            }
            .toolbarRole(.editor)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(url?.lastPathComponent ?? "File Menu")
            .toolbarTitleMenu {
                TiteEditorView(
                    pdfView: url == nil ? nil : pdfView,
                    convertionQuality: $convertionQuality,
                    url: $url,
                    exportingCollection: $exportingCollection,
                    showingImporter: $showingImporter,
                    showingExporter: $showingExporter
                )
            }
            .disabled(showingExporter)
            .opacity(showingExporter ? 0.25 : 1.0)
            .overlay(alignment: .center) {
                if showingExporter {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
            .toolbar { toolbar }
            .fileImporter(isPresented: $showingImporter, allowedContentTypes: [.pdf], onCompletion: { result in
                switch result {
                case .success(let success):
                    url = success
                case .failure(_):
                    let value = try? result.get()
                    errorMessage = value?.description ?? "Failed"
                }
            })
            .fileExporter(
                isPresented: $showingExporter,
                documents: exportingCollection,
                contentType: .jpeg
            ) { result in
                switch result {
                case .success(let url):
                    print("Saved to \(url)")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                exportingCollection = []
            }
        }
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Import Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("Ok"))
            )
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
