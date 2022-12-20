//
//  ImageDocument.swift
//  Intera Utils
//
//  Created by Astemir Eleev on 19.12.2022.
//

import Foundation
import UIKit
import PDFKit
import SwiftUI
import UniformTypeIdentifiers

struct ImageDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.jpeg, .png, .tiff] }
    var image: UIImage
    var name: String = ""
    var quality: CGFloat = 1.0
    
    init(image: UIImage?, quality: CGFloat = 1.0, name: String = "") {
        self.image = image ?? UIImage()
        self.quality = quality
        self.name = name
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let image = UIImage(data: data)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.image = image
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let file =  FileWrapper(regularFileWithContents: image.jpegData(compressionQuality: quality)!) // TODO:
        file.filename = name
        return file
    }
}
